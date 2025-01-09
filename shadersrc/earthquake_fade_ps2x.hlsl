//Causes the screen to shake. Intensity fades in and out.
#include "common.hlsl"

#define Distortion Constants0.x
#define Random     Constants0.y

// entry point
float4 main( PS_INPUT i ) : COLOR
{
	float2 offset;
    offset.x = Distortion * Random;
    offset.y = Distortion * Random;
	
    float2 new_uv = i.uv + offset;

	return tex2D(TexBase, new_uv);	
}