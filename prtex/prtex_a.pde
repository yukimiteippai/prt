Camera camera;
Material environment;
Sphere sphere;

void createScene() {
    // (0,-10,2)から(0,0,0)を見るカメラを設定. 焦点距離は55mm.
    camera = new Camera(new PVector(0,-10,2), new PVector(0,0,0), 55);

    // 背景色(発光)を設定する
    environment = new Material(new PVector(0.6, 0.7, 0.8), null);

    // 材質を用意する
    Material white  = new Material(null, new PVector(0.6, 0.6, 0.6), MtlType.DIFFUSE);
    Material red    = new Material(null, new PVector(0.8, 0.2, 0.2), MtlType.DIFFUSE);
    Material green  = new Material(null, new PVector(0.2, 0.8, 0.2), MtlType.DIFFUSE);

    // (0,0,0) に半径2の赤い球を配置
    sphere = new Sphere(new PVector(-3, 0, 0), 2, red);
}


void setup() {
	colorMode(RGB, 1.0);
	size(512,512);

  createScene();
}

color render(int x, int y) {
    Ray view = camera.ray(x, y, random(1), random(1)); // ★
    Hit hit = sphere.intersect(view, 0.0001, 10000); // ◆

    // レイと物体の交点があれば、物体の色を返す
    // なければ背景の色を返す
    if(hit != null) return toColor(hit.normal); // ▼
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
