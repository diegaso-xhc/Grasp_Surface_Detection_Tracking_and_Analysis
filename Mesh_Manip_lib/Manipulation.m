classdef Manipulation < handle    
   properties
      in_cs % Initial contact surfaces before filtering
      ft_cs % Filtered contact surfaces
      ob % Object being manipulated
      hd % Hand that manipulates the object  
      th % This is the threshold for the proximity of manipulation
      type % This si the type of contact calculation (i.e. near, in, both)
   end
   methods
       function obj = Manipulation(ob, hd, th, type)           
           obj.ob = ob;
           obj.hd = hd;
           obj.th = th;
           obj.type = type;
           [obj.ft_cs, obj.in_cs] = getContactSurfaces(obj.ob, obj.hd, obj.th, obj.type);          
       end
       function plot_manipulation(obj)
            plotManipulation(obj.ob, obj.in_cs, obj.hd, obj.ft_cs); % We call the previously developed function to plot the manipulation results
       end            
   end    
end