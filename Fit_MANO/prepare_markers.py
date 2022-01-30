
import mano
from psbody.mesh import MeshViewers, Mesh, MeshViewer
import numpy as np





if __name__ == '__main__':


    rhm_path = '/ps/project/grab/body_models/models/mano/MANO_RIGHT.pkl'
    rh_m = mano.load(model_path=rhm_path,
                     model_type='mano',
                     num_pca_comps=45,
                     batch_size=1,
                     flat_hand_mean=True)

    rh_mesh = Mesh(v=rh_m.v_template.numpy(), f = rh_m.faces)
    rh_mesh.write_ply('data/mean_hand.ply')
