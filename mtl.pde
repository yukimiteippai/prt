interface mtl {
	PVector IL(hit H, ray r, int n);
}

class MTL_emit implements mtl {
	PVector IL(hit H, ray r, int n) {
		return new PVector(10, 10, 10);
	}
}

class MTL_BG implements mtl {
	PVector IL(hit H, ray r, int n) {
		return new PVector(0.1, 0.1, 0.1);
	}
}

class MTL_Diffuse implements mtl {
	PVector IL(hit H, ray r, int n) {
		int sg = (H.normal.z<0) ?-1 :1;
		float a = -1/(sg+H.normal.z);
		float b = H.normal.x * H.normal.y * a;
		V T = new V(
		    1 + sg*H.normal.x*H.normal.x*a,
		    sg*b,
		    -sg*H.normal.x
		);
		V B = new V(
		    b,
		    sg + H.normal.y*H.normal.y*a,
		    -H.normal.y
		);
		float u1 = random(1);
		float u2 = random(TWO_PI);
		float rad = sqrt(u1);

		V hp = new V(H.pos.x, H.pos.y, H.pos.z);
		V hn = new V(H.normal.x, H.normal.y, H.normal.z);

		ray ray = new ray(
		    hp.add(hn.mul(0.00001)),
		    hn.mul(sqrt(1-u1)).add(T.mul(rad*cos(u2)).add(B.mul(rad*sin(u2))))
		);
		return trace(ray, n);
	}
}

class MTL_Diffuse_red implements mtl {
	PVector IL(hit H, ray r, int n) {
		MTL_Diffuse D = new MTL_Diffuse();
		PVector v = D.IL(H,r,n);
		return new PVector(v.x*0.9, v.y*0.1, v.z*0.1);
	}
}

class MTL_Diffuse_green implements mtl {
	PVector IL(hit H, ray r, int n) {
		MTL_Diffuse D = new MTL_Diffuse();
		PVector v = D.IL(H,r,n);
		return new PVector(v.x*0.1, v.y*0.9, v.z*0.1);
	}
}
