# Grasp Surface Detection, Tracking & Analysis

 
## Overview of the repostitory
<div align="justify">
Humans use their hands to perform a broad set of tasks, some of which require highly dexterous manipulation capabilities. Simulating or reproducing such capabilities is an untractable problem with current technologies. It is crucial, therefore, to develop tools that aim at advancing technological resources for analyzing human manipulation interactions. In this repository, the authors have created an algorithm pipeline, which endows the research community with tools to investigate and analyze personalized human hand-object manipulations at a contact level. Insights resulting of such tools might have contributions in fields ranging from robotics manipulation, to medical rehabilitation, among others. 
<br />
<br /> 
Our paper <b>From Human Hand to Grasp Surface Detection, Tracking & Analysis</b>, which details the proposed methodology, is currently in its final publication state. You can find a video summarizing its content <a href="https://www.youtube.com/watch?v=LMdajths3Sw">here</a>.
<br />
<br /> 
Provided that positional motion capture data of a human hand, and of relevant landmarks of objects are available, this repository allows the digital reproduction of the interaction, as it can be seen below:
<br /> 
<br /> 
 <p align="center">
   <img src="/Visualizations/framework.gif" width="970" />
</p>
<sup> *Romero, Javier, Dimitrios Tzionas, and Michael J. Black. "Embodied hands: Modeling and capturing hands and bodies together." ACM Transactions on Graphics (ToG) 36.6 (2017): 1-17.</sup>
<br />
Here, a tailored human hand motion capture session can be represented virtually, via the usage of .obj/.stl files of the objects being manipulated, the human hand MANO model*, and this repository's algorithms.
 
## Experimental setup for repository

Although this repository is easily extendable, it is worth noting that during the development of this code a given fixed setup was used. The setup consisted of:

```
- VICON motion tracking capture with 16 IR-cameras
- 12 purposely selected 3D-printed (PLA) objects
- Artec Eva Lite 3D - Scanner
- 26 4-mm marker hand setup (see image below)
```

<p align="center">
   <img src="/Visualizations/Setup_markers.png" width="400" />
</p>
 
<!---
your comment goes here
and here
![This is an image](/Visualizations/vis_1.png)
![This is an image](/Visualizations/grasp_wine_glass.gif) ![This is an image](/Visualizations/grasp_cup.gif)
<img src = "/Visualizations/grasp_wine_glass.gif" width="400"> <img src = "/Visualizations/grasp_cup.gif" width="570">

-->
</div>

Nevertheless, the contributions of our work provide tools to extend our results to different setups, provided that changes are made on the pertinent locations. If you are not sure how to do so, please contact the author (see details below).

## Contributions

The contributions of this repository can be summarized as follows:

```
- A library for post processing and visualization of motion capture data --> HMCL_lib
- A set of purposely selected objects, which guarantee grasping postures variability --> Info_objects
- Algorithms to track known 3D objects with random marker placements --> Track_object_lib
- Algorithms for mesh manipulation --> Mesh_Manip_lib
- Pseudonymized data from trials (saved as Study objects, see HMCL_lib) --> Trials
- Algorithms to calculate contact surfaces information betwen a hand mesh and an object mesh --> see main
- Python algorithms to handle the MANO model, including marker position optimization --> fit_MANO (Developed in 
  cooperation with Omid Taheri (https://is.mpg.de/person/otaheri).
```

## Examples of hand-object contact level human manipulation

### Visualization of human hand-object interaction

Plots of the contact interaction of the subject in a specified frame. Contact surfaces are visible in read. 

<p align="center">
   <img src="/Visualizations/Frame_visualization.png" width="650" />
</p>

### Grasping of a cylinder

Plots of object with contact surfaces for grasping analysis. Contact surfaces are visible in red.

<p align="center">
  <img src="/Visualizations/grasp_cylinder.png" width="550" />  
</p>

### Grasping of a wine glass and a cup

Digital representation of the manipulation of a wine glass and a cup.

<p align="center">
  <img src="/Visualizations/grasp_wine_glass.gif" width="342" />
  <img src="/Visualizations/grasp_cup.gif" width="575" />   
</p>

### Contact surfaces with different hand parameters

A generic and a customized hand models were used to calculate the contact surfaces during the human manipulation recording. It can be seen that the hand model parameters play a role on the accuracy of the contact surfaces.

<p align="center">
  <img src="/Visualizations/Contact_surface_diff.PNG" width="600" />  
</p>

## License

Developed by Diego Hidalgo C. (2021). This repository is intended for research purposes only. If you wish to use any parts of the provided code for commercial purposes, please contact the author at hidalgocdiego@gmail.com.
