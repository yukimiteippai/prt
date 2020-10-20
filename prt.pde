camera camera;
sphere[] spheres;
int spp = 0;
PVector[] accumlated_radiance;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);
	
	accumlated_radiance = new PVector[width*height];
	for (int i=0; i<width*height; i++){
		accumlated_radiance[i] = new PVector(0, 0, 0);
	}

	camera = new camera(new PVector(0,-10,2), 1.5);
	spheres = new sphere[] {
	    new sphere(new PVector(-1,0,0), 2, new MTL_Diffuse()),
	    new sphere(new PVector(1,0,0), 2, new MTL_Diffuse()),
	    new sphere(new PVector(0,-2,10), 3, new MTL_emit()),
	    new sphere(new PVector(105,0,0), 100, new MTL_Diffuse_green()),
	    new sphere(new PVector(-105,0,0), 100, new MTL_Diffuse_red()),
	    new sphere(new PVector(0,0,-102), 100, new MTL_Diffuse()),
	    new sphere(new PVector(0,110,0), 100, new MTL_Diffuse()),
	};
}

PVector trace(ray ray, int n) {
	hit H = new hit();

	if (0<n) {
		for (int i=0; i<spheres.length; i++)
			spheres[i].intersect(H, ray);

		return H.M.IL(H,ray,n-1);
	} else return new PVector(0, 0, 0);
}

color render(int x, int y) {
	ray ray = camera.cameraray(x,y);
	PVector v = PVector.div(accumlated_radiance[y*width+x].add(trace(ray,5)), spp+1);
	return color(v.x, v.y, v.z);
}

void draw() {
	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y);
		}
	}
	updatePixels();

	println(spp);
	spp++;
}
