class sphere {
	V pos;
	float r;
	mtl M;

	sphere(V p, float rr, mtl mm) {pos = p; r = rr; M=mm;}

	float dist(ray ray) {
		float b = ray.d.dot(ray.o.sub(this.pos));
		float c = ray.o.sub(this.pos).dot(ray.o.sub(this.pos)) - r*r;

		if (c<b*b) {
			float t = b+sqrt(b*b-c);

			if (0<t) {t = b-sqrt(b*b-c);}

			if (t<0)return -t;
			else return -1;
		} else return -1;
	}

	void intersect(hit H, ray ray) {
		float t = this.dist(ray);

		if (0<t && t<H.dist) {
			H.dist = t;
			H.pos = ray.o.add(ray.d.mul(new V(t)));
			H.normal = H.pos.sub(this.pos).normalize();
			H.M = this.M;
		}
	}
}
