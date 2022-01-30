function plotManipulation(object, y, fingers, yf)
% This function allows us to plot the interaction between a given object,
% the given hand structure and the contact surfaces which were previously
% found.
ob = {};
fgs = {};
lob = length(object);
lfgs = length(fingers);
for i = 1: lob
   ob{i} = ObjectInfo(object{i});
end
for i = 1: lfgs
   fgs{i} = FingerInfo(fingers{i});
end
for i = 1: lob    
   subplot(lob, 2, 2*i)
   ob{i}.plotObject(1, [0.32, 0.64, 0.74]);   
%    plotContactRegions_v2(yf{i}, [rand rand rand])
   plotContactRegions_v2(yf{i}, [200 20 60]/255)
   axis('equal')
   title('Filtered Contact surfaces')
   view([45 25])
%    grid on
   
   subplot(lob, 2, 2*i - 1)
   ob{i}.plotObject(1, [0.32, 0.64, 0.74])   
   plotContactRegions_v2(y{i}, [1 0 0])
   axis('equal')
   title('Contact')
   view([45 25])
%    grid on
   
   for j = 1: lfgs        
        subplot(lob, 2, 2*i - 1)
        fgs{j}.plotFinger(1)
   end
end







end