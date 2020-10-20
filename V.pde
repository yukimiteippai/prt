class V{
  float x;
  float y;
  float z;
  
  V(){}
  V(float v){x=y=z=v;}
  V(float xx, float yy, float zz){x=xx; y=yy; z=zz;}
  
  V add(V a){return new V(this.x+a.x, this.y+a.y, this.z+a.z);}
  V sub(V a){return new V(this.x-a.x, this.y-a.y, this.z-a.z);}
  V mul(V a){return new V(this.x*a.x, this.y*a.y, this.z*a.z);}
  V mul(float a){return new V(this.x*a, this.y*a, this.z*a);}
  V div(V a){return new V(this.x/a.x, this.y/a.y, this.z/a.z);}
  float dot(V a){return this.x*a.x + this.y*a.y + this.z*a.z;}
  V cross(V a){return new V(this.y*a.z-this.z*a.y, this.z*a.x - this.x*a.z, this.x*a.y-this.y*a.x);}
  float len(){return sqrt(this.dot(this));}
  V normalize(){return this.div( new V(this.len()) );}
  color col(){return color(this.x, this.y, this.z);}
}
