Camera camera;
Material environment;
Sphere[] spheres;

int count = 0; // 追跡した経路の数
PVector[] accumlated_radiance; // 画素ごとの寄与の合計を入れておく配列

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


PVector trace(Ray ray, int n) {

  // 反射回数が多いとき追跡をやめる(黒を返す)
  if (10<n) return new PVector(0, 0, 0);

  Hit hit = findNearestIntersection(ray, 0.0001, 100000); // 光線と物体の交点を探す
  PVector result = new PVector(0, 0, 0); // 結果用の変数

  // 交点がないとき背景からの放射を返す
  if (hit == null) return environment.emission;

  // 光源にあたったとき(emission があるとき) その値を結果に足す
  if (hit.material.emission != null) result.add(hit.material.emission);


  // 反射面に当たったとき(reflection があるとき)、さらに入射方向を追跡し、反射光を結果に足す
  if (hit.material.reflection != null) {

    // 接面の基(T, B, hit.normal)を用意する
    PVector T = new PVector();
    PVector B = new PVector();
    tangentspace_basis(hit.normal, T, B);

    // 反射の種類によって追跡する方向を決め、ray を更新する
    switch (hit.material.type) {
    case DIFFUSE:
      // 拡散反射する光線の原点と方向を更新する
      PVector dir = sampleHemisphere_cosine(random(1), random(1));
      ray.o = PVector.add(hit.position, PVector.mult(hit.normal, 0.001));
      ray.d =  PVector.mult(T, dir.x).add(PVector.mult(B, dir.y)).add(PVector.mult(hit.normal, dir.z));
      break;

    case SPECULAR:
      // 鏡面反射する光線の原点と方向を更新する
      ray.o = PVector.add(hit.position, PVector.mult(hit.normal, 0.001));
      ray.d = ray.d.add(PVector.mult(hit.normal, -2*PVector.dot(hit.normal, ray.d)));
      break;
    }

    // 1. この実装では、入射としてこのtrace関数を再帰的に利用することを想定しています。
    //
    // 2. 色の積を計算するために、 multC(PVector, PVector)->PVector 関数を
    // 利用することができます。これは二つのベクトルの次元ごとの積を新たなベクトルとして返します。
    //
    result.add(multC(trace(ray, n+1), hit.material.Color()));
  }

  return result;
}


void setup() {
  colorMode(RGB, 1.0);
  size(512, 512);

  accumlated_radiance = new PVector[width*height];
  for (int i=0; i<width*height; i++) {
    accumlated_radiance[i] = new PVector(0, 0, 0);
  }

  createScene();
}

color render(int x, int y) {
  Ray view = camera.ray(x, y, random(1), random(1));
  accumlated_radiance[y*width+x].add( trace(view, 0) ); // 合計に新しいサンプルを足す
  PVector average = PVector.div( accumlated_radiance[y*width+x], count );
  return toColor(average);
}

void draw() {
  // update pixels
  count++;

  loadPixels();
  for (int y=0; y<height; y++) {
    for (int x=0; x<width; x++) {
      pixels[y*width + x] = render(x, y); // calculate color for each pixel on (x, y)
    }
  }
  updatePixels();
}
