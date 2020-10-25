// scene info
Camera camera;
Material environment;
Sphere[] spheres;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);

	createScene();
}

// initialize camera, environment, and spheres.
void createScene() {
	// set the camera
	camera = new Camera(new PVector(0,-10,2), new PVector(0,0,2), 55);
	
	// set the background emissiomn
	environment = new Material(new PVector(0.6, 0.7, 0.8), null);
	
	// create some materials for objects
	Material white	= new Material(null, new PVector(0.6, 0.6, 0.6), MtlType.DIFFUSE);
	Material red	= new Material(null, new PVector(0.8, 0.2, 0.2), MtlType.DIFFUSE);
	Material green	= new Material(null, new PVector(0.2, 0.8, 0.2), MtlType.DIFFUSE);
	Material mirror	= new Material(null, new PVector(0.9, 0.6, 0.1), MtlType.SPECULAR);
	Material light	= new Material(new PVector(10,10,10), null);
	
	// create spheres
	spheres = new Sphere[] {
	    new Sphere(new PVector(-2 ,-1.5, 0), 2,  white), // ball left
	    new Sphere(new PVector( 2 , 1.5, 1), 2, mirror), // ball right
	    new Sphere(new PVector( 0,-2,10), 3,  light), // light
	    new Sphere(new PVector( 105, 0, 0), 100, green), // wall left
	    new Sphere(new PVector(-105, 0, 0),	100,   red), // wall right
	    new Sphere(new PVector( 0, 0,-102),	100, white), // floor
	    new Sphere(new PVector( 0, 110, 0),	100, white), // wall back
	};
}

// return the nearest intersection of ray and spheres within a range of distance[tmin, tmax]
// With no intersection, return null.
Hit findNearestIntersection(Ray ray, float tmin, float tmax) {
	Hit hit = null;

	// test all spheres to find nearest intersection info here










	// flip normal when it is backfacin
	if (hit != null && PVector.dot(ray.d, hit.normal)>0) {
		hit.normal.mult(-1);
	}

	return hit;
}

// calculate color on (x, y)
color render(int x, int y) {
	Ray view = camera.ray(x, y, random(1), random(1)); // sample camera ray
	Hit hit = findNearestIntersection(view, 0.0001, 10000);
	PVector result = hit.mtl.Color();
	// PVector result = hit.normal;
	return toColor(result);
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