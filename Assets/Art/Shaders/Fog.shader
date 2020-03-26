Shader "Game/Fog"
{
	Properties
	{
		_Emission("Emission", Color) = (0,0,0,0)
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0.503126
		_FogMinIntensity("Fog Min Intensity", Range( 0 , 1)) = 0
		_FogMaxIntensifty("Fog Max Intensifty", Range( 0 , 1)) = 1
		_Speed("Speed", Vector) = (0.1,0.1,0,0)
		_Scale("Scale", Range( 0 , 25)) = 5
		_Amount("Amount", Range( 0 , 50)) = 15
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float2 _Speed;
		uniform float _Scale;
		uniform float _Amount;
		uniform float4 _Emission;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FogIntensity;
		uniform float _FogMinIntensity;
		uniform float _FogMaxIntensifty;


		float2 UnityGradientNoiseDir( float2 p )
		{
			p = fmod(p , 289);
			float x = fmod((34 * p.x + 1) * p.x , 289) + p.y;
			x = fmod( (34 * x + 1) * x , 289);
			x = frac( x / 41 ) * 2 - 1;
			return normalize( float2(x - floor(x + 0.5 ), abs( x ) - 0.5 ) );
		}

		float UnityGradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 ip = floor( p );
			float2 fp = frac( p );
			float d00 = dot( UnityGradientNoiseDir( ip ), fp );
			float d01 = dot( UnityGradientNoiseDir( ip + float2( 0, 1 ) ), fp - float2( 0, 1 ) );
			float d10 = dot( UnityGradientNoiseDir( ip + float2( 1, 0 ) ), fp - float2( 1, 0 ) );
			float d11 = dot( UnityGradientNoiseDir( ip + float2( 1, 1 ) ), fp - float2( 1, 1 ) );
			fp = fp * fp * fp * ( fp * ( fp * 6 - 15 ) + 10 );
			return lerp( lerp( d00, d01, fp.y ), lerp( d10, d11, fp.y ), fp.x ) + 0.5;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner14 = ( _Time.y * _Speed + i.uv_texcoord);
			float gradientNoise12 = UnityGradientNoise(panner14,_Scale);
			gradientNoise12 = gradientNoise12*0.5 + 0.5;
			float3 temp_cast_0 = (pow( gradientNoise12 , _Amount )).xxx;
			o.Albedo = temp_cast_0;
			o.Emission = _Emission.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth2 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy ));
			float clampResult9 = clamp( abs( ( ( eyeDepth2 - ase_screenPos.w ) * _FogIntensity ) ) , _FogMinIntensity , _FogMaxIntensifty );
			o.Alpha = clampResult9;
		}

		ENDCG
	}
}