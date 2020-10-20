Camera camera;
Sphere[] spheres;
int spp = 0;
PVector[] accumlated_radiance;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);
	
	accumlated_radiance = new PVector[width*height];
	for (int i=0; i<width*height; i++){
		accumlated_radiance[i] = new PVector(0, 0, 0);
	}

	camera = new Camera(new PVector(0,-10,2), 1.5);
	spheres = new Sphere[] {
	    new Sphere(new PVector(-1,0,0), 2, new MTL_Diffuse()),
	    new Sphere(new PVector(1,0,0), 2, new MTL_Diffuse()),
	    new Sphere(new PVector(0,-2,10), 3, new MTL_emit()),
	    new Sphere(new PVector(105,0,0), 100, new MTL_Diffuse_green()),
	    new Sphere(new PVector(-105,0,0), 100, new MTL_Diffuse_red()),
	    new Sphere(new PVector(0,0,-102), 100, new MTL_Diffuse()),
	    new Sphere(new PVector(0,110,0), 100, new MTL_Diffuse()),
	};
}

Hit findNearestIntersection(Ray ray, float tmin, float tmax){
	Hit hit = new Hit();
	hit.mtl = new MTL_BG();
	
	for (int i=0; i<spheres.length; i++){
		Hit hit_temp = spheres[i].intersect(ray, tmin, tmax);
		if(hit_temp != null){
			hit = hit_temp;
			tmax = hit.dist;
		}
	}

	return hit;
}

PVector trace(Ray ray, int n) {
	if (0<n) {
		Hit hit = findNearestIntersection(ray, 0.0001, 100000);
		return hit.mtl.IL(hit,ray,n-1);
	} else return new PVector(0, 0, 0);
}

color render(int x, int y) {
	Ray ray = camera.ray(x, y, random(1), random(1));
	PVector v = PVector.div(accumlated_radiance[y*width+x].add(trace(ray,5)), spp);
	return toColor(v);
}

void draw() {
	spp++;
	println(spp);

	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y);
		}
	}
	updatePixels();
}

color toColor(PVector v){return color(v.x, v.y, v.z);}