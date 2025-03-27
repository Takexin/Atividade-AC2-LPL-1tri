shader_type canvas_item;

void vertex() {
	  VERTEX += vec2(10.0, 0.0);

	// Called for every vertex the material is visible on.
}

void fragment() {
	//COLOR = texture(TEXTURE, UV);
	COLOR.b = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
