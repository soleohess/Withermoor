shader_type canvas_item;

uniform float red = 1.0;
uniform float green = 0.5;
uniform float blue = 1.0;
uniform float opacity = 1.0;

uniform float weight = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = texture(TEXTURE, UV);
	COLOR.r = (1.0-weight)*COLOR.r + weight*red;
	COLOR.g = (1.0-weight)*COLOR.g + weight*green;
	COLOR.b = (1.0-weight)*COLOR.b + weight*blue;
	COLOR.a = (1.0-weight)*COLOR.a + weight*opacity;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
