import json
import time
import mano
import argparse

import torch
from torch.optim.lbfgs import LBFGS

from scipy.io import loadmat
import numpy as np

from psbody.mesh.colors import name_to_rgb
from psbody.mesh import MeshViewers, MeshViewer, Mesh
from psbody.mesh.lines import Lines

from tools.vis_tools import points_to_spheres
from tools.utils import to_np, concat_data

from scipy import io

use_cuda = torch.cuda.is_available()
device = torch.device("cuda" if use_cuda else "cpu")

def vis_hand(frame, mvs):
    print( 'Fitting frame:  %d'%frame)

    def on_step(rhm,
                rh_mocap):

        rh_mocap_np = np.array(rh_mocap['locations']).reshape(-1, 3)
        label_ids = torch.tensor(rh_mocap['labels']).to(device).to(torch.long)

        rh_out = rhm(return_tips = True)

        rh_mocap_np_opt = rh_out.vertices[:,label_ids].detach().cpu().numpy().reshape(-1, 3)

        r_spheres = points_to_spheres(rh_mocap_np, radius=0.002, color = np.array((0., 0.5, 0.)))  # blue
        r_spheres_opt = points_to_spheres(rh_mocap_np_opt, radius=0.002, color = np.array((0., 0., 0.5)))  # red

        ##### hand skeleton
        # hand_skeleton_r = Lines(rh_mocap_np, hand_skeleton_e, vc = np.array((1., 1., 0.)))

        ##########################

        line_v_idxs_r = np.arange(len(rh_mocap_np))
        line_vs_r = np.vstack([rh_mocap_np_opt, rh_mocap_np])
        line_es_r = np.array(list(zip(line_v_idxs_r, line_v_idxs_r + len(rh_mocap_np))))
        lines_r = Lines(line_vs_r, line_es_r, vc=np.array((1, 0., 0.)))

        # message = ' -- %s' % (' | '.join(['%s = %2.2e' % (k, np.sum(v)) for k, v in opt_objs.iteritems()]))
        # mvs[0][0].set_titlebar(message)
        with torch.no_grad():
            mvs[0][0].set_static_meshes([r_spheres, r_spheres_opt]  , blocking=True)
            mvs[0][0].set_dynamic_meshes([Mesh(v=rh_out.vertices.cpu().numpy().squeeze(), f=rhm.faces, vc=name_to_rgb['pink'])],  blocking=True)
            mvs[0][0].set_static_lines([lines_r])
            mvs[0][1].set_static_meshes([r_spheres])
            # time.sleep(.1)
            # mvs[0][0].set_static_lines([hand_skeleton_r])

    return on_step

def ik_fit(weights,
           optimizer,
           rhm,
           rh_mocap,
           cfg,
           on_step=None,
           create_graph=False,
           gstep=0):

    rh_markers = torch.from_numpy(rh_mocap['locations']).to(device)
    label_ids  = torch.tensor(rh_mocap['labels']).to(device).to(torch.long)

    def fit(backward = True,visualize=True):

        fit.gstep += 1
        optimizer.zero_grad()

        opt_objs = {
            "data_r": torch.pow(rhm(return_tips=True).vertices[0,label_ids] - rh_markers, 2),
            "betas_r": torch.pow(rhm.betas, 2),
            }

        opt_objs = {k: opt_objs[k] * v for k, v in weights.items()}

        loss_total = torch.sum(torch.stack([torch.sum(v.view(v.shape[0], -1), dim=1).mean() for v in opt_objs.values()]))

        if backward:
            loss_total.backward(create_graph=create_graph)

        if on_step is not None and visualize:

            if cfg.verbose:
                message = 'it %.5d -- %s' % (
                fit.gstep, ' | '.join(['%s = %2.2e' % (k, torch.sum(v)) for k, v in opt_objs.items()]))
                print((message))
                print( f'objective weights : {weights}')

            on_step(rhm=rhm,
                    rh_mocap=rh_mocap)

        return loss_total

    fit.gstep = gstep

    return fit

def fitting(cfg):


    bs_betas = []
    bs_betas.append(cfg.betas_in)
    print('betas: ', bs_betas)
    # bs_betas = [[-0.8675575631077455, -1.985191135449365, -0.9723222402368097, 1.1384598646344966, 0.24191992675565302, 0.060562562539139546, 2.043613380943857, 0.19748757787490984, 1.4086727118611564, -0.04802949170658211]]
    # bs_betas = [[-3.8675575631077455, 3.985191135449365, 4.9723222402368097, 1.1384598646344966, 0.24191992675565302, 0.060562562539139546, 2.043613380943857, 0.19748757787490984, 1.4086727118611564, -0.04802949170658211]]
    # bs_betas = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

    if cfg.visualize:
        mvs = MeshViewers(window_width=2000, window_height=800, shape=[1, 2])

    # load pytorch models ############
    rhm = mano.load(model_path=cfg.rhm_path,
                    is_rhand=True,
                    num_pca_comps=cfg.n_pca_comps,
                    batch_size=1,
                    flat_hand_mean=True,
                    betas=bs_betas).to(device)


    marker_locs = np.array(loadmat(cfg.sequence_data)['frame']).reshape(21,-1, 3).transpose(1, 0, 2)

    bs = marker_locs.shape[0]

    labels = np.array(loadmat(cfg.marker_labels)['mks']).reshape(-1)
    labels = np.array([labels[i].item() for i in range(len(labels))])

    marker_settings = json.load(open(cfg.marker_settings, 'rb'))['rh']
    verts_ids = np.array([marker_settings[k] for k in labels])


    rhand_data =  {
        'vertices':[],
        'global_orient':[],
        'hand_pose':[],
        'transl':[],
        'full_pose':[],
        'joints': [],
        'markers': [],
        'labels': [],
    }
    n_frames = marker_locs.shape[0]
    # for fidx in range(n_frames):
    cnt = 0
    for fidx in range(cfg.fr_in, cfg.fr_end + 1):

        start = time.time()

        frame_markers = marker_locs[fidx] * 0.001 #convert to meters
        not_nan = (frame_markers==frame_markers).all(axis=-1)
        rh_mocap = {'locations':frame_markers[not_nan] , 'labels': verts_ids[not_nan]}

        if cfg.visualize:
            on_step = vis_hand(frame=fidx, mvs=mvs)
        else:
            on_step = None


        parms_for_torch(rhm,
                        rh_mocap,
                        cfg,
                        on_step,
                        optimize_betas=cfg.optimize_betas)

        with torch.no_grad():
            rh_output = rhm(return_vertices = True)

            rhand_data['vertices'].append(to_np(rh_output.vertices))
            rhand_data['joints'].append(to_np(rh_output.joints))
            rhand_data['global_orient'].append(to_np(rhm.global_orient))
            rhand_data['hand_pose'].append(to_np(rhm.hand_pose))
            rhand_data['transl'].append(to_np(rhm.transl))
            rhand_data['full_pose'].append(to_np(rh_output.full_pose))
            rhand_data['markers'].append(frame_markers[not_nan])
            rhand_data['labels'].append(verts_ids[not_nan])
        if cnt == 0:
            out_v = []
            out_f = []
        out_v.append(rhm.hand_meshes(rh_output)[0].vertices.view(np.ndarray) * 1000)
        out_f.append(rhm.hand_meshes(rh_output)[0].faces.view(np.ndarray))
        print( 'frame %d / %d,  took %f seconds' % (fidx, bs ,time.time() - start))

        cnt += 1
    #io.savemat('/home/diego/Desktop/Diego_MSRM/Research/Experiments/Framework_Contact_Surface_detection/Contact-level human manipulation/verts_opt_test.mat', {'output_vertices': output_vertices})
    #io.savemat('/home/diego/Desktop/Diego_MSRM/Research/Experiments/Framework_Contact_Surface_detection/Contact-level human manipulation/faces_opt_test.mat', {'output_faces': output_faces})
    #io.savemat('./verts_opt.mat', {'output_vertices': out_v})
    #io.savemat('./faces_opt.mat', {'output_faces': out_f})
    io.savemat(cfg.vert_name, {'out_v': out_v})
    io.savemat(cfg.face_name, {'out_f': out_f})

    rhand_data = concat_data(rhand_data)
    save_path = cfg.sequence_data.replace('.mat', '_fit.npy')
    np.save(save_path, rhand_data)
    if cfg.visualize:
        mvs[0][0].close()
    print( 'Python script successfully finished!')

def parms_for_torch(rhm,
                    rh_mocap,
                    cfg,
                    on_step=None,
                    optimize_betas=False):

    # optimize for global transformation
    free_vars = [rhm.global_orient, rhm.transl]

    if optimize_betas:
        free_vars +=[rhm.betas]

    optimizer = LBFGS(free_vars,
                      lr=0.5e-1,
                      max_iter=150,
                      line_search_fn='strong_wolfe',
                      tolerance_grad=1e-9,
                      tolerance_change=1e-11)
    optimizer.zero_grad()
    gstep = 0

    for w in [{'data_r': 10., 'betas_r': .1, }]:

        closure = ik_fit(w, optimizer, rhm, rh_mocap, cfg, on_step=on_step, gstep=gstep)
        optimizer.step(closure)
        gstep = closure.gstep

    # optimize for pose
    free_vars = [rhm.hand_pose, rhm.transl, rhm.global_orient]

    if optimize_betas:
        free_vars +=[rhm.betas]

    optimizer = LBFGS(free_vars,
                      lr=1.5e-1,
                      max_iter=80,
                      line_search_fn='strong_wolfe',
                      tolerance_grad=0.5e-7,
                      tolerance_change=2e-6)
    optimizer.zero_grad()

    for w in [{'data_r': 10., 'betas_r': 10, }]:
        closure = ik_fit(w, optimizer, rhm, rh_mocap, cfg, on_step=on_step, gstep=gstep)

        optimizer.step(closure)
        gstep = closure.gstep



if __name__== '__main__':

    from omegaconf import OmegaConf
    import cProfile, pstats

    parser = argparse.ArgumentParser(description='Fitting markers HMCLab recordings')

    parser.add_argument('--sequencedata', required = True, type=str,
                        help='The path to the complete data .mat file')

    parser.add_argument('--vert_name', required = True, type=str,
                        help='The name of mat file containing the resulting vertices after optimization')

    parser.add_argument('--face_name', required = True, type=str,
                        help='The name of mat file containing the resulting faces after optimization')

    parser.add_argument('--betas', required = True, nargs = '+', type=float,
                        help='Betas vector to change hand shape')

    parser.add_argument('--fr_in', required = True, type=int,
                        help='Intial Frame of interest')

    parser.add_argument('--fr_end', required = True, type=int,
                        help='Final Frame of interest')

    args = parser.parse_args()

    cfg = {
        'sequence_data': args.sequencedata,
        'visualize' : True,
        #'optimize_betas' : True,
        'optimize_betas' : False, # his allows external control of the betas vector (i.e. shape of the hand model)
        'n_pca_comps' : 45,

        'lhm_path' : './Fit_MANO/mano/MANO_LEFT.pkl',
        'rhm_path' : './Fit_MANO/mano/MANO_RIGHT.pkl',

        'marker_settings' : './Fit_MANO/config/markers_setting.json',
        'marker_labels': './Fit_MANO/data/markers.mat',

        'verbose': False,

        'betas_in': args.betas,
        'fr_in': args.fr_in,
        'fr_end': args.fr_end,

        'vert_name': args.vert_name,
        'face_name': args.face_name
    }

    cfg = OmegaConf.create(cfg)
    #fitting(cfg)

    # These lines were added to get the profiling of the code
    pr = cProfile.Profile()
    pr.enable()
    fitting(cfg)
    pr.disable()
    stats = pstats.Stats(pr)
    stats.sort_stats(pstats.SortKey.TIME)
    stats.print_stats()
    stats.dump_stats(filename='needs_profiling.prof')

