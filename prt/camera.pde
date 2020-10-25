class Camera {
	PVector pos;
	float flen;
	PMatrix3D CtoW;

	Camera(PVector p, PVector target, float f) {
		pos = p;
		flen = f/35.0;

		PVector z = target.sub(p).normalize();		
		PVector x = z.cross(new PVector(0,0,1)).normalize();
		PVector y = x.cross(z);
		CtoW = new PMatrix3D(x.x, y.x, z.x, 0, x.y, y.y, z.y, 0, x.z, y.z, z.z, 0, 0, 0, 0, 0);
	}

	// generate a ray directing to a position on the screen
	Ray ray(int xi, int yi, float u1, float u2) {
		PVector dirC = new PVector( (xi+u1)/( width/2) - 1,	-(yi+u2)/(height/2) + 1, flen);
		return new Ray(this.pos, CtoW.mult(dirC, null).normalize());
	}
}
