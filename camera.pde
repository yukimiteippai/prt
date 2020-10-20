class camera{
  V pos;
  float flen;
  float w2;
  float h2;
  
  camera(V p, float f){
    pos = p;
    flen = f;
    w2 = width/2.0;
    h2 = height/2.0;
  }
  
  ray cameraray(int x, int y){
    float xx = (float)((x-w2)/w2);
    float zz = (float)((y-h2)/h2);
    V dir = new V(xx, flen, -zz).normalize();
    return new ray(this.pos, dir);
  }
}
