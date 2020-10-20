interface Material {
	PVector IL(Hit H, Ray r, int n);
}

class MTL_emit implements Material {
	PVector IL(Hit H, Ray r, int n) {
		return new PVector(10, 10, 10);
	}
}

class MTL_BG implements Material {
	PVector IL(Hit H, Ray r, int n) {
		return new PVector(0.1, 0.1, 0.1);
	}
}

class MTL_Diffuse implements Material {
	PVector IL(Hit H, Ray r, int n) {
		int sg = (H.normal.z<0) ?-1 :1;
		float a = -1/(sg+H.normal.z);
		float b = H.normal.x * H.normal.y * a;
		PVector T = new PVector(
		    1 + sg*H.normal.x*H.normal.x*a,
		    sg*b,
		    -sg*H.normal.x
		);
		PVector B = new PVector(
		    b,
		    sg + H.normal.y*H.normal.y*a,
		    -H.normal.y
		);
		float u1 = random(1);
		float u2 = random(TWO_PI);
		float rad = sqrt(u1);
	
		PVector u = PVector.mult(T, rad*cos(u2));
		PVector v = PVector.mult(B, rad*sin(u2));
		PVector w = PVector.mult(H.normal, sqrt(1-u1));
	
		Ray ray = new Ray(
			PVector.add(H.pos, PVector.mult(H.normal, 0.00001)),
			u.add(v).add(w)
		);
		return trace(ray, n);
	}
}

class MTL_Diffuse_red implements Material {
	PVector IL(Hit H, Ray r, int n) {
		MTL_Diffuse D = new MTL_Diffuse();
		PVector v = D.IL(H,r,n);
		return new PVector(v.x*0.9, v.y*0.1, v.z*0.1);
	}
}

class MTL_Diffuse_green implements Material {
	PVector IL(Hit H, Ray r, int n) {
		MTL_Diffuse D = new MTL_Diffuse();
		PVector v = D.IL(H,r,n);
		return new PVector(v.x*0.1, v.y*0.9, v.z*0.1);
	}
}
