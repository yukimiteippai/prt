class Sphere {
	PVector pos;	// center of sphere
	float r; 		// radius
	Material mtl;	// material

	Sphere(PVector p, float rr, Material mm) {pos = p; r = rr; mtl=mm;}

	// test if the ray hits and return the distance. if not, return -1.
	float distance(Ray ray) {
		PVector thispos = new PVector(this.pos.x, this.pos.y, this.pos.z);
		PVector po = PVector.sub(ray.o, thispos);
		float b = PVector.dot(ray.d, po);
		float c = PVector.dot(po, po) - r*r;

		if (c<b*b) {
			float t = b+sqrt(b*b-c);
			if(0<t) t = b-sqrt(b*b-c);
			
			if(t<0) return -t;
		}
		return -1;
	}

	// test the ray intersection within a range of distance.
	// return hit point if found. otherwise, return null.
	Hit intersect(Ray ray, float tmin, float tmax) {
		float t = this.distance(ray);

		if (tmin<t && t<tmax) {
			Hit hit = new Hit();
			hit.dist = t;
			hit.pos = PVector.add(ray.o, PVector.mult(ray.d, t));
			hit.normal = PVector.sub(hit.pos, this.pos).normalize();
			hit.mtl = this.mtl;
			return hit;
		}
		else return null;
	}
}
