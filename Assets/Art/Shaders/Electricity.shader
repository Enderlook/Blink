// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Game/Effects/Electricity"
{
	Properties
	{
		[HDR]_ElectricityColor("Electricity Color", Color) = (0,0.5455334,0.8396226,0)
		_ElectricityScale("Electricity Scale", Float) = 20
		_ElectricityAmount("Electricity Amount", Float) = 2
		_ElectricityNoiseSpeed("Electricity Noise Speed", Vector) = (0.1,-0.5,0,0)
		_ElectricityHeight("Electricity Height", Float) = 0.5
		_NoiseSpeed("Noise Speed", Vector) = (-0.1,0.5,0,0)
		_MaskSize("Mask Size", Float) = 1
		_MaskOpacity("Mask Opacity", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow nofog 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _MaskSize;
		uniform float _MaskOpacity;
		uniform float2 _NoiseSpeed;
		uniform float _ElectricityScale;
		uniform float2 _ElectricityNoiseSpeed;
		uniform float _ElectricityAmount;
		uniform float _ElectricityHeight;
		uniform float4 _ElectricityColor;


		inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }

		inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }

		inline float valueNoise (float2 uv)
		{
			float2 i = floor(uv);
			float2 f = frac( uv );
			f = f* f * (3.0 - 2.0 * f);
			uv = abs( frac(uv) - 0.5);
			float2 c0 = i + float2( 0.0, 0.0 );
			float2 c1 = i + float2( 1.0, 0.0 );
			float2 c2 = i + float2( 0.0, 1.0 );
			float2 c3 = i + float2( 1.0, 1.0 );
			float r0 = noise_randomValue( c0 );
			float r1 = noise_randomValue( c1 );
			float r2 = noise_randomValue( c2 );
			float r3 = noise_randomValue( c3 );
			float bottomOfGrid = noise_interpolate( r0, r1, f.x );
			float topOfGrid = noise_interpolate( r2, r3, f.x );
			float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
			return t;
		}


		float SimpleNoise(float2 UV)
		{
			float t = 0.0;
			float freq = pow( 2.0, float( 0 ) );
			float amp = pow( 0.5, float( 3 - 0 ) );
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(1));
			amp = pow(0.5, float(3-1));
			t += valueNoise( UV/freq )*amp;
			freq = pow(2.0, float(2));
			amp = pow(0.5, float(3-2));
			t += valueNoise( UV/freq )*amp;
			return t;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 CenteredUV15_g3 = ( i.uv_texcoord - float2( 0.5,0.5 ) );
			float2 break17_g3 = CenteredUV15_g3;
			float2 appendResult23_g3 = (float2(( length( CenteredUV15_g3 ) * _MaskSize * 2.0 ) , ( atan2( break17_g3.x , break17_g3.y ) * ( 1.0 / 6.28318548202515 ) * 1.0 )));
			float clampResult31 = clamp( ( 1.0 - pow( appendResult23_g3.x , _MaskOpacity ) ) , 0.0 , 1.0 );
			float2 uv_TexCoord16 = i.uv_texcoord + ( _Time.y * _NoiseSpeed );
			float simpleNoise17 = SimpleNoise( uv_TexCoord16*_ElectricityScale );
			float2 uv_TexCoord1 = i.uv_texcoord + ( _Time.y * _ElectricityNoiseSpeed );
			float simpleNoise2 = SimpleNoise( uv_TexCoord1*_ElectricityScale );
			float2 temp_cast_0 = ((-10.0 + (pow( ( simpleNoise17 + simpleNoise2 ) , _ElectricityAmount ) - 0.0) * (10.0 - -10.0) / (1.0 - 0.0))).xx;
			float2 appendResult10_g4 = (float2(1.0 , _ElectricityHeight));
			float2 temp_output_11_0_g4 = ( abs( (temp_cast_0*2.0 + -1.0) ) - appendResult10_g4 );
			float2 break16_g4 = ( 1.0 - ( temp_output_11_0_g4 / fwidth( temp_output_11_0_g4 ) ) );
			float4 temp_output_21_0 = ( i.vertexColor * ( ( clampResult31 * saturate( min( break16_g4.x , break16_g4.y ) ) ) * _ElectricityColor ) );
			o.Emission = temp_output_21_0.rgb;
			o.Alpha = temp_output_21_0.a;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18701
0;0;1920;1059;648.3643;533.0406;1;True;False
Node;AmplifyShaderEditor.Vector2Node;18;-1915.334,-485.8034;Inherit;False;Property;_NoiseSpeed;Noise Speed;6;0;Create;True;0;0;False;0;False;-0.1,0.5;-0.1,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1919.313,-312.3336;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-1930.013,-119.0337;Inherit;False;Property;_ElectricityNoiseSpeed;Electricity Noise Speed;4;0;Create;True;0;0;False;0;False;0.1,-0.5;0.1,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1668.073,-506.8868;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1678.012,-168.0336;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1513.896,-552.2886;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1523.835,-213.4355;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1494.413,-339.0338;Inherit;False;Property;_ElectricityScale;Electricity Scale;2;0;Create;True;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1180.426,-626.3422;Inherit;False;Property;_MaskSize;Mask Size;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;17;-1254.395,-556.5522;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-1265.635,-217.6995;Inherit;False;Simple;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;24;-960.4946,-564.8417;Inherit;False;Polar Coordinates;-1;;3;7dab8e02884cf104ebefaa2e788e4162;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-674.9733,-481.0363;Inherit;False;Property;_MaskOpacity;Mask Opacity;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;25;-736.7944,-567.2417;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;19;-991.6357,-388.2032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-990.1165,-279.0268;Inherit;False;Property;_ElectricityAmount;Electricity Amount;3;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;7;-766.1315,-390.4283;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;21;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;29;-495.9734,-537.0364;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-610.553,-214.3866;Inherit;False;Property;_ElectricityHeight;Electricity Height;5;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;-597.1116,-389.921;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-10;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-340.7944,-530.2418;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;10;-377.5533,-327.3866;Inherit;False;Rectangle;-1;;4;6b23e0c975270fb4084c354b2c83366a;0;3;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;31;-181.5486,-528.0851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-392.7763,-185.9294;Inherit;False;Property;_ElectricityColor;Electricity Color;1;1;[HDR];Create;True;0;0;False;0;False;0,0.5455334,0.8396226,0;0,0.5450981,0.8392157,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;3.270714,-348.7005;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;20;168.1848,-420.4133;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;170.9477,-227.8483;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;394.8853,-312.9129;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;32;543.6357,-216.0406;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;827.0634,-408.7124;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Game/Effects/Electricity;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;4;0
WireConnection;15;1;18;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;16;1;15;0
WireConnection;1;1;5;0
WireConnection;17;0;16;0
WireConnection;17;1;3;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;24;3;28;0
WireConnection;25;0;24;0
WireConnection;19;0;17;0
WireConnection;19;1;2;0
WireConnection;7;0;19;0
WireConnection;7;1;8;0
WireConnection;29;0;25;0
WireConnection;29;1;30;0
WireConnection;9;0;7;0
WireConnection;26;0;29;0
WireConnection;10;1;9;0
WireConnection;10;3;11;0
WireConnection;31;0;26;0
WireConnection;27;0;31;0
WireConnection;27;1;10;0
WireConnection;13;0;27;0
WireConnection;13;1;12;0
WireConnection;21;0;20;0
WireConnection;21;1;13;0
WireConnection;32;0;21;0
WireConnection;0;2;21;0
WireConnection;0;9;32;3
ASEEND*/
//CHKSM=241E66BA6CEAF7C58E52DFC74F37E92CAE2B48A0