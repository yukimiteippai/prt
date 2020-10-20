class hit{
  float dist;
  PVector pos;
  PVector normal;
  mtl M;
  
  hit(){
    dist = 100000000;
    M = new MTL_BG();
  }
}