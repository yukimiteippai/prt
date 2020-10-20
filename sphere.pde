class Sphere {
	PVector pos;
	float r;
	Material M;

	Sphere(PVector p, float rr, Material mm) {pos = p; r = rr; M=mm;}

	float dist(Ray ray) {
		PVector thispos = new PVector(this.pos.x, this.pos.y, this.pos.z);
		PVector po = PVector.sub(ray.o, thispos);
		float b = PVector.dot(ray.d, po);
		float c = PVector.dot(po, po) - r*r;


		if (c<b*b) {
			float t = b+sqrt(b*b-c);

			if (0<t) {t = b-sqrt(b*b-c);}

			if (t<0)return -t;
			else return -1;
		} else return -1;
	}

	Hit intersect(Ray ray, float tmin, float tmax) {
		float t = this.dist(ray);

		if (tmin<t && t<tmax) {
			Hit hit = new Hit();
			hit.dist = t;
			hit.pos = PVector.add(ray.o, PVector.mult(ray.d, t));
			hit.normal = PVector.sub(hit.pos, this.pos).normalize();
			hit.M = this.M;
			return hit;
		}
		else return null;
	}
}
