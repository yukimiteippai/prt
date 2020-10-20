scene S;
int spp = 0;
V[] c;

void setup(){
  colorMode(RGB, 1.0);
  size(512,512);
  S = new scene();
  c = new V[width*height];
  for(int i=0; i<width*height; i++)c[i] = new V(0);
}

V trace(ray ray, int n){
  hit H = new hit();
  if(0<n){
    for(int i=0; i<S.s.length; i++)S.s[i].intersect(H, ray);
    return H.M.IL(H,ray,n-1);
  }else return new V(0);
}

void render(int x, int y){
  ray ray = S.cam.cameraray(x,y);
  float inv = 1.0/spp;
  c[y*width+x] = c[y*width+x].add(trace(ray,5));
  set(x,y, c[y*width+x].mul(inv).col());
}

void draw(){
  for(int y=0; y<height; y++){
    for(int x=0; x<width; x++){
      render(x,y);
    }
  }
  spp++;
}
