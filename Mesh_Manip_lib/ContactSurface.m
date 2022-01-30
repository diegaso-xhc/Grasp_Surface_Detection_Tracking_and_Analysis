classdef ContactSurface < handle
    properties
        ob % Object where the contact surface is        
        p % These are the points belonging to a given contact surface
        vnorm % Vector contining the normals of the given points
        m_vnorm % Mean normal vector (Direction of the contact surface)
        mp % Center of gravity of the contact surface
        t % IDs of the points of the contact surface with respect to the object's triangulation        
    end    
    methods
        function obj = ContactSurface(o, t)
            obj.ob = o;
            obj.p = o.Points(t, :);
            obj.t = t;
            obj.vnorm = vertexNormal(o, t');
            obj.m_vnorm = mean(obj.vnorm, 1);
            obj.mp = mean(obj.p, 1);            
        end
        function plotPoints(obj, boolean, col_vec)            
            if boolean
                hold on
                plot3(obj.p(:, 1), obj.p(:, 2), obj.p(:, 3), '*', 'Color', col_vec);
            else
                plot3(obj.p(:, 1), obj.p(:, 2), obj.p(:, 3), '*', 'Color', col_vec);
                hold off
            end            
        end
        function plotNormals(obj, boolean)            
            if boolean
                hold on
                quiver3(obj.p(:,1),obj.p(:,2),obj.p(:,3),obj.vnorm(:,1),obj.vnorm(:,2),obj.vnorm(:,3),0.5,'Color','b');                
            else
                quiver3(obj.p(:,1),obj.p(:,2),obj.p(:,3),obj.vnorm(:,1),obj.vnorm(:,2),obj.vnorm(:,3),0.5,'Color','b');
                hold off
            end            
        end
    end
end