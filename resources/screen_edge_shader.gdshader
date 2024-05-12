shader_type canvas_item;
render_mode blend_mix;

// NOTE: Make sure to set this to your rect size!
uniform vec2 uSize = vec2(1);

uniform float uPeriod : hint_range(0,1) = .07;
uniform float uAmplitude : hint_range(0,1) = .07;
uniform float uBorder : hint_range(0,1) = .03;
uniform float uWave : hint_range(0,.5) = .06;
uniform float uShift : hint_range(0,.5) = .3;
uniform float uColorStrength : hint_range(0,1) = .8;

// All components are in the range [0…1], including hue.
vec3 hsv2rgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// https://en.wikipedia.org/wiki/Triangle_wave
float triangleWave(float t, float period) {
	return 2. * abs(t/period - floor(t/period + .5));
}

float edgeEffect(float x, float y, float scale, float iTime) {
	// Make these shader uniforms and use game logic to manipulate the effect
	float wave = mix(.0, uWave, sin(x*scale*15.+iTime*10.)*.5+.5);
	float shift = -iTime*uShift;

	float ty = triangleWave(scale*(x+shift), uPeriod);

	return step(1.-abs(y), scale*(ty*uAmplitude+uBorder+wave));
}

void fragment() {
	// Normalized pixel coordinates (from -1 to 1)
	vec2 uv = UV * 2. - 1.;
	float aspectRatio = uSize.y/uSize.x;

	vec4 col = vec4(0);
	vec4 rainbow = vec4(uColorStrength * hsv2rgb(vec3(TIME*.1, .9, .9)), 1.);

	// top/bottom
	col = mix(col, rainbow, edgeEffect(uv.x, uv.y, 1., TIME));
	// left/right
	col = mix(col, rainbow, edgeEffect(uv.y, uv.x, aspectRatio, TIME));

	COLOR = col;
}