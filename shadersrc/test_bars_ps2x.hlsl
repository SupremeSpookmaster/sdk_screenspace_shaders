//Displays three bars at the bottom of the screen, which fill up and empty themselves at different speeds.
//Created as a proof-of-concept for custom UI elements.
//This was originally George Theodorakis' strafe meter, I just made heavy edits.
#include "common.hlsl"

#define greenbox_x		Constants0.x
#define greenbox_y		Constants0.y
#define greenbox_xsize	Constants0.z
#define greenbox_ysize	Constants0.w

#define bluebox_x		Constants1.x
#define bluebox_y		Constants1.y
#define bluebox_xsize	Constants1.z
#define bluebox_ysize	Constants1.w

#define redbox_x		Constants2.x
#define redbox_y		Constants2.y
#define redbox_xsize	Constants2.z
#define redbox_ysize	Constants2.w

#define filledColor_Green float4(.3,.9,.3,1)
#define filledColor_Blue float4(.3,.3,.9,1)
#define filledColor_Red float4(.9,.3,.3,1)

#define emptyColor float4(.2,.2,.2,1)

#define PI 3.1415926535

#define Fill_Amt_Green	Constants3.x
#define Fill_Amt_Blue	Constants3.y
#define Fill_Amt_Red	Constants3.z

bool ContainsSquare(float2 screen_point, float2 square_center, float2 square_size)
{
	float2 half_size = square_size * 0.5;
    return screen_point.x >= (square_center.x - half_size.x) 
		&& screen_point.x <= (square_center.x + half_size.x) 
		&& screen_point.y >= (square_center.y - half_size.y)
		&& screen_point.y <= (square_center.y + half_size.y);
}

bool IsInColorZone(float2 uv, bool green, bool blue, bool red, inout float barLocalPos)
{
	float2 barSize = float2(greenbox_xsize, greenbox_ysize);
	float2 barPos = float2(greenbox_x, greenbox_y);
	if (blue)
	{
		barSize = float2(bluebox_xsize, bluebox_ysize);
		barPos = float2(bluebox_x, bluebox_y);
	}
	else if (red)
	{
		barSize = float2(redbox_xsize, redbox_ysize);
		barPos = float2(redbox_x, redbox_y);
	}

	float2 barCenter = float2(.002, .02);

	barLocalPos = (uv.x - barPos.x) / barSize.x + 0.5;
	return ContainsSquare(uv, barPos, barSize);
}

float4 main( PS_INPUT i ) : COLOR
{
    float4 color = tex2D(TexBase, i.uv);

	float barLocalPos;

	if(IsInColorZone(i.uv, true, false, false, barLocalPos))
	{
		if(barLocalPos < Fill_Amt_Green)
		{
			return filledColor_Green;		
		}
		else
		{
			return emptyColor;
		}
	}
	else if(IsInColorZone(i.uv, false, true, false, barLocalPos))
	{
		if(barLocalPos < Fill_Amt_Blue)
		{
			return filledColor_Blue;		
		}
		else
		{
			return emptyColor;
		}
	}
	else if(IsInColorZone(i.uv, false, false, true, barLocalPos))
	{
		if(barLocalPos < Fill_Amt_Red)
		{
			return filledColor_Red;		
		}
		else
		{
			return emptyColor;
		}
	}

	return color;
}