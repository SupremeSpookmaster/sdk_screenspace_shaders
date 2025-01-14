// Template shader that does nothing interesting

// This contains parameters, etc that all shaders have available
// All shaders should include this
#include "common.hlsl"

// entry point

#define Arbitrary_R		Constants0.x
#define Arbitrary_G		Constants0.y
#define Arbitrary_B		Constants0.z

float4 main( PS_INPUT i ) : COLOR
{
	// copy each framebuffer pixel from rt_camera to the main screen:
	float4 current = tex2D(TexBase, i.uv.xy);
	
	return float4((Arbitrary_R + current.r) / 2.0, (Arbitrary_G + current.g) / 2.0, (Arbitrary_B + current.b) / 2.0, 1.0);
}