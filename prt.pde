Camera camera;
Sphere[] spheres;
int spp = 0;
PVector[] accumlated_radiance;
Material environment;

void setup() {
	colorMode(RGB, 1.0);
	size(512,512);
	
	accumlated_radiance = new PVector[width*height];
	for (int i=0; i<width*height; i++){
		accumlated_radiance[i] = new PVector(0, 0, 0);
	}


	camera = new Camera(new PVector(0,-10,2), 1.5);

	environment = new Material();
	environment.emission = new PVector(0.6, 0.7, 0.8);

	Material white = new Material();
	white.reflection = new PVector(0.6, 0.6, 0.6);

	Material red = new Material();
	red.reflection = new PVector(0.9, 0.1, 0.1);

	Material green = new Material();
	green.reflection = new PVector(0.1, 0.9, 0.1);

	Material mirror = new Material();
	mirror.reflection = new PVector(0.9, 0.9, 0.9);
	mirror.type = MtlType.SPECULAR;

	Material light = new Material();
	light.emission = new PVector(10,10,10);

	spheres = new Sphere[] {
	    new Sphere(new PVector(-1,0,0), 2, white),
	    new Sphere(new PVector(1,0,0), 2, mirror),
	    new Sphere(new PVector(0,-2,10), 3, light),
	    new Sphere(new PVector(105,0,0), 100, green),
	    new Sphere(new PVector(-105,0,0), 100, red),
	    new Sphere(new PVector(0,0,-102), 100, white),
	    new Sphere(new PVector(0,110,0), 100, white),
	};
}

Hit findNearestIntersection(Ray ray, float tmin, float tmax){
	Hit hit = null;
	
	for (int i=0; i<spheres.length; i++){
		Hit hit_temp = spheres[i].intersect(ray, tmin, tmax);
		if(hit_temp != null){
			hit = hit_temp;
			tmax = hit.dist;
		}
	}

	if(hit != null && PVector.dot(ray.d, hit.normal)>0){
		hit.normal.mult(-1);
	}

	return hit;
}

void tangentspace_basis(PVector n, PVector T, PVector B){
	int sg = (n.z<0) ?-1 :1;
	float a = -1/(sg+n.z);
	float b = n.x * n.y * a;
	T.set(1 + sg*n.x*n.x*a, sg*b, -sg*n.x);
	B.set(b, sg + n.y*n.y*a, -n.y);
}

PMatrix3D tangentspace_mat(PVector n){
	int sg = (n.z<0) ?-1 :1;
	float a = -1/(sg+n.z);
	float b = n.x * n.y * a;
	return new PMatrix3D(
		1 + sg*n.x*n.x*a, b, n.x, 0,
		sg*b, sg + n.y*n.y*a, n.y, 0,
		-sg*n.x, -n.y, n.z, 0, 
		0, 0, 0, 0
	);
}

PVector sampleHemisphere_cosine(float u1, float u2){
	float rad = sqrt(u1);
	u2 = u2*TWO_PI;
	return new PVector(rad*cos(u2), rad*sin(u2), sqrt(1-u1));
}


PVector trace(Ray ray, int n) {
	if (0==n) return new PVector(0, 0, 0);

	Hit hit = findNearestIntersection(ray, 0.0001, 100000);
	if(hit == null)	return environment.emission;

	PVector result = new PVector(0,0,0);

	if(hit.mtl.emission != null)
		result.add(hit.mtl.emission);

	if(hit.mtl.reflection != null){
		// choose next ray in tangent space using matrix
		//
		// PMatrix3D TtoW = tangentspace_mat(hit.normal);
		// PMatrix3D WtoT = new PMatrix3D(TtoW);
		// WtoT.transpose();
		// PVector dirInT = WtoT.mult(ray.d, null);
		// PVector dirOutT = new PVector();

		// switch (hit.mtl.type) {
		// 	case DIFFUSE:
		// 		dirOutT = sampleHemisphere_cosine(random(1), random(1));
		// 		break;

		// 	case SPECULAR:
		// 		dirOutT.set(dirInT.x, dirInT.y, -dirInT.z);
		// 		break;
		// }

		// ray.o = PVector.add(hit.pos, PVector.mult(hit.normal, 0.0001));
		// TtoW.mult(dirOutT, ray.d);


		// choose next ray directly in world space
		// 
		PVector T = new PVector();
		PVector B = new PVector();
		tangentspace_basis(hit.normal, T, B);

		switch (hit.mtl.type) {
			case DIFFUSE:
				ray.o = PVector.add(hit.pos, PVector.mult(hit.normal, 0.0001));

				PVector dir = sampleHemisphere_cosine(random(1), random(1));
				ray.d = T.mult(dir.x).add(B.mult(dir.y)).add(hit.normal.mult(dir.z));
				break;
			
			case SPECULAR:
				ray.o = PVector.add(hit.pos, PVector.mult(hit.normal, 0.0001));
				ray.d = PVector.add(ray.d, PVector.mult(hit.normal, -2*PVector.dot(hit.normal, ray.d)));
				break;
		}

		return multC(hit.mtl.reflection, trace(ray, n-1));
	}
	
	return result;
}

color render(int x, int y) {
	Ray ray = camera.ray(x, y, random(1), random(1));
	PVector v = PVector.div(accumlated_radiance[y*width+x].add(trace(ray,2)), spp);
	return toColor(v);
}

void draw() {
	spp++;
	println(spp);
	if(spp>50){
		println("stop rendering");
		noLoop();
	}

	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y);
		}
	}
	updatePixels();
}

color toColor(PVector v){return color(v.x, v.y, v.z);}
PVector multC(PVector v1, PVector v2){return new PVector(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);}