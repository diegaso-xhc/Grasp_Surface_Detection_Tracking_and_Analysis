classdef ObjectInfo < handle
    properties
        ob % Object where the contact surface is        
        p % These are the points belonging to a given contact surface
        cnn % Vector contining the normals of the given points        
    end    
    methods
        function obj = ObjectInfo(o)
            obj.ob = o;
            obj.p = o.Points;
            obj.cnn = o.ConnectivityList;            
        end
        function plotObject(obj, boolean, col_vec)            
            if boolean
                hold on
                h = trimesh(obj.ob);
                h.EdgeColor = col_vec;        
                h.FaceAlpha = 1;
                h.EdgeAlpha = 0.8;
                axis('equal')
                hold off
                xlabel('X')
                ylabel('Y')
                zlabel('Z')                
            else
                h = trimesh(obj.ob);
                h.EdgeColor = col_vec;
                h.FaceAlpha = 1;
                h.EdgeAlpha = 0.8;
                axis('equal')
                hold off
                xlabel('X')
                ylabel('Y')
                zlabel('Z')                
                hold off
            end            
        end        
    end
end