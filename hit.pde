class Hit{
  float dist;
  PVector pos;
  PVector normal;
  Material M;
  
  Hit(){
    dist = 100000000;
    M = new MTL_BG();
  }
}