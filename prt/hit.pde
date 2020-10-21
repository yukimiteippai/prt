// structure to store ray-surface intersection
class Hit {
	float dist; // distance from the ray origin
	PVector pos;
	PVector normal;
	Material mtl;
}