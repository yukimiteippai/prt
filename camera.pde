class Camera {
	PVector pos;
	float flen;

	Camera(PVector p, float f) {
		pos = p;
		flen = f;
	}

	Ray ray(int xi, int yi, float u1, float u2) {
		float x =  (xi+u1)/( width/2) - 1;
		float y = -(yi+u2)/(height/2) + 1;

		PVector dir = new PVector(x, flen, y).normalize();
		return new Ray(this.pos, dir);
	}
}
