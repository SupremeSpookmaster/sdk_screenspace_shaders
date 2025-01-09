

#include "common.hlsl"

#define vx			Constants0.x
#define vy			Constants0.y
#define vz			Constants0.z
#define vxprev		Constants2.x
#define vyprev		Constants2.y
#define vzprev		Constants2.z
#define dt			Constants1.x
#define tickInterval Constants1.y
#define aaPerTick	Constants1.z
#define maxAccel	Constants1.w

#define boxx		Constants3.x
#define boxy		Constants3.y
#define boxxsize	Constants3.z
#define boxysize	Constants3.w


#define filledColor float4(.9,.9,.9,1)
#define emptyColor float4(.2,.2,.2,1)
#define centerColor float4(0,0,0,1);

#define PI 3.1415926535

//ok so
//we need to calculate how much the player's velocity should change
//if their xy velocity is v
//the next tick it should be sqrt(v^2+maxAccel^2)
//in the direction of current angle + atan2(v,maxAccel)
//so in a given frame, the angle change should be atan2(v,maxAccel)*dt/tickInterval

float idealAngleChange(float velocity){
	return atan2(maxAccel,velocity)*dt/tickInterval;
}
float angleChange(){
	float currentangle = atan2(vy,vx);
	float prevangle = atan2(vyprev,vxprev);
	float delta = currentangle-prevangle;
	if(delta > PI){
		delta -= PI + PI;
	}
	if(delta < -PI){
		delta += PI + PI;
	}
	return delta;
}
float hypot(float x, float y){
	return sqrt(x*x+y*y);
}

bool ContainsSquare(float2 screen_point, float2 square_center, float2 square_size)
{
	float2 half_size = square_size * 0.5;
    return screen_point.x >= (square_center.x - half_size.x) 
		&& screen_point.x <= (square_center.x + half_size.x) 
		&& screen_point.y >= (square_center.y - half_size.y)
		&& screen_point.y <= (square_center.y + half_size.y);
}
float4 main( PS_INPUT i ) : COLOR
{
    float4 color = tex2D(TexBase, i.uv);
	float2 barSize = float2(boxxsize,boxysize);
	float2 barPos = float2(boxx,boxy);
	float2 barCenter = float2(.002,.02);
	if(ContainsSquare(i.uv,barPos,barCenter)){
		return centerColor;
	}
	float barLocalPos = (i.uv.x - barPos.x) / barSize.x + 0.5;
	if(ContainsSquare(i.uv,barPos,barSize)){
		float dAngle = angleChange();
		float proportion = abs(dAngle)/idealAngleChange(length(float2(vxprev,vyprev)));
		//proportion = abs(dAngle)*3;
		//proportion = vx/520;
		if(dAngle > 0){
			barLocalPos = 1 - barLocalPos;
		}
		if(barLocalPos < proportion / 2){
			return filledColor;		
		}else{
			return emptyColor;
		}
		
	}
	return color;
}
