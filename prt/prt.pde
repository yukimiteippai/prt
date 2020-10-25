void setup() {
	colorMode(RGB, 1.0);
	size(512,512);
}

// calculate color on (x, y)
color render(int x, int y) {
	PVector result = new PVector((float)x/width, (float)y/height, 0);
	return toColor(result);
}

void draw() {
	// update pixels
	loadPixels();
	for (int y=0; y<height; y++) {
		for (int x=0; x<width; x++) {
			pixels[y*width + x] = render(x, y);
		}
	}
	updatePixels();
}