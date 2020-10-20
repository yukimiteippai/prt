class camera {
	PVector pos;
	float flen;
	float w2;
	float h2;

	camera(PVector p, float f) {
		pos = p;
		flen = f;
		w2 = width/2.0;
		h2 = height/2.0;
	}

	ray ray(int xi, int yi, float u1, float u2) {
		float x =  (xi+u1)/( width/2) - 1;
		float y = -(yi+u2)/(height/2) + 1;

		PVector dir = new PVector(x, flen, y).normalize();
		return new ray(this.pos, dir);
	}
}
