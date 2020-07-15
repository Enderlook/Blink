// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Additive Dissolve HDR"
{
	Properties
	{
		_Speed("Speed", Float) = 0.5
		_FirstFlamesScale("First Flames Scale", Float) = 0
		_SecondFlameScale("Second Flame Scale", Float) = 7
		_Power("Power", Float) = 0.4
		_Dissolve("Dissolve", Float) = 1
		_SharpColor("Sharp Color", Float) = 0.6
		_Step("Step", Float) = 0.56
		[HDR]_MiddleColor("Middle Color", Color) = (0.8509804,0.6960198,0.1882353,1)
		[HDR]_BackColor("Back Color", Color) = (0.9339623,0.08370414,0.08370414,0)
		_NoiseScaleVertex("Noise Scale Vertex", Float) = 10
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_OscillatorAmount("Oscillator Amount", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _NoiseScaleVertex;
		uniform float _OscillatorAmount;
		uniform float _SharpColor;
		uniform float _Dissolve;
		uniform float _Speed;
		uniform float _FirstFlamesScale;
		uniform float _SecondFlameScale;
		uniform float _Power;
		uniform float4 _MiddleColor;
		uniform float4 _BackColor;
		uniform float _Step;
		uniform float _Opacity;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline float2 UnityVoronoiRandomVector( float2 UV, float offset )
		{
			float2x2 m = float2x2( 15.27, 47.63, 99.41, 89.98 );
			UV = frac( sin(mul(UV, m) ) * 46839.32 );
			return float2( sin(UV.y* +offset ) * 0.5 + 0.5, cos( UV.x* offset ) * 0.5 + 0.5 );
		}
		
		//x - Out y - Cells
		float3 UnityVoronoi( float2 UV, float AngleOffset, float CellDensity )
		{
			float2 g = floor( UV * CellDensity );
			float2 f = frac( UV * CellDensity );
			float t = 8.0;
			float3 res = float3( 8.0, 0.0, 0.0 );
		
			for( int y = -1; y <= 1; y++ )
			{
				for( int x = -1; x <= 1; x++ )
				{
					float2 lattice = float2( x, y );
					float2 offset = UnityVoronoiRandomVector( lattice + g, AngleOffset );
					float d = distance( lattice + offset, f );
		
					if( d < res.x )
					{
						res = float3( d, offset.x, offset.y );
					}
				}
			}
			return res;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float simplePerlin2D44 = snoise( ( ase_vertex3Pos + _Time.y ).xy*_NoiseScaleVertex );
			simplePerlin2D44 = simplePerlin2D44*0.5 + 0.5;
			v.vertex.xyz = ( ase_vertex3Pos + ( ( ase_worldNormal * simplePerlin2D44 ) * _OscillatorAmount ) );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_2_0 = ( _Time.y * _Speed );
			float2 appendResult5 = (float2(0.0 , temp_output_2_0));
			float3 unityVoronoy8 = UnityVoronoi((i.uv_texcoord*1.0 + appendResult5),2.0,_FirstFlamesScale);
			float3 unityVoronoy12 = UnityVoronoi((i.uv_texcoord*1.0 + ( temp_output_2_0 * float2( 1.3,2 ) )),2.0,_SecondFlameScale);
			float blendOpSrc13 = unityVoronoy8.x;
			float blendOpDest13 = unityVoronoy12.x;
			float temp_output_13_0 = ( saturate( (( blendOpDest13 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest13 ) * ( 1.0 - blendOpSrc13 ) ) : ( 2.0 * blendOpDest13 * blendOpSrc13 ) ) ));
			float temp_output_23_0 = ( ( i.uv_texcoord.y * 0.1 ) + ( ( i.uv_texcoord.y * _Dissolve ) + ( temp_output_13_0 * pow( temp_output_13_0 , _Power ) ) ) );
			float4 lerpResult28 = lerp( ( step( _SharpColor , temp_output_23_0 ) * _MiddleColor ) , _BackColor , _BackColor);
			o.Emission = ( lerpResult28 * ( ( i.vertexColor.a * step( _Step , temp_output_23_0 ) ) * _Opacity ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
0;51;1918;1008;1134.348;-57.09575;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;36;-4745.289,-125.2027;Inherit;False;2751.447;1064.152;;23;55;8;23;19;22;16;20;17;21;14;15;13;12;11;6;7;5;9;2;10;3;1;56;Shape;0.5024819,0.8207547,0.1355019,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-4695.289,174.8868;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-4692.289,344.8868;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;False;0;False;0.5;0.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;10;-4449.569,726.0637;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;False;1.3,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-4446.289,235.8868;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-4243.568,608.0637;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-4252.287,213.8868;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;7;-4241.855,356.6108;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-3975.842,305.361;Inherit;False;Property;_FirstFlamesScale;First Flames Scale;1;0;Create;True;0;0;False;0;False;0;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-3987.75,810.0592;Inherit;False;Property;_SecondFlameScale;Second Flame Scale;3;0;Create;True;0;0;False;0;False;7;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;6;-4011.289,75.8867;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;11;-3996.083,560.0303;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;12;-3659.955,559.6243;Inherit;True;0;0;1;0;1;False;1;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;7;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;8;-3666.637,77.07674;Inherit;True;0;0;1;0;1;False;1;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;4;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.RangedFloatNode;15;-3210.393,670.5549;Inherit;False;Property;_Power;Power;4;0;Create;True;0;0;False;0;False;0.4;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;13;-3302.393,384.5553;Inherit;True;Overlay;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-2973.393,515.5552;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2934.841,182.333;Inherit;False;Property;_Dissolve;Dissolve;5;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;17;-2983.769,-75.20268;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;53;-1918.53,1103.621;Inherit;False;1899.066;634;;11;38;42;43;45;44;48;47;49;50;51;52;Vertex Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2718.841,78.33299;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2711.393,390.5553;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;42;-1831.464,1474.621;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2424.841,274.333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;-1868.53,1196.797;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;37;-1957.713,-160.7604;Inherit;False;1504.082;1031.857;;12;31;25;33;24;30;27;35;32;29;26;34;28;Color;0.9056604,0.6114251,0.1324315,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2439.841,-26.667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1551.464,1622.621;Inherit;False;Property;_NoiseScaleVertex;Noise Scale Vertex;10;0;Create;True;0;0;False;0;False;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1540.464,1375.621;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;23;-2228.841,250.333;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1907.713,696.0968;Inherit;False;Property;_Step;Step;7;0;Create;True;0;0;False;0;False;0.56;0.365;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1896.44,-110.7604;Inherit;False;Property;_SharpColor;Sharp Color;6;0;Create;True;0;0;False;0;False;0.6;0.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;24;-1622.44,-104.7604;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;33;-1592.713,370.0968;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;27;-1622.44,136.2396;Inherit;False;Property;_MiddleColor;Middle Color;8;1;[HDR];Create;True;0;0;False;0;False;0.8509804,0.6960198,0.1882353,1;1.498039,1.207843,0.02352941,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;47;-1264.464,1153.621;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;30;-1612.713,566.0968;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;44;-1265.464,1475.621;Inherit;True;Simplex2D;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1343.44,25.23962;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1359.713,761.0968;Inherit;False;Property;_Opacity;Opacity;11;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-1046.63,153.2238;Inherit;False;Property;_BackColor;Back Color;9;1;[HDR];Create;True;0;0;False;0;False;0.9339623,0.08370414,0.08370414,0;3.320755,0,0.06127354,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-869.464,1456.621;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-855.464,1313.621;Inherit;False;Property;_OscillatorAmount;Oscillator Amount;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1328.713,512.0968;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-541.464,1381.621;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;28;-718.6304,13.22382;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;51;-530.4641,1191.621;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1014.713,602.0968;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-306.2407,347.4455;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-254.4641,1315.621;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;16.88002,129.6979;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Particles/Additive Dissolve HDR;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0;True;False;0;True;Transparent;;Transparent;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;4;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;9;0;2;0
WireConnection;9;1;10;0
WireConnection;5;1;2;0
WireConnection;6;0;7;0
WireConnection;6;2;5;0
WireConnection;11;0;7;0
WireConnection;11;2;9;0
WireConnection;12;0;11;0
WireConnection;12;2;56;0
WireConnection;8;0;6;0
WireConnection;8;2;55;0
WireConnection;13;0;8;0
WireConnection;13;1;12;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;20;0;17;2
WireConnection;20;1;21;0
WireConnection;16;0;13;0
WireConnection;16;1;14;0
WireConnection;22;0;20;0
WireConnection;22;1;16;0
WireConnection;19;0;17;2
WireConnection;43;0;38;0
WireConnection;43;1;42;0
WireConnection;23;0;19;0
WireConnection;23;1;22;0
WireConnection;24;0;25;0
WireConnection;24;1;23;0
WireConnection;30;0;31;0
WireConnection;30;1;23;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;48;0;47;0
WireConnection;48;1;44;0
WireConnection;32;0;33;4
WireConnection;32;1;30;0
WireConnection;50;0;48;0
WireConnection;50;1;49;0
WireConnection;28;0;26;0
WireConnection;28;1;29;0
WireConnection;28;2;29;0
WireConnection;34;0;32;0
WireConnection;34;1;35;0
WireConnection;57;0;28;0
WireConnection;57;1;34;0
WireConnection;52;0;51;0
WireConnection;52;1;50;0
WireConnection;0;2;57;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=CCCC44908BDAD943D62A32C44F63902515B26C7B