function plotNormals(obj)
% This function allows us to plot the normals on the points of a
% triangulation, hence a mesh.
VNorm = 3*vertexNormal(obj);
h = trimesh(obj);
h.EdgeColor = [0, 0, 0];
h.FaceAlpha = 0.1;
h.EdgeAlpha = 0.1;
hold on
quiver3(obj.Points(:,1),obj.Points(:,2),obj.Points(:,3), ...
    VNorm(:,1),VNorm(:,2),VNorm(:,3),0,'Color','r');
mp = mean(obj.Points, 1);
m_vnorm = 30*mean(VNorm, 1);
quiver3(mp(1), mp(2), mp(3), ...
    m_vnorm(1),m_vnorm(2),m_vnorm(3),0,'Color','b');
axis('equal')
hold off
end