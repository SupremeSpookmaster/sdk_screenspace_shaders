//This is the file where all of your custom UI shaders should be contained.
#include "common.hlsl"

//The HUD we are planning to render.
#define Selection		Constants0.x

//Our arbitrary values.
#define Arbitrary_1		Constants0.y
#define Arbitrary_2		Constants0.z
#define Arbitrary_3		Constants0.w
#define Arbitrary_4		Constants1.x
#define Arbitrary_5		Constants1.y
#define Arbitrary_6		Constants1.z
#define Arbitrary_7		Constants1.w
#define Arbitrary_8		Constants2.x
#define Arbitrary_9		Constants2.y
#define Arbitrary_10	Constants2.z
#define Arbitrary_11	Constants2.w
#define Arbitrary_12	Constants3.x
#define Arbitrary_13	Constants3.y
#define Arbitrary_14	Constants3.z
#define Arbitrary_15	Constants3.w

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Utility stocks.

//Credit to George Theodorakis, this was taken from their strafe trainer.
bool ContainsSquare(float2 screen_point, float2 square_center, float2 square_size)
{
	float2 half_size = square_size * 0.5;
    return screen_point.x >= (square_center.x - half_size.x) 
		&& screen_point.x <= (square_center.x + half_size.x) 
		&& screen_point.y >= (square_center.y - half_size.y)
		&& screen_point.y <= (square_center.y + half_size.y);
}

//Credit to George Theodorakis, this was taken from their strafe trainer.
bool IsInBar(float2 uv, float2 barSize, float2 barPos, inout float barLocalPos)
{
	float2 barCenter = float2(.002, .02);

	barLocalPos = (uv.x - barPos.x) / barSize.x + 0.5;
	return ContainsSquare(uv,barPos,barSize);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Example UI: Display a red bar at the top of the client's screen, showing their current health.
//The health bar flashes and pulses when the user takes damage, and features a darker secondary bar depicting how much health was lost.

#define UI_Health_Scale_X	0.33
#define UI_Health_Scale_Y	0.02
#define UI_Health_Pos_X		0.5
#define UI_Health_Pos_Y		0.1

#define UI_Health_VFX_Duration 0.5
#define UI_Health_VFX_Scale 0.2

float4 HUD_Health(PS_INPUT i, float4 current)
{
	float4 UI_Health_Filled = float4(0.75, 0.1, 0.1, 1.0);
	float4 UI_Health_Flash = float4(1.0, 0.8, 0.8, 1.0);
	float4 UI_Health_Empty = float4(0.2, 0.2, 0.2, 1.0);
	float4 UI_Health_Lost = float4(0.33, 0.0, 0.0, 0.85);

	float barLocalPos;

	float VFXPotency = 0.0;
	if (Arbitrary_2 > 0.0)
		VFXPotency = Arbitrary_2 / UI_Health_VFX_Duration;

	if(IsInBar(i.uv, float2(UI_Health_Scale_X + (VFXPotency * UI_Health_VFX_Scale * UI_Health_Scale_X), UI_Health_Scale_Y + (VFXPotency * UI_Health_VFX_Scale * UI_Health_Scale_Y)), float2(UI_Health_Pos_X, UI_Health_Pos_Y), barLocalPos))
	{
		//If the position of this pixel on the screen, relative to the bar, is less than the percentage of health we have, color the pixel red.
		//Otherwise, color it gray.
		if(barLocalPos < Arbitrary_1)
		{
			//The plugin has told us our health bar should be flashing, so flash.
			if (Arbitrary_2 > 0.0)
			{
				float diff;
				diff = abs(UI_Health_Flash.r - UI_Health_Filled.r);
				float r = lerp(UI_Health_Filled.r, UI_Health_Flash.r, diff * VFXPotency);

				diff = abs(UI_Health_Flash.g - UI_Health_Filled.g);
				float g = lerp(UI_Health_Filled.g, UI_Health_Flash.g, diff * VFXPotency);

				diff = abs(UI_Health_Flash.b - UI_Health_Filled.b);
				float b = lerp(UI_Health_Filled.b, UI_Health_Flash.b, diff * VFXPotency);

				return float4(r, g, b, 1.0);
			}

			return UI_Health_Filled;		
		}
		else if (barLocalPos < Arbitrary_3)
		{
			return UI_Health_Lost;
		}
		else
		{
			return UI_Health_Empty;
		}
	}
	
	return current;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

float4 main( PS_INPUT i ) : COLOR
{
	//Grab the current value of the pixel, from the player's perspective, without any shader modifiers applied.
	float4 current = tex2D(TexBase, i.uv.xy);

	//Now, let's evaluate the Selection variable to determine which UI we wish to render to the client.
	if (Selection >= 1.0 && Selection < 2.0)
		return HUD_Health(i, current);

	//TODO: Figure out why this won't work?
	/*int HUD = round(Selection);
	switch(Selection)
	{
		case 1:
			return HUD_Health(i, current);
	}*/
	
	//There was no specified UI, do not change the pixel.
	return current;
}