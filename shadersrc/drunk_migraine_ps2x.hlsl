//Blurs the screen by displacing pixels at random, then smears them all in a given direction which changes over time.
#include "common.hlsl"

#define Distortion Constants0.x
#define Direction  Constants0.y

float Random(float2 uv)
{
    return frac(sin(dot(uv,float2(12.9898,78.233)))*43758.5453123);
}

// entry point
float4 main( PS_INPUT i ) : COLOR
{
	float2 offset;
    offset.x = Distortion * Random(i.uv) + Direction;
    offset.y = Distortion * Random(i.uv) - Direction;
	
    float2 new_uv = i.uv + offset;

	return tex2D(TexBase, new_uv);	
}