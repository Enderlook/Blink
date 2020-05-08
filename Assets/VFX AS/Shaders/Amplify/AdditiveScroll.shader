// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Additive Scroll"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (1,1,1,0)
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
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow nofog 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float2 _MainSpeed;
		uniform float4 _MainTex_ST;
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
			float4 MainColor58 = _Color;
			float TimeLocal45 = _Time.y;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 UVs14 = uv0_MainTex;
			float simplePerlin2D41 = snoise( ( UVs14 + ( TimeLocal45 * _NoiseSpeed ) )*_NoiseScale );
			simplePerlin2D41 = simplePerlin2D41*0.5 + 0.5;
			float2 temp_cast_0 = (simplePerlin2D41).xx;
			float2 lerpResult43 = lerp( UVs14 , temp_cast_0 , _DistortionAmount);
			float2 UVScroll52 = ( ( _MainSpeed * TimeLocal45 ) + lerpResult43 );
			float4 tex2DNode2 = tex2D( _MainTex, UVScroll52 );
			float MainTexture16 = tex2DNode2.a;
			float4 temp_output_6_0 = ( ( MainColor58 * MainTexture16 ) * i.vertexColor * i.vertexColor.a );
			float4 ColorOutput22 = temp_output_6_0;
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
0;0;1440;879;4034.732;330.7463;3.733823;True;True
Node;AmplifyShaderEditor.CommentaryNode;46;-2463.517,2052.73;Inherit;False;582.2754;308;Comment;2;34;45;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;17;-2499.98,-320.7628;Inherit;False;1173.469;508.6287;Comment;5;1;2;16;55;76;Main Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;54;-2492.467,-816.6658;Inherit;False;1086.265;383.3374;Comment;3;14;13;69;UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;-2413.517,2107.686;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2449.98,-267.9283;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;False;0;8734a3a6cfedbad4a9b061abbcf7830e;8734a3a6cfedbad4a9b061abbcf7830e;False;white;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-2128.202,-754.5639;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2124.241,2102.729;Inherit;True;TimeLocal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-2485.673,2486.457;Inherit;False;2705.189;930.5632;Comment;15;41;39;38;35;44;47;48;43;50;49;51;42;40;37;52;UV Scroll;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1737.991,-761.2846;Inherit;True;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;37;-2416.925,3113.02;Inherit;True;Property;_NoiseSpeed;NoiseSpeed;5;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;47;-2435.673,2882.287;Inherit;True;45;TimeLocal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2052.346,3094.836;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-2084.98,2864.45;Inherit;True;14;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1710.946,3212.014;Inherit;False;Property;_NoiseScale;NoiseScale;6;0;Create;True;0;0;False;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1735.631,2970.926;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1347.117,2852.382;Inherit;True;14;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1391.996,3297.681;Inherit;False;Property;_DistortionAmount;DistortionAmount;2;0;Create;True;0;0;False;0;0;0;-0.1;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;50;-983.0225,2536.457;Inherit;False;Property;_MainSpeed;MainSpeed;4;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-1357.951,3061.531;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1011.489,2747.916;Inherit;True;45;TimeLocal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;-812.7179,3048.393;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-757.8003,2640.872;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-391.3521,2870.115;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-23.48357,2864.874;Inherit;True;UVScroll;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;59;-2506.451,-1582.989;Inherit;False;911.8271;541.9106;Comment;3;58;3;66;Main Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-2440.299,-38.02496;Inherit;True;52;UVScroll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-2456.451,-1532.565;Inherit;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1897.863,-270.7628;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-2075.155,-1532.989;Inherit;True;MainColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;25;-2500.17,338.0151;Inherit;False;1544.979;695.6285;Comment;8;5;4;6;18;10;22;60;21;Color & Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1563.511,-32.75601;Inherit;True;MainTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2451.918,655.0535;Inherit;True;16;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-2453.092,420.3885;Inherit;True;58;MainColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;5;-2178.649,733.1277;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2146.841,502.7109;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1865.76,615.4187;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;27;-2492.906,1144.315;Inherit;False;1053.205;774.0382;Comment;5;15;20;26;19;28;Alpha Clip Threshold;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-522.4251,333.5844;Inherit;False;716.2175;724.6855;Comment;3;24;12;61;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1542.417,447.5314;Inherit;True;ColorOutput;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;70;-2472.65,3542.584;Inherit;False;2003.298;813.5332;Comment;6;77;62;74;75;67;56;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;13;-2449.65,-766.7188;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;10;-1549.649,714.9831;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-1235.809,709.6516;Inherit;True;AlphaSplit;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-451.7091,513.49;Inherit;True;22;ColorOutput;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-451.5701,760.4973;Inherit;True;21;AlphaSplit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-2073.389,-1298.842;Inherit;True;MainAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2420.284,3782.9;Inherit;True;66;MainAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1367.719,3908.799;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-1560.839,-270.191;Inherit;True;ColorTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2431.588,1645.852;Inherit;True;Constant;_AlphaThreshold;Alpha Threshold;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClipNode;15;-2088.358,1397.671;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;77;-1749.639,4066.413;Inherit;True;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;26;-2442.56,1415.076;Inherit;True;21;AlphaSplit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2442.906,1194.315;Inherit;True;16;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2422.65,4030.801;Inherit;True;16;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2043.234,3932.557;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-1743.556,1391.567;Inherit;True;AlphaClipThreshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;67;-1742.954,3719.419;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;-69.20758,469.9201;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Particles/Additive Scroll;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Mobile/Particles/Additive;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;69;2;1;0
WireConnection;45;0;34;0
WireConnection;14;0;69;0
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
WireConnection;52;0;48;0
WireConnection;2;0;1;0
WireConnection;2;1;55;0
WireConnection;58;0;3;0
WireConnection;16;0;2;4
WireConnection;4;0;60;0
WireConnection;4;1;18;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;6;2;5;4
WireConnection;22;0;6;0
WireConnection;10;0;6;0
WireConnection;21;0;10;3
WireConnection;66;0;3;4
WireConnection;74;0;67;4
WireConnection;74;1;75;0
WireConnection;76;0;2;0
WireConnection;15;0;19;0
WireConnection;15;1;26;0
WireConnection;15;2;20;0
WireConnection;77;0;75;0
WireConnection;75;0;56;0
WireConnection;75;1;62;0
WireConnection;28;0;15;0
WireConnection;12;2;61;0
ASEEND*/
//CHKSM=F891659E147D79DE248BFCDB279E41123D25B06D