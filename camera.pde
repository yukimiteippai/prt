class camera{
  PVector pos;
  float flen;
  float w2;
  float h2;
  
  camera(PVector p, float f){
    pos = p;
    flen = f;
    w2 = width/2.0;
    h2 = height/2.0;
  }
  
  ray cameraray(int x, int y){
    float xx = (float)((x-w2)/w2);
    float zz = (float)((y-h2)/h2);
    PVector dir = new PVector(xx, flen, -zz).normalize();
    
    V p = new V(pos.x, pos.y, pos.z);
    V d = new V(dir.x, dir.y, dir.z);

    return new ray(p, d);
  }
}
