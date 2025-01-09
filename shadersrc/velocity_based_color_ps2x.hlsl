//Causes the world's color to fade in and out based on your velocity, relative to a specified target speed.
#include "common.hlsl"

#define PlayerSpeed   Constants0.yzw

#define MaxColor Constants0.x
#define TargetSpeed Constants1.x
#define MinColor Constants1.y
#define FadeSpeed Constants1.z

// entry point
float4 main( PS_INPUT i ) : COLOR
{
	float speed = length(PlayerSpeed);
	float intensity = saturate(speed / TargetSpeed);

	float4 color = tex2D(TexBase, i.uv);
	float3 greyscale = float3(MinColor, MinColor, MinColor);
    float3 dotty = dot( float3(color.r, color.g, color.b), greyscale );

	color.r = lerp(dotty.r, color.r, intensity * MaxColor);
	color.g = lerp(dotty.g, color.g, intensity * MaxColor);
	color.b = lerp(dotty.b, color.b, intensity * MaxColor);

	return color;
}