class hit {
	float dist;
	V pos;
	V normal;
	mtl M;

	hit() {
		dist = 100000000;
		pos = new V(0);
		normal = new V(0);
		M = new MTL_BG();
	}
}
