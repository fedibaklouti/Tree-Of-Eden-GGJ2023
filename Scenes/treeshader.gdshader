shader_type canvas_item;
render_mode blend_mix;
uniform float uvspeed = 0.0;
uniform vec2 motion = vec2(0.0);
uniform float scale = 1.0;
uniform vec2 offset = vec2(0.0);

const float maxSpeed = 4.0;

void fragment(){
	vec2 newuv = UV;
	//newuv.x += uvspeed;0
	vec2 motionClamped = clamp(motion, vec2(-maxSpeed, -maxSpeed), vec2(maxSpeed,maxSpeed));
	newuv += (offset + TIME * motionClamped);
	vec4 c = texture(TEXTURE, newuv);
	COLOR = c;
}
