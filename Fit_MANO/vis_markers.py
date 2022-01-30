
import mano
from psbody.mesh import MeshViewers, Mesh, MeshViewer
from psbody.mesh.colors import name_to_rgb
import numpy as np

from tools.vis_tools import points_to_spheres
import json




if __name__ == '__main__':


    marker_setting_path = 'config/markers_setting.json'

    with open(marker_setting_path, 'rb') as f:
        markers_setting = json.load(f)
    markers_id = list(markers_setting['rh'].values())

    rh_mesh = Mesh(filename='data/mean_hand.ply', vc = name_to_rgb['blue'])


    markers_mesh = points_to_spheres(rh_mesh.v[markers_id], radius=.002, vc=name_to_rgb['red'])

    mvs = MeshViewer()
    mvs.set_static_meshes([rh_mesh, markers_mesh])
    rh_mesh.concatenate_mesh(markers_mesh)
    rh_mesh.write_ply('data/rh_markers.ply')
    print('wait')
