Camera camera;
Material environment;
Sphere[] spheres;

void createScene() {
  // (0,-10,2)から(0,0,2)を見るカメラを設定. 焦点距離は55mm.
  camera = new Camera(new PVector(0, -10, 2), new PVector(0, 0, 2), 55);

  // 背景色(発光)を設定する
  environment = new Material(new PVector(0.6, 0.7, 0.8), null);

  // 材質を用意する
  Material white  = new Material(null, new PVector(0.6, 0.6, 0.6), MtlType.DIFFUSE);
  Material red    = new Material(null, new PVector(0.8, 0.2, 0.2), MtlType.DIFFUSE);
  Material green  = new Material(null, new PVector(0.2, 0.8, 0.2), MtlType.DIFFUSE);
  Material mirror = new Material(null, new PVector(0.9, 0.6, 0.1), MtlType.SPECULAR);
  Material light  = new Material(new PVector(10, 10, 10), null);

  // 球を配置する
  spheres = new Sphere[] {
    new Sphere(new PVector(-2, -1.5, 0), 2, white), // ball left
    new Sphere(new PVector( 2, 1.5, 1), 2, mirror), // ball right
    new Sphere(new PVector( 0, -2, 10), 3, light), // light
    new Sphere(new PVector( 105, 0, 0), 100, green), // wall left
    new Sphere(new PVector(-105, 0, 0), 100, red), // wall right
    new Sphere(new PVector( 0, 0, -102), 100, white), // floor
    new Sphere(new PVector( 0, 110, 0), 100, white), // wall back
  };
}


Hit findNearestIntersection(Ray ray, float tmin, float tmax) {
  Hit hit = null;

  // ここに一番近い交点を探し、hit に代入する処理を書く
  ////////////////////////////////////////////

  float distance = tmax;
  for (Sphere sphere : spheres) {    
    Hit h = sphere.intersect(ray, tmin, tmax);
    if (h != null && h.distance < distance) {
      hit = h;
      distance = h.distance;
    }
  }
  ////////////////////////////////////////////

  // 最後に、球が裏面の場合は法線を反転する
  if (hit != null && PVector.dot(ray.d, hit.normal)>0) {
    hit.normal.mult(-1);
  }

  return hit;
}


void setup() {
  colorMode(RGB, 1.0);
  size(512, 512);

  createScene();
}

color render(int x, int y) {
  Ray view = camera.ray(x, y, random(1), random(1)); 
  Hit hit = findNearestIntersection(view, 0.0001, 10000);

  // レイと物体の交点があれば、物体の色を返す
  // なければ背景の色を返す
  if (hit != null) return toColor(hit.normal); 
  else return toColor(environment.emission);
}

void draw() {
  // update pixels
  loadPixels();
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {
      pixels[y*width + x] = render(x, y); // calculate color for each pixel on (x, y)
    }
  }
  updatePixels();
}
