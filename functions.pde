void tangentspace_basis(PVector n, PVector T, PVector B){
	int sg = (n.z<0) ?-1 :1;
	float a = -1/(sg+n.z);
	float b = n.x * n.y * a;
	T.set(1 + sg*n.x*n.x*a, sg*b, -sg*n.x);
	B.set(b, sg + n.y*n.y*a, -n.y);
}

PMatrix3D tangentspace_mat(PVector n){
	int sg = (n.z<0) ?-1 :1;
	float a = -1/(sg+n.z);
	float b = n.x * n.y * a;
	return new PMatrix3D(
		1 + sg*n.x*n.x*a, b, n.x, 0,
		sg*b, sg + n.y*n.y*a, n.y, 0,
		-sg*n.x, -n.y, n.z, 0, 
		0, 0, 0, 0
	);
}

PVector sampleHemisphere_cosine(float u1, float u2){
	float rad = sqrt(u1);
	u2 = u2*TWO_PI;
	return new PVector(rad*cos(u2), rad*sin(u2), sqrt(1-u1));
}