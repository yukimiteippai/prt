void setup() {
	colorMode(RGB, 1.0);
	size(512,512);
}

color render(int x, int y) {
	// define color with x and y
	PVector result = new PVector((float)x/width, (float)y/height, 0);
	return toColor(result);
}

void draw() {
	// update pixels
	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y); // calculate color for each pixel on (x, y)
		}
	}
	updatePixels();
}