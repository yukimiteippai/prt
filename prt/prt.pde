// scene info
Camera camera;
Material environment;
Sphere sphere;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);

	createScene();
}

// initialize camera, environment, and spheres.
void createScene() {
	// set the camera
	camera = new Camera(new PVector(0,-10,2), new PVector(0,0,0), 55);
	
	// set the background emissiomn
	environment = new Material(new PVector(0.6, 0.7, 0.8), null);
	
	// create some materials for objects
	Material white	= new Material(null, new PVector(0.6, 0.6, 0.6), MtlType.DIFFUSE);
	Material red	= new Material(null, new PVector(0.8, 0.2, 0.2), MtlType.DIFFUSE);
	Material green	= new Material(null, new PVector(0.2, 0.8, 0.2), MtlType.DIFFUSE);
	
	// create spheres
	sphere = new Sphere(new PVector(0 , 0, 0), 2,  red);
}

// calculate color on (x, y)
color render(int x, int y) {
	Ray view = camera.ray(x, y, random(1), random(1)); // sample camera ray
	Hit hit = sphere.intersect(view, 0.0001, 10000);
	
	// if view ray intesects the sphere, return object color.
	// otherwise, return environment color.
	if(hit != null) return toColor(hit.mtl.Color());
	else return toColor(environment.emission);
}

void draw() {
	// update pixels
	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y);
		}
	}
	updatePixels();
}