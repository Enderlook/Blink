// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Ambient/Depth Fog"
{
	Properties
	{
		_TintColor("Tint Color", Color) = (0,0,0,0)
		_FogOpacity("Fog Opacity", Range( 0 , 1)) = 0
		_FogIntensity("Fog Intensity", Range( 0 , 1)) = 0
		_Gradient("Gradient", 2D) = "white" {}
		[Toggle(_APPLYMOVEINTEXTURE_ON)] _ApplyMoveInTexture("Apply Move In Texture?", Float) = 1
		_GradientIntensity("Gradient Intensity", Range( 0 , 1)) = 0
		_GradientUSpeed("Gradient U Speed", Float) = -0.2
		_GradientVSpeed("Gradient V Speed", Float) = -0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _APPLYMOVEINTEXTURE_ON
		#pragma surface surf Standard alpha:fade keepalpha noshadow noinstancing noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Gradient;
		uniform float _GradientUSpeed;
		uniform float _GradientVSpeed;
		uniform float _GradientIntensity;
		uniform float4 _TintColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _FogOpacity;
		uniform float _FogIntensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult23 = (float2(_GradientUSpeed , _GradientVSpeed));
			#ifdef _APPLYMOVEINTEXTURE_ON
				float2 staticSwitch33 = ( i.uv_texcoord + ( _Time.y * appendResult23 ) );
			#else
				float2 staticSwitch33 = i.uv_texcoord;
			#endif
			float4 gradient31 = ( tex2D( _Gradient, staticSwitch33 ) * _GradientIntensity );
			o.Albedo = gradient31.rgb;
			o.Emission = _TintColor.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float eyeDepth3 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPos.xy ));
			float clampResult9 = clamp( ( abs( ( eyeDepth3 - ase_screenPos.w ) ) * (0.01 + (_FogOpacity - 0.0) * (0.4 - 0.01) / (1.0 - 0.0)) ) , 0.0 , _FogIntensity );
			float fogEffect13 = clampResult9;
			o.Alpha = fogEffect13;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;5904.288;1263.425;2.886694;True;True
Node;AmplifyShaderEditor.CommentaryNode;28;-4634.238,-1037.568;Inherit;False;3301.469;942.1364;Comment;12;31;30;18;29;27;20;24;23;25;22;21;33;Gradient;0.1902367,0.4245283,0.2678533,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2754.625,431.612;Inherit;False;1791.903;613.5511;Comment;10;9;1;6;10;7;8;4;3;2;13;Fog Effect;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-4584.238,-596.6619;Inherit;False;Property;_GradientUSpeed;Gradient U Speed;6;0;Create;True;0;0;False;0;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-4581.543,-471.9497;Inherit;False;Property;_GradientVSpeed;Gradient V Speed;7;0;Create;True;0;0;False;0;-0.2;-0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-2704.625,522.6119;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;25;-4210.455,-806.1592;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-4237.458,-576.6718;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;20;-3832.021,-987.5684;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3822.456,-644.1592;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenDepthNode;3;-2457.625,481.612;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2428.112,777.8592;Inherit;False;Property;_FogOpacity;Fog Opacity;1;0;Create;True;0;0;False;0;0;0.185;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-2190.628,599.6116;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-3481.642,-779.0916;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;10;-2062.86,783.3587;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.01;False;4;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;7;-1989.984,600.0955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;33;-3153.058,-987.4081;Inherit;True;Property;_ApplyMoveInTexture;Apply Move In Texture?;4;0;Create;True;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2696.868,-709.6285;Inherit;True;Property;_GradientIntensity;Gradient Intensity;5;0;Create;True;0;0;False;0;0;0.054;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-2710.783,-977.8195;Inherit;True;Property;_Gradient;Gradient;3;0;Create;True;0;0;False;0;-1;029b4a508a61fa04683a31ee0a6d7d4b;029b4a508a61fa04683a31ee0a6d7d4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;-1852.885,904.8146;Inherit;False;Property;_FogIntensity;Fog Intensity;2;0;Create;True;0;0;False;0;0;0.502;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1792.392,653.0955;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;9;-1527.447,781.3306;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2263.645,-823.6307;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;15;-410.6761,-50;Inherit;False;811.7159;892.1844;Comment;4;0;16;14;32;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1285.561,774.3669;Inherit;True;fogEffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1937.461,-827.8499;Inherit;True;gradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-367.4097,583.5581;Inherit;True;13;fogEffect;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-367.7393,395.8592;Inherit;False;Property;_TintColor;Tint Color;0;0;Create;True;0;0;False;0;0,0,0,0;0.4727653,0.1384387,0.4811321,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;32;-364.2264,159.379;Inherit;True;31;gradient;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-6.733644,306.3808;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AvalonStudios/Ambient/Depth Fog;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;True;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;24;0;25;0
WireConnection;24;1;23;0
WireConnection;3;0;2;0
WireConnection;4;0;3;0
WireConnection;4;1;2;4
WireConnection;27;0;20;0
WireConnection;27;1;24;0
WireConnection;10;0;8;0
WireConnection;7;0;4;0
WireConnection;33;1;20;0
WireConnection;33;0;27;0
WireConnection;18;1;33;0
WireConnection;6;0;7;0
WireConnection;6;1;10;0
WireConnection;9;0;6;0
WireConnection;9;2;1;0
WireConnection;30;0;18;0
WireConnection;30;1;29;0
WireConnection;13;0;9;0
WireConnection;31;0;30;0
WireConnection;0;0;32;0
WireConnection;0;2;16;0
WireConnection;0;9;14;0
ASEEND*/
//CHKSM=5DA84C5250AAD1D7D7E03A44A1EC6FA8C47B4BE1