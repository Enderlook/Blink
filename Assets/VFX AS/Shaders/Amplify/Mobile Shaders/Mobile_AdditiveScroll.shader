// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Mobile/Particles/Additive Scroll"
{
	Properties
	{
		_ColorIntensity("Color Intensity", Range( 0 , 10)) = 1.5
		[Toggle(_DISTORTTEXTURE_ON)] _DistortTexture("Distort Texture?", Float) = 0
		_DistortionAmount("DistortionAmount", Range( -0.1 , 0.1)) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MainSpeed("MainSpeed", Vector) = (0,0,0,0)
		_NoiseSpeed("NoiseSpeed", Vector) = (0,0,0,0)
		_NoiseScale("NoiseScale", Float) = 10
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _DISTORTTEXTURE_ON
		#pragma surface surf Unlit keepalpha noshadow noinstancing noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _ColorIntensity;
		uniform sampler2D _MainTex;
		uniform float2 _MainSpeed;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float _DistortionAmount;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 MainColor58 = ( _ColorIntensity * i.vertexColor );
			float2 UVs14 = i.uv_texcoord;
			float TimeLocal45 = _Time.y;
			float simplePerlin2D41 = snoise( ( UVs14 + ( TimeLocal45 * _NoiseSpeed ) )*_NoiseScale );
			simplePerlin2D41 = simplePerlin2D41*0.5 + 0.5;
			float2 temp_cast_0 = (simplePerlin2D41).xx;
			float2 lerpResult43 = lerp( UVs14 , temp_cast_0 , _DistortionAmount);
			#ifdef _DISTORTTEXTURE_ON
				float2 staticSwitch82 = ( ( _MainSpeed * TimeLocal45 ) + lerpResult43 );
			#else
				float2 staticSwitch82 = UVs14;
			#endif
			float2 UVScroll52 = staticSwitch82;
			float4 tex2DNode2 = tex2D( _MainTex, UVScroll52 );
			float MainTexture16 = tex2DNode2.a;
			float colorAlpha66 = i.vertexColor.a;
			float4 ColorOutput22 = ( MainColor58 * MainTexture16 * colorAlpha66 );
			o.Emission = ColorOutput22.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Mobile/Particles/Additive"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;4136.178;206.5005;4.343039;True;True
Node;AmplifyShaderEditor.CommentaryNode;46;-2468.757,1283.519;Inherit;False;582.2754;308;Comment;2;34;45;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-2492.467,-816.6658;Inherit;False;1086.265;383.3374;Comment;2;14;85;UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;-2418.757,1338.476;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2129.48,1333.519;Inherit;True;TimeLocal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2488.336,1710.441;Inherit;False;3232.992;973.6491;Comment;17;52;48;49;43;41;51;50;42;44;39;40;35;38;37;47;82;83;UV Scroll;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;85;-2393.895,-737.9368;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1968.994,-741.998;Inherit;True;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2438.336,2106.271;Inherit;True;45;TimeLocal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;37;-2419.588,2337.004;Inherit;True;Property;_NoiseSpeed;NoiseSpeed;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2055.009,2318.82;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-2087.643,2088.434;Inherit;True;14;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1713.609,2435.998;Inherit;False;Property;_NoiseScale;NoiseScale;7;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1738.294,2194.91;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-1360.614,2285.515;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1014.152,1971.9;Inherit;True;45;TimeLocal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1394.659,2521.665;Inherit;False;Property;_DistortionAmount;DistortionAmount;3;0;Create;True;0;0;False;0;0;0;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1349.78,2076.365;Inherit;True;14;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;50;-985.6858,1760.441;Inherit;False;Property;_MainSpeed;MainSpeed;5;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;43;-815.3812,2272.376;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-760.4636,1864.856;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-394.0154,2094.099;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-396.5156,1844.962;Inherit;True;14;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;82;-19.75012,2067.559;Inherit;True;Property;_DistortTexture;Distort Texture?;2;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2499.98,-320.7628;Inherit;False;1173.469;508.6287;Comment;5;1;2;16;55;76;Main Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2506.451,-1582.989;Inherit;False;1400.473;649.998;Comment;5;66;58;79;80;81;Main Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;355.9068,2086.44;Inherit;True;UVScroll;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-2445.791,-1527.087;Inherit;False;Property;_ColorIntensity;Color Intensity;1;0;Create;True;0;0;False;0;1.5;1.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2440.299,-38.02496;Inherit;True;52;UVScroll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;81;-2421.988,-1401.366;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2449.98,-267.9283;Inherit;True;Property;_MainTex;MainTex;4;0;Create;True;0;0;False;0;8734a3a6cfedbad4a9b061abbcf7830e;b03bedf7d205c284eafbe91cb1cc9757;False;white;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-2102.635,-1426.213;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1897.863,-270.7628;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;25;-2500.17,338.0151;Inherit;False;1023.138;820.0339;Comment;5;22;6;78;18;60;Color & Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1563.511,-32.75601;Inherit;True;MainTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-2112.726,-1174.495;Inherit;True;colorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1752.141,-1429.175;Inherit;True;MainColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-2415.298,423.0203;Inherit;True;58;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2405.455,951.3154;Inherit;True;66;colorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2403.194,688.1063;Inherit;True;16;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2008.026,672.1714;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1730.561,668.9323;Inherit;True;ColorOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;30;-522.4251,333.5844;Inherit;False;716.2175;724.6855;Comment;2;12;61;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-1560.839,-270.191;Inherit;True;ColorTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-451.7091,513.49;Inherit;True;22;ColorOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;-69.20758,469.9201;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Mobile/Particles/Additive Scroll;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;True;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Mobile/Particles/Additive;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;34;0
WireConnection;14;0;85;0
WireConnection;35;0;47;0
WireConnection;35;1;37;0
WireConnection;39;0;38;0
WireConnection;39;1;35;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;43;0;44;0
WireConnection;43;1;41;0
WireConnection;43;2;42;0
WireConnection;49;0;50;0
WireConnection;49;1;51;0
WireConnection;48;0;49;0
WireConnection;48;1;43;0
WireConnection;82;1;83;0
WireConnection;82;0;48;0
WireConnection;52;0;82;0
WireConnection;80;0;79;0
WireConnection;80;1;81;0
WireConnection;2;0;1;0
WireConnection;2;1;55;0
WireConnection;16;0;2;4
WireConnection;66;0;81;4
WireConnection;58;0;80;0
WireConnection;6;0;60;0
WireConnection;6;1;18;0
WireConnection;6;2;78;0
WireConnection;22;0;6;0
WireConnection;76;0;2;0
WireConnection;12;2;61;0
ASEEND*/
//CHKSM=9D34B8E4BE289208176CC9C0B0457B5FD20E2EF8