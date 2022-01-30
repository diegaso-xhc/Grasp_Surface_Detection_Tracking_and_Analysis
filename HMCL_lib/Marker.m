% Developed by Diego Hidalgo C.

classdef Marker
   properties
      traj % This is an nx3 matrix containing the trajectory coordinates in time
      traj_exist % This is an nx1 boolean indicating where a trajectory exists
      id_mk % Name of the marker
      id_sub % Name of the subject it belongs to
   end   
   methods
      function obj = Marker(trajx, trajy, trajz, traj_exist, id_mk, id_sub)
         obj.traj = [trajx', trajy', trajz'];
         obj.traj_exist = traj_exist';
         obj.id_mk = id_mk;
         obj.id_sub = id_sub;
      end      
   end
end