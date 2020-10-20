class sphere {
	PVector pos;
	float r;
	Material M;

	sphere(PVector p, float rr, Material mm) {pos = p; r = rr; M=mm;}

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

	void intersect(Hit H, Ray ray) {
		float t = this.dist(ray);

		if (0<t && t<H.dist) {
			H.dist = t;
			H.pos = PVector.add(ray.o, PVector.mult(ray.d, t));
			H.normal = PVector.sub(H.pos, this.pos).normalize();
			H.M = this.M;
		}
	}
}
