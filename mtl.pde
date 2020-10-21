enum MtlType{
	DIFFUSE,
	SPECULAR,
};

class Material {
	PVector emission = null;
	PVector reflection = null;
	MtlType type = MtlType.DIFFUSE;
}