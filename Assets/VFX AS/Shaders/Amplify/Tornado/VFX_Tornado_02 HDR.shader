// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/VFX HDR/VFX Tornado 02 HDR"
{
	Properties
	{
		_MaskClipOpacity("Mask Clip Opacity", Range( 0 , 1)) = 0
		_NoiseSpeed("Noise Speed", Vector) = (-1,-1,0,0)
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_Emission("Emission", Float) = 3
		_NoiseScale("Noise Scale", Float) = 0
		[HDR]_RimColor("Rim Color", Color) = (0,0,0,0)
		_RimWidth("Rim Width", Range( 0.2 , 20)) = 1.835792
		_RimGlow("Rim Glow", Float) = 0
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		_TwirlSpeed1("Twirl Speed", Vector) = (0.5,0.5,0,0)
		_TwirlCenter1("Twirl Center", Vector) = (0.5,0.5,0,0)
		_TwirlNoiseScale1("Twirl Noise Scale", Float) = 2
		_TwirlAmount1("Twirl Amount", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 viewDir;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _RimWidth;
		uniform float _RimGlow;
		uniform float4 _RimColor;
		uniform float4 _Color;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float _Emission;
		uniform float _Dissolve;
		uniform float2 _TwirlCenter1;
		uniform float _TwirlAmount1;
		uniform float2 _TwirlSpeed1;
		uniform float _TwirlNoiseScale1;
		uniform float _MaskClipOpacity;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 normalizeResult27 = normalize( i.viewDir );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float dotResult28 = dot( normalizeResult27 , ase_vertexNormal );
			float4 rimEffect41 = ( ( pow( ( 1.0 - saturate( dotResult28 ) ) , _RimWidth ) * _RimGlow ) * _RimColor );
			float simplePerlin2D1 = snoise( (i.uv_texcoord*float2( 1,1 ) + ( _Time.y * _NoiseSpeed ))*_NoiseScale );
			simplePerlin2D1 = simplePerlin2D1*0.5 + 0.5;
			float noiseTornadoTex13 = simplePerlin2D1;
			float4 color19 = ( rimEffect41 + ( ( ( _Color * noiseTornadoTex13 ) * i.vertexColor ) * _Emission ) );
			o.Emission = color19.rgb;
			o.Alpha = 1;
			float alpha54 = (0.0 + (_Dissolve - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			float2 center45_g3 = _TwirlCenter1;
			float2 delta6_g3 = ( i.uv_texcoord - center45_g3 );
			float angle10_g3 = ( length( delta6_g3 ) * _TwirlAmount1 );
			float x23_g3 = ( ( cos( angle10_g3 ) * delta6_g3.x ) - ( sin( angle10_g3 ) * delta6_g3.y ) );
			float2 break40_g3 = center45_g3;
			float2 break41_g3 = ( _Time.y * _TwirlSpeed1 );
			float y35_g3 = ( ( sin( angle10_g3 ) * delta6_g3.x ) + ( cos( angle10_g3 ) * delta6_g3.y ) );
			float2 appendResult44_g3 = (float2(( x23_g3 + break40_g3.x + break41_g3.x ) , ( break40_g3.y + break41_g3.y + y35_g3 )));
			float simplePerlin2D66 = snoise( appendResult44_g3*_TwirlNoiseScale1 );
			simplePerlin2D66 = simplePerlin2D66*0.5 + 0.5;
			float twirlNoise67 = simplePerlin2D66;
			float noiseMinus11 = ( 1.0 - simplePerlin2D1 );
			float twirlAndRadial70 = ( twirlNoise67 * noiseMinus11 );
			clip( ( alpha54 - twirlAndRadial70 ) - _MaskClipOpacity );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows nofog 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;4097.039;-1050.85;3.511523;True;True
Node;AmplifyShaderEditor.CommentaryNode;24;-3185.988,-1135.098;Inherit;False;2567.632;692.4358;Comment;13;41;49;48;46;34;47;30;32;29;28;26;27;25;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;35;-3160.736,14.73917;Inherit;False;1865.561;823.4636;;11;8;5;4;2;9;23;3;1;13;10;11;Shape Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;25;-3135.988,-1068.296;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;26;-2898.58,-917.3239;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;27;-2892.189,-1063.896;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;5;-3110.736,497.7335;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-3110.279,677.2028;Inherit;False;Property;_NoiseSpeed;Noise Speed;1;0;Create;True;0;0;False;0;-1,-1;-0.6,-0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-2879.393,578.7567;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-2798.048,64.73917;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;4;-2777.425,280.4279;Inherit;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DotProductOpNode;28;-2598.97,-1063.328;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;-2387.098,-1063.775;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2425.754,511.7421;Inherit;False;Property;_NoiseScale;Noise Scale;4;0;Create;True;0;0;False;0;0;7.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;58;-3143.176,2653.955;Inherit;False;2267.062;624.3647;;12;67;59;66;61;62;63;64;65;68;69;70;71;Twirl Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;3;-2463.424,259.428;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;71;-3100.987,2828.784;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-2140.295,-1085.098;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2174.593,-812.9963;Inherit;False;Property;_RimWidth;Rim Width;6;0;Create;True;0;0;False;0;1.835792;20;0.2;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;1;-2104.346,255.0257;Inherit;True;Simplex2D;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;59;-3093.176,3011.125;Inherit;False;Property;_TwirlSpeed1;Twirl Speed;9;0;Create;True;0;0;False;0;0.5,0.5;0.6,0.6;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;34;-1807.259,-958.5677;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;36;-3121.978,1093.633;Inherit;False;2131.699;819.8467;;10;19;45;42;21;22;18;15;17;14;16;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1742.359,-697.3818;Inherit;False;Property;_RimGlow;Rim Glow;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1816.465,255.8921;Inherit;True;noiseTornadoTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-2874.77,2703.955;Inherit;False;Property;_TwirlCenter1;Twirl Center;10;0;Create;True;0;0;False;0;0.5,0.5;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;61;-2872.77,2846.955;Inherit;False;Property;_TwirlAmount1;Twirl Amount;12;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-2856.176,2941.424;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-1461.044,-886.2409;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;49;-1470.887,-639.9091;Inherit;False;Property;_RimColor;Rim Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;64;-2591.032,2806.219;Inherit;True;Twirl;-1;;3;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;10;-1805.82,581.2665;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-3043.149,1625.839;Inherit;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.3904414,0.5724568,0.7735849,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;16;-3071.978,1143.633;Inherit;True;13;noiseTornadoTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2513.997,3054.2;Inherit;False;Property;_TwirlNoiseScale1;Twirl Noise Scale;11;0;Create;True;0;0;False;0;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-3075.588,2182.975;Inherit;False;989.1138;308;;4;50;51;54;72;Alpha Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2785.951,1211.395;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;17;-2771.068,1430.81;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1161.887,-801.9086;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;66;-2212.855,2938.043;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1538.175,576.111;Inherit;True;noiseMinus;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2430.726,1667.278;Inherit;False;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;3;4.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-3025.588,2232.975;Inherit;True;Property;_Dissolve;Dissolve;8;0;Create;True;0;0;False;0;0;0.148;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-1864.215,2778.925;Inherit;True;twirlNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2464.068,1407.81;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-1874.976,3051.125;Inherit;True;11;noiseMinus;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-874.712,-806.6532;Inherit;True;rimEffect;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2150.985,1370.833;Inherit;False;41;rimEffect;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2156.69,1538.963;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;51;-2642.364,2236.764;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1560.424,2973.137;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-2329.474,2235.129;Inherit;False;alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1256.277,2968.149;Inherit;True;twirlAndRadial;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-1886.65,1460.277;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-644.1671,485.7556;Inherit;True;70;twirlAndRadial;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1417.735,1457.534;Inherit;True;color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-633.7655,213.7499;Inherit;False;54;alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-331.8411,324.3397;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2378.993,2343.462;Inherit;False;Property;_MaskClipOpacity;Mask Clip Opacity;0;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-326.4893,40.52702;Inherit;True;19;color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AvalonStudios/VFX HDR/VFX Tornado 02 HDR;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;True;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;72;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;25;0
WireConnection;9;0;5;0
WireConnection;9;1;8;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;29;0;28;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;2;9;0
WireConnection;30;1;29;0
WireConnection;1;0;3;0
WireConnection;1;1;23;0
WireConnection;34;0;30;0
WireConnection;34;1;32;0
WireConnection;13;0;1;0
WireConnection;62;0;71;0
WireConnection;62;1;59;0
WireConnection;46;0;34;0
WireConnection;46;1;47;0
WireConnection;64;2;63;0
WireConnection;64;3;61;0
WireConnection;64;4;62;0
WireConnection;10;0;1;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;48;0;46;0
WireConnection;48;1;49;0
WireConnection;66;0;64;0
WireConnection;66;1;65;0
WireConnection;11;0;10;0
WireConnection;67;0;66;0
WireConnection;18;0;15;0
WireConnection;18;1;17;0
WireConnection;41;0;48;0
WireConnection;21;0;18;0
WireConnection;21;1;22;0
WireConnection;51;0;50;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;54;0;51;0
WireConnection;70;0;69;0
WireConnection;45;0;42;0
WireConnection;45;1;21;0
WireConnection;19;0;45;0
WireConnection;52;0;56;0
WireConnection;52;1;12;0
WireConnection;0;2;20;0
WireConnection;0;10;52;0
ASEEND*/
//CHKSM=4A44477205E17832E577B3741214EE753AFAA339