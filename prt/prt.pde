int spp = 0; // sample size per pixel.
PVector[] accumlated_radiance; // image to store the sum of sampled contribution.

// scene info
Camera camera;
Material environment;
Sphere[] spheres;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);

	// initialize image
	accumlated_radiance = new PVector[width*height];
	for (int i=0; i<width*height; i++) {
		accumlated_radiance[i] = new PVector(0, 0, 0);
	}

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

	// test all objects and keep nearest one in 'hit'.
	for (int i=0; i<spheres.length; i++) {

		// receive intersection info within the range.
		Hit hit_temp = spheres[i].intersect(ray, tmin, tmax);

		// if a new hit point found, update 'hit' and shrink the range.
		if (hit_temp != null) {
			hit = hit_temp;
			tmax = hit.dist;
		}
	}

	// flip normal when it is backfacin
	if (hit != null && PVector.dot(ray.d, hit.normal)>0) {
		hit.normal.mult(-1);
	}

	return hit;
}

// trace the ray and return the radiance incoming from its direction.
PVector trace(Ray ray, int n) {
	if (10<n) // terminate recursion at some depth
		return new PVector(0, 0, 0);


	Hit hit = findNearestIntersection(ray, 0.0001, 100000); // receive nearest intersection info
	PVector result = new PVector(0,0,0); // prepare the color to return.


	if (hit == null) // if the ray has no intersection, retutn environment emission.
		return environment.emission;

	if (hit.mtl.emission != null) // if the surface has emission, add it.
		result.add(hit.mtl.emission);


	// if the surface has reflection, add it tracing incoming ray.
	if (hit.mtl.reflection != null) {

		// generate tangent space basis
		PVector T = new PVector();
		PVector B = new PVector();
		tangentspace_basis(hit.normal, T, B);

		// sample the reflecting direction depending on the reflectin type.
		switch (hit.mtl.type) {
		case DIFFUSE:
			/* update ray here using T, B, and sampleHemisphere_cosine() */
			
			PVector dir = sampleHemisphere_cosine(random(1), random(1));
			// ray.o = 
			// ray.d = 
			break;

		case SPECULAR:
			/* update ray here with normal and current ray */
			
			// ray.o = 
			// ray.d = 
			break;
		}

		// add reflection to the result
		// reflection is surface color times incidence that we trace next.
		result.add( /* surface color * incidence */ );
	}

	return result;
}

// calculate color on (x, y)
color render(int x, int y) {
	Ray ray = camera.ray(x, y, random(1), random(1)); // sample camera ray
	
	// add new sample to accumulated_radiance, and calculate average
	accumlated_radiance[y*width+x].add(trace(ray,0));
	// PVector average =
	
	return toColor(average);
}

void draw() {
	// update sample size count
	spp++;
	// println(spp);
	if (spp>500) {
		println("stop rendering");
		noLoop();
	}

	// update pixels
	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y);
		}
	}
	updatePixels();
}