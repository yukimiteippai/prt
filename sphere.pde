class sphere {
	V pos;
	float r;
	mtl M;

	sphere(V p, float rr, mtl mm) {pos = p; r = rr; M=mm;}

	float dist(ray ray) {
		V ro = new V(ray.o.x, ray.o.y, ray.o.z);
		V rd = new V(ray.d.x, ray.d.y, ray.d.z);
		float b = rd.dot(ro.sub(this.pos));
		float c = ro.sub(this.pos).dot(ro.sub(this.pos)) - r*r;

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
			V ro = new V(ray.o.x, ray.o.y, ray.o.z);
			V rd = new V(ray.d.x, ray.d.y, ray.d.z);
			V p = ro.add(rd.mul(new V(t)));

			PVector c = new PVector(this.pos.x, this.pos.y, this.pos.z);
			H.pos = new PVector(p.x, p.y, p.z);
			H.normal = PVector.sub(H.pos, c).normalize();
			H.M = this.M;
		}
	}
}
