// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/SkyBox/Procedural Sky"
{
	Properties
	{
		_Dark("Dark", Color) = (0,0,0,0)
		_Light("Light", Color) = (0,0,0,0)
		_LightEdge("Light Edge", Color) = (0,0,0,0)
		_DarkEdge("Dark Edge", Color) = (0,0,0,0)
		_DarkColorStrength("Dark Color Strength", Float) = 1
		_LightColorStrength("Light Color Strength", Float) = 1
		[Toggle(_HASSTARS_ON)] _HasStars("Has Stars?", Float) = 0
		_StarsScale("Stars Scale", Vector) = (8,2,0,0)
		_StarDensity1("Star Density", Float) = 10
		[Toggle(_HASFOG_ON)] _HasFog("Has Fog?", Float) = 0
		_FogHeight1("Fog Height", Range( 0 , 100)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Background"  "Queue" = "Background+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _HASFOG_ON
		#pragma shader_feature_local _HASSTARS_ON
		#pragma surface surf Unlit keepalpha noshadow nofog 
		struct Input
		{
			float3 worldPos;
		};

		uniform float4 _Dark;
		uniform float4 _Light;
		uniform float4 _LightEdge;
		uniform float _DarkColorStrength;
		uniform float4 _DarkEdge;
		uniform float _LightColorStrength;
		uniform float2 _StarsScale;
		uniform float _StarDensity1;
		uniform float _FogHeight1;


		inline float2 UnityVoronoiRandomVector( float2 UV, float offset )
		{
			float2x2 m = float2x2( 15.27, 47.63, 99.41, 89.98 );
			UV = frac( sin(mul(UV, m) ) * 46839.32 );
			return float2( sin(UV.y* +offset ) * 0.5 + 0.5, cos( UV.x* offset ) * 0.5 + 0.5 );
		}
		
		//x - Out y - Cells
		float2 UnityVoronoi( float2 UV, float AngleOffset, float CellDensity )
		{
			float2 g = floor( UV * CellDensity );
			float2 f = frac( UV * CellDensity );
			float t = 8.0;
			float2 res = float2( 8.0, 0.0 );
		
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult58 = normalize( ase_worldPos );
			float3 break59 = normalizeResult58;
			float2 appendResult67 = (float2(( atan2( break59.x , break59.z ) / 6.28318548202515 ) , ( asin( break59.y ) / ( UNITY_PI / 2.0 ) )));
			float2 skyUVs68 = appendResult67;
			float vTextCoord8 = (0.0 + (skyUVs68.y - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float4 lerpResult15 = lerp( _Dark , _Light , vTextCoord8);
			float4 lerpResult19 = lerp( lerpResult15 , _LightEdge , pow( vTextCoord8 , _DarkColorStrength ));
			float4 lerpResult21 = lerp( lerpResult19 , _DarkEdge , pow( ( 1.0 - vTextCoord8 ) , _LightColorStrength ));
			float4 lerpColors22 = lerpResult21;
			float3 normalizeResult2_g19 = normalize( ase_worldPos );
			float3 break4_g19 = normalizeResult2_g19;
			float2 appendResult13_g19 = (float2(( atan2( break4_g19.x , break4_g19.z ) / 6.28318548202515 ) , ( asin( break4_g19.y ) / ( UNITY_PI / 2.0 ) )));
			float2 appendResult39 = (float2(_Time.y , 0.0));
			float2 unityVoronoy30 = UnityVoronoi((appendResult13_g19*_StarsScale + ( 0.007 * appendResult39 )),20.0,_StarDensity1);
			float stars34 = pow( ( 1.0 - saturate( unityVoronoy30.x ) ) , 100.0 );
			#ifdef _HASSTARS_ON
				float4 staticSwitch35 = ( lerpColors22 + stars34 );
			#else
				float4 staticSwitch35 = lerpColors22;
			#endif
			float fog49 = pow( saturate( ( 1.0 - skyUVs68.y ) ) , _FogHeight1 );
			float4 lerpResult50 = lerp( staticSwitch35 , unity_FogColor , fog49);
			#ifdef _HASFOG_ON
				float4 staticSwitch53 = lerpResult50;
			#else
				float4 staticSwitch53 = staticSwitch35;
			#endif
			o.Emission = staticSwitch53.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1438;879;5924.661;2421.906;5.985919;True;True
Node;AmplifyShaderEditor.CommentaryNode;56;-2700.194,-1264.328;Inherit;False;1878.378;627.0276;Comment;12;67;66;65;64;63;62;61;60;59;58;57;68;World Position & Normalize;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;57;-2650.194,-1040.24;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;58;-2369.194,-1040.24;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;59;-2171.194,-1041.24;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PiNode;66;-2034.158,-770.2994;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;60;-1726.685,-1214.328;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;61;-1720.158,-1089.3;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ASinOpNode;63;-1722.158,-916.2994;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;65;-1725.158,-770.2994;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;62;-1533.158,-1166.3;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;64;-1533.158,-857.2994;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-1298.096,-1029.355;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;68;-1090.245,-1034.643;Inherit;False;skyUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1;-2735.063,-418.9482;Inherit;False;1263.111;589.2762;Comment;6;8;7;6;4;3;69;UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2703.33,1792.123;Inherit;False;2967.163;862.2771;Comment;14;41;40;39;38;34;33;32;31;30;29;28;27;26;25;Stars;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-2650.698,-91.93036;Inherit;True;68;skyUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;38;-2647.921,2302.035;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2354.842,2146.241;Inherit;False;Constant;_Float6;Float 5;10;0;Create;True;0;0;False;0;0.007;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;6;-2322.719,-85.95911;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;39;-2382.477,2300.871;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;7;-1970.704,-97.65891;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-2108.596,1935.975;Inherit;False;Property;_StarsScale;Stars Scale;8;0;Create;True;0;0;False;0;8,2;10,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2136.598,2225.714;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;25;-2117.168,1846.435;Inherit;False;SkyBoxUV;-1;;19;6daf9c390daef034a8dc1861130c5edc;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1563.309,2105.635;Inherit;False;Property;_StarDensity1;Star Density;9;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;29;-1765.596,1844.975;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;2;-2728.407,305.985;Inherit;False;2003.828;1394.349;Comment;14;22;21;20;19;18;17;16;15;14;13;12;11;10;9;Lerping Colors;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1746.669,-117.3141;Inherit;True;vTextCoord;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-2662.247,536.1707;Inherit;False;Property;_Light;Light;2;0;Create;True;0;0;False;0;0,0,0,0;0.8474941,0.8962264,0.1564168,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;9;-2639.644,830.2819;Inherit;False;8;vTextCoord;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-2678.496,342.4221;Inherit;False;Property;_Dark;Dark;1;0;Create;True;0;0;False;0;0,0,0,0;0.06915265,0.4597207,0.6981132,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;42;-2687.387,2757.158;Inherit;False;1538.758;342.5483;Comment;7;49;48;47;46;45;44;70;Fog;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2656.236,1041.011;Inherit;False;Property;_DarkColorStrength;Dark Color Strength;5;0;Create;True;0;0;False;0;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;30;-1337.563,1846.663;Inherit;True;0;0;1;0;1;False;1;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;20;False;2;FLOAT;5;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2668.867,2802.51;Inherit;True;68;skyUVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2215.052,1517.716;Inherit;False;Property;_LightColorStrength;Light Color Strength;6;0;Create;True;0;0;False;0;1;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-980.6547,1846.793;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;17;-2279.779,1013.834;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;15;-2269.891,458.1084;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-2280.249,791.5082;Inherit;False;Property;_LightEdge;Light Edge;3;0;Create;True;0;0;False;0;0,0,0,0;0.8396226,0.7490873,0.03564434,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;-2190.455,1292.217;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;18;-1884.452,1373.902;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;32;-694.6557,1845.793;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;44;-2403.288,2808.43;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;20;-1864.77,1119.559;Inherit;False;Property;_DarkEdge;Dark Edge;4;0;Create;True;0;0;False;0;0,0,0,0;0.09549653,0.3749693,0.5471698,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;19;-1890.625,778.675;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;-1446.305,1086.649;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;45;-2089.035,2831.332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;-399.6551,1845.793;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-1839.666,2832.606;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;-179.6225,557.5363;Inherit;False;1849.264;482;Comment;9;37;23;36;51;52;35;50;53;0;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1077.097,1077.964;Inherit;True;lerpColors;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-41.73492,1842.123;Inherit;False;stars;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1934.124,2987.707;Inherit;False;Property;_FogHeight1;Fog Height;11;0;Create;True;0;0;False;0;0;100;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-129.6225,643.0709;Inherit;False;22;lerpColors;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-120.4546,855.6948;Inherit;False;34;stars;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;-1624.124,2899.707;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-1391.629,2895.246;Inherit;False;fog;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;252.793,760.3124;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;51;492.9288,761.7971;Inherit;False;unity_FogColor;0;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;552.3031,855.8394;Inherit;False;49;fog;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;35;498.0987,645.2817;Inherit;False;Property;_HasStars;Has Stars?;7;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;50;867.7485,738.3485;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;27;-2097.495,2072.953;Inherit;False;Constant;_Vector2;Vector 1;4;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-2301.51,-365.6691;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1857.61,-378.237;Inherit;True;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;53;1093.267,648.8009;Inherit;False;Property;_HasFog;Has Fog?;10;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1406.642,607.5363;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/SkyBox/Procedural Sky;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Background;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;57;0
WireConnection;59;0;58;0
WireConnection;60;0;59;0
WireConnection;60;1;59;2
WireConnection;63;0;59;1
WireConnection;65;0;66;0
WireConnection;62;0;60;0
WireConnection;62;1;61;0
WireConnection;64;0;63;0
WireConnection;64;1;65;0
WireConnection;67;0;62;0
WireConnection;67;1;64;0
WireConnection;68;0;67;0
WireConnection;6;0;69;0
WireConnection;39;0;38;0
WireConnection;7;0;6;1
WireConnection;41;0;40;0
WireConnection;41;1;39;0
WireConnection;29;0;25;0
WireConnection;29;1;26;0
WireConnection;29;2;41;0
WireConnection;8;0;7;0
WireConnection;30;0;29;0
WireConnection;30;2;28;0
WireConnection;31;0;30;0
WireConnection;17;0;9;0
WireConnection;17;1;14;0
WireConnection;15;0;12;0
WireConnection;15;1;10;0
WireConnection;15;2;9;0
WireConnection;16;0;9;0
WireConnection;18;0;16;0
WireConnection;18;1;11;0
WireConnection;32;0;31;0
WireConnection;44;0;70;0
WireConnection;19;0;15;0
WireConnection;19;1;13;0
WireConnection;19;2;17;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;21;2;18;0
WireConnection;45;0;44;1
WireConnection;33;0;32;0
WireConnection;47;0;45;0
WireConnection;22;0;21;0
WireConnection;34;0;33;0
WireConnection;48;0;47;0
WireConnection;48;1;46;0
WireConnection;49;0;48;0
WireConnection;36;0;23;0
WireConnection;36;1;37;0
WireConnection;35;1;23;0
WireConnection;35;0;36;0
WireConnection;50;0;35;0
WireConnection;50;1;51;0
WireConnection;50;2;52;0
WireConnection;4;0;3;0
WireConnection;53;1;35;0
WireConnection;53;0;50;0
WireConnection;0;2;53;0
ASEEND*/
//CHKSM=16503DC9F9BB66E084FC3D25107D863844122CF1