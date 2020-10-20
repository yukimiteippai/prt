camera camera;
sphere[] spheres;
int spp = 0;
V[] c;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);
	c = new V[width*height];

	for (int i=0; i<width*height; i++)c[i] = new V(0);

	camera = new camera(new V(0,-10,2), 1.5);
	spheres = new sphere[] {
	    new sphere(new V(-1,0,0), 2, new MTL_Diffuse()),
	    new sphere(new V(1,0,0), 2, new MTL_Diffuse()),
	    new sphere(new V(0,-2,10), 3, new MTL_emit()),
	    new sphere(new V(105,0,0), 100, new MTL_Diffuse_green()),
	    new sphere(new V(-105,0,0), 100, new MTL_Diffuse_red()),
	    new sphere(new V(0,0,-102), 100, new MTL_Diffuse()),
	    new sphere(new V(0,110,0), 100, new MTL_Diffuse()),
	};
}

V trace(ray ray, int n) {
	hit H = new hit();

	if (0<n) {
		for (int i=0; i<spheres.length; i++)spheres[i].intersect(H, ray);

		return H.M.IL(H,ray,n-1);
	} else return new V(0);
}

color render(int x, int y) {
	ray ray = camera.cameraray(x,y);
	float inv = 1.0/spp;
	c[y*width+x] = c[y*width+x].add(trace(ray,5));
	// set(x,y, c[y*width+x].mul(inv).col());
	return c[y*width+x].mul(inv).col();
}

void draw() {
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			color c = render(x,y);
			set(x, y, c);
		}
	}

	spp++;
}
