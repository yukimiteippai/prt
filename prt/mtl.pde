enum MtlType{
	DIFFUSE,
	SPECULAR,
};

class Material {
	PVector emission;
	PVector reflection;
	MtlType type;

	Material(PVector e, PVector r, MtlType t){
		emission = e;
		reflection = r;
		type = t;
	}

	Material(PVector e, PVector r){
		emission = e;
		reflection = r;
		type = MtlType.DIFFUSE;
	}
}