// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Mobile/Particles/Twirl Alpha Blend"
{
	Properties
	{
		_IntensityColor("Intensity Color", Float) = 1.2
		_TwirlAnimationSpeed("Twirl Animation Speed", Range( -2 , 2)) = 0.5
		_TwirlStrenght("Twirl Strenght", Float) = 10
		_VoronoiScale("Voronoi Scale", Float) = 2.5
		_VoronoiAngle("Voronoi Angle", Float) = 0
		_Mask("Mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _IntensityColor;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float _TwirlStrenght;
		uniform float _TwirlAnimationSpeed;
		uniform float _VoronoiAngle;
		uniform float _VoronoiScale;


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
			float4 temp_output_39_0 = ( i.vertexColor * _IntensityColor );
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode33 = tex2D( _Mask, uv_Mask );
			float2 center45_g1 = float2( 0.5,0.5 );
			float2 delta6_g1 = ( i.uv_texcoord - center45_g1 );
			float angle10_g1 = ( length( delta6_g1 ) * _TwirlStrenght );
			float x23_g1 = ( ( cos( angle10_g1 ) * delta6_g1.x ) - ( sin( angle10_g1 ) * delta6_g1.y ) );
			float2 break40_g1 = center45_g1;
			float2 temp_cast_0 = (( _TwirlAnimationSpeed * _Time.y )).xx;
			float2 break41_g1 = temp_cast_0;
			float y35_g1 = ( ( sin( angle10_g1 ) * delta6_g1.x ) + ( cos( angle10_g1 ) * delta6_g1.y ) );
			float2 appendResult44_g1 = (float2(( x23_g1 + break40_g1.x + break41_g1.x ) , ( break40_g1.y + break41_g1.y + y35_g1 )));
			float2 unityVoronoy4 = UnityVoronoi(appendResult44_g1,_VoronoiAngle,_VoronoiScale);
			float4 maskEffect7 = ( tex2DNode33 * unityVoronoy4.x * tex2DNode33.a );
			float4 texColor27 = ( temp_output_39_0 * maskEffect7 );
			o.Emission = texColor27.rgb;
			float4 alphaEffect26 = ( temp_output_39_0.a * maskEffect7 );
			o.Alpha = alphaEffect26.r;
		}

		ENDCG
	}
	Fallback "Mobile/Particles/Additive"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;12;1438;867;4467.267;1892.257;4.491674;True;True
Node;AmplifyShaderEditor.CommentaryNode;21;-3153.73,-168.261;Inherit;False;1654.713;665.9552;;9;9;15;2;3;16;1;6;5;4;Twirl & Voronoi Effect;0.764151,0.6106073,0.09011213,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-3119.731,84.28752;Inherit;False;Property;_TwirlAnimationSpeed;Twirl Animation Speed;2;0;Create;True;0;0;False;0;0.5;0.5;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;9;-3050.722,188.5717;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2622.641,-684.0446;Inherit;False;1309.618;457.8099;;4;7;34;32;33;Mask;0.1045301,0.3237718,0.8207547,1;0;0
Node;AmplifyShaderEditor.Vector2Node;2;-2855.658,-118.2609;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;3;-2855.914,31.58401;Inherit;False;Property;_TwirlStrenght;Twirl Strenght;3;0;Create;True;0;0;False;0;10;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2825.731,126.2878;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2483.008,374.0811;Inherit;False;Property;_VoronoiScale;Voronoi Scale;4;0;Create;True;0;0;False;0;2.5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1;-2530.776,-10.41574;Inherit;True;Twirl;-1;;1;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2492.724,234.2606;Inherit;False;Property;_VoronoiAngle;Voronoi Angle;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;32;-2572.641,-634.0446;Inherit;True;Property;_Mask;Mask;6;0;Create;True;0;0;False;0;None;32b8070f4ae478b41bd9d0f8091ba29d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;33;-2252.563,-634.043;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;30;-2579.725,593.5081;Inherit;False;1386.371;678.3904;;9;40;22;23;25;26;27;38;39;24;Color & Alpha;0.8018868,0.1702118,0.1702118,1;0;0
Node;AmplifyShaderEditor.VoronoiNode;4;-2124.491,221.6944;Inherit;True;0;0;1;0;1;False;1;True;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;5;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1856.753,-466.1528;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2535.944,844.803;Inherit;False;Property;_IntensityColor;Intensity Color;1;0;Create;True;0;0;False;0;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;24;-2521.03,649.2004;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1569.176,-469.5945;Inherit;False;maskEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-2291.668,652.9634;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;40;-2028.667,991.9634;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;22;-2006.236,770.194;Inherit;True;7;maskEffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1699.58,941.2275;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1705.08,651.7972;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;37;-510.8813,-50;Inherit;False;773.8813;482;;3;0;29;8;Output;0.3796271,0.8867924,0.1213065,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1455.708,649.2286;Inherit;False;texColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-1442.581,934.2272;Inherit;False;alphaEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;8;-460.8813,178.659;Inherit;False;26;alphaEffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-444.1262,43.61731;Inherit;False;27;texColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Mobile/Particles/Twirl Alpha Blend;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;2;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Mobile/Particles/Additive;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;15;0
WireConnection;16;1;9;0
WireConnection;1;2;2;0
WireConnection;1;3;3;0
WireConnection;1;4;16;0
WireConnection;33;0;32;0
WireConnection;4;0;1;0
WireConnection;4;1;6;0
WireConnection;4;2;5;0
WireConnection;34;0;33;0
WireConnection;34;1;4;0
WireConnection;34;2;33;4
WireConnection;7;0;34;0
WireConnection;39;0;24;0
WireConnection;39;1;38;0
WireConnection;40;0;39;0
WireConnection;25;0;40;3
WireConnection;25;1;22;0
WireConnection;23;0;39;0
WireConnection;23;1;22;0
WireConnection;27;0;23;0
WireConnection;26;0;25;0
WireConnection;0;2;29;0
WireConnection;0;9;8;0
ASEEND*/
//CHKSM=CD09F7E7F79CCE952708DEA61783953BA6B6172B