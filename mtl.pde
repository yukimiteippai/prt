interface mtl{
  V IL(hit H, ray r, int n);
}

class MTL_emit implements mtl{
  V IL(hit H, ray r, int n){
    return new V(10);
  }
}

class MTL_BG implements mtl{
  V IL(hit H, ray r, int n){return new V(0.1);}
}

class MTL_Diffuse implements mtl{
  V IL(hit H, ray r, int n){
    int sg = (H.normal.z<0) ?-1 :1;
    float a = -1/(sg+H.normal.z);
    float b = H.normal.x * H.normal.y * a;
    V T = new V(
      1 + sg*H.normal.x*H.normal.x*a,
      sg*b,
      -sg*H.normal.x
    );
    V B = new V(
      b,
      sg + H.normal.y*H.normal.y*a,
      -H.normal.y
    );
    
    float u1 = random(1);
    float u2 = random(TWO_PI);
    float rad = sqrt(u1);
    ray ray = new ray(
      H.pos.add(H.normal.mul(0.00001)),
      H.normal.mul(sqrt(1-u1)).add( T.mul(rad*cos(u2)).add( B.mul(rad*sin(u2)) ) )
    );
    return trace(ray, n);
  }
}

class MTL_Diffuse_red implements mtl{
  V IL(hit H, ray r, int n){
    MTL_Diffuse D = new MTL_Diffuse();
    return D.IL(H,r,n).mul(new V(0.95,0.05,0.05)); 
  }
}

class MTL_Diffuse_green implements mtl{
  V IL(hit H, ray r, int n){
    MTL_Diffuse D = new MTL_Diffuse();
    return D.IL(H,r,n).mul(new V(0.05,0.95,0.05)); 
  }
}
