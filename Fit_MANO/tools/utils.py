
# -*- coding: utf-8 -*-
#
# Copyright (C) 2019 Max-Planck-Gesellschaft zur Förderung der Wissenschaften e.V. (MPG),
# acting on behalf of its Max Planck Institute for Intelligent Systems and the
# Max Planck Institute for Biological Cybernetics. All rights reserved.
#
# Max-Planck-Gesellschaft zur Förderung der Wissenschaften e.V. (MPG) is holder of all proprietary rights
# on this computer program. You can only use this computer program if you have closed a license agreement
# with MPG or you get the right to use the computer program from someone who is authorized to grant you that right.
# Any use of the computer program without a valid license is prohibited and liable to prosecution.
# Contact: ps-license@tuebingen.mpg.de
#


import numpy as np
import torch
import logging
from copy import copy

import torch.nn.functional as F


device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
to_cpu = lambda tensor: tensor.detach().cpu().numpy()

def concat_data(item):
    out = {}
    for k, v in item.items():
        if v ==[]:
            continue
        if isinstance(v, list):
            try:
                out[k] = np.array(np.concatenate(v))
            except:
                out[k] = np.array(np.array(v))
        elif isinstance(v, dict):
            out[k] = concat_data(v)
        else:
            out[k] = np.array(v)
    return out



def to_np(array, dtype=np.float32):
    if 'scipy.sparse' in str(type(array)):
        array = np.array(array.todencse(), dtype=dtype)
    elif torch.is_tensor(array):
        array = array.detach().cpu().numpy()
    return array

def batch_to(dst, *args):
    return [x.to(dst) if x is not None else None for x in args]




def makepath(desired_path, isfile = False):
    '''
    if the path does not exist make it
    :param desired_path: can be path to a file or a folder name
    :return:
    '''
    import os
    if isfile:
        if not os.path.exists(os.path.dirname(desired_path)):os.makedirs(os.path.dirname(desired_path))
    else:
        if not os.path.exists(desired_path): os.makedirs(desired_path)
    return desired_path

def makelogger(log_dir,mode='a'):

    makepath(log_dir, isfile=True)
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)

    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    ch.setFormatter(formatter)

    logger.addHandler(ch)

    fh = logging.FileHandler('%s'%log_dir, mode=mode)
    fh.setFormatter(formatter)
    logger.addHandler(fh)

    return logger


def DotDict(in_dict):

    out_dict = copy(in_dict)
    for k,v in out_dict.items():
       if isinstance(v,dict):
           out_dict[k] = DotDict(v)
    return dotdict(out_dict)

class dotdict(dict):
    """dot.notation access to dictionary attributes"""
    __getattr__ = dict.get
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__

def create_video(path, fps=30,name='movie'):
    import os
    import subprocess

    src = os.path.join(path,'%*.png')
    movie_path = os.path.join(path,'../%s.mp4'%name)
    i = 0
    while os.path.isfile(movie_path):
        movie_path = os.path.join(path,'%s_%02d.mp4'%(name,i))
        i +=1

    cmd = 'ffmpeg -f image2 -r %d -i %s -b:v 6400k -pix_fmt yuv420p %s' % (fps, src, movie_path)

    subprocess.call(cmd.split(' '))
    while not os.path.exists(movie_path):
        continue
