
// Barrel distort shader for Monkey:

// Synchronized variable(s):
uniform sampler2D ColorTexture;
uniform float EffectPower;

// Constant variable(s):
const float PI = 3.1415926535;

// Functions:
vec2 Distort(vec2 p, float len)
{
    float theta  = atan(p.y, p.x);
    float radius = len;
    
    radius = pow(radius, EffectPower);
    
    p.x = radius * cos(theta);
    p.y = radius * sin(theta);
    
    return 0.5 * (p + 1.0);
}

vec2 Distort(vec2 p)
{
	return Distort(p, length(p));
}

void shader()
{
	// Local variable(s):
	vec2 xy = (2.0 * b3d_Texcoord0 - 1.0);
	vec2 uv;
	
	float d = length(xy);
	
	if (d < 1.0)
	{
		uv = Distort(xy, d);
	}
	else
	{
		uv = b3d_Texcoord0;
	}
	
	vec4 color = texture2D(ColorTexture, uv);
	
	// Apply gamma correction:
	#if GAMMA_CORRECTION
		color.rgb = pow(color.rgb, vec3(2.2));
	#endif
	
	color *= b3d_Color;
	
	// Set the color.
	b3d_Ambient = color;
	
	// Apply gamma correction:
	#if GAMMA_CORRECTION
		b3d_Ambient.rgb = pow(b3d_Ambient.rgb, vec3(2.2));
	#endif
	
	// Apply vertex color.
	b3d_Ambient *= b3d_Color;
	
	// Apply alpha.
	b3d_Alpha = b3d_Ambient.a;
	
	return;
}
