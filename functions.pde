// pass tangent(T) and bitangent(B) vector along the normal(n)
void tangentspace_basis(PVector n, PVector T, PVector B){
	int sg = (n.z<0) ?-1 :1;
	float a = -1/(sg+n.z);
	float b = n.x * n.y * a;
	T.set(1 + sg*n.x*n.x*a, sg*b, -sg*n.x);
	B.set(b, sg + n.y*n.y*a, -n.y);
}

// return tangent space along the normal(n)
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

// convert uniform 2d distribution into cosine distributed direction over a hemisphere.
PVector sampleHemisphere_cosine(float u1, float u2){
	float rad = sqrt(u1);
	u2 = u2*TWO_PI;
	return new PVector(rad*cos(u2), rad*sin(u2), sqrt(1-u1));
}

color toColor(PVector v){return color(v.x, v.y, v.z);}
PVector multC(PVector v1, PVector v2){return new PVector(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z);}