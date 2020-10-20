class scene{
  camera cam = new camera(new V(0,-10,2), 1.5);
  sphere[] s = {
    new sphere(new V(-1,0,0), 2, new MTL_Diffuse() ),
    new sphere(new V(1,0,0), 2, new MTL_Diffuse() ),
    new sphere(new V(0,-2,10), 3, new MTL_emit() ),
    new sphere(new V(105,0,0), 100, new MTL_Diffuse_green()),
    new sphere(new V(-105,0,0), 100, new MTL_Diffuse_red()),
    new sphere(new V(0,0,-102), 100, new MTL_Diffuse()),
    new sphere(new V(0,110,0), 100, new MTL_Diffuse()),
  }; 
}
