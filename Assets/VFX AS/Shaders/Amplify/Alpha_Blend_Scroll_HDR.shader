// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Alpha Blend Scroll HDR"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (0.65,0.65,0.65,1)
		_MainTexture("Main Texture", 2D) = "white" {}
		_MaskTexture("Mask Texture", 2D) = "white" {}
		_MainSpeed("Main Speed", Vector) = (-0.5,0,0,0)
		_NoiseScale("Noise Scale", Vector) = (4,0,0,0)
		_NoiseSpeed("Noise Speed", Float) = 1
		_NoisePower("Noise Power", Float) = 2
		_DistortionAmount("Distortion Amount", Range( -1 , 1)) = 0.05
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
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

		uniform float4 _Color;
		uniform sampler2D _MaskTexture;
		uniform float4 _MaskTexture_ST;
		uniform sampler2D _MainTexture;
		uniform float2 _MainSpeed;
		uniform float _NoiseSpeed;
		uniform float2 _NoiseScale;
		uniform float _NoisePower;
		uniform float _DistortionAmount;
		uniform float _Dissolve;


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
			float2 uv_MaskTexture = i.uv_texcoord * _MaskTexture_ST.xy + _MaskTexture_ST.zw;
			float4 tex2DNode34 = tex2D( _MaskTexture, uv_MaskTexture );
			float simplePerlin2D41 = snoise( ( i.uv_texcoord + ( _Time.y * _NoiseSpeed ) )*_NoiseScale.x );
			simplePerlin2D41 = simplePerlin2D41*0.5 + 0.5;
			float temp_output_48_0 = pow( simplePerlin2D41 , _NoisePower );
			float2 temp_cast_1 = (temp_output_48_0).xx;
			float2 lerpResult50 = lerp( i.uv_texcoord , temp_cast_1 , _DistortionAmount);
			float2 uvScroll10 = ( ( _MainSpeed * _Time.y ) + lerpResult50 );
			float4 mainTex58 = tex2D( _MainTexture, uvScroll10 );
			float4 temp_cast_2 = (( mainTex58.a * temp_output_48_0 )).xxxx;
			float4 lerpResult56 = lerp( mainTex58 , temp_cast_2 , _Dissolve);
			float4 dissolveTex59 = lerpResult56;
			float4 mainTexMask13 = ( tex2DNode34 * dissolveTex59 );
			float4 baseColor19 = ( _Color * i.vertexColor * mainTexMask13 );
			o.Emission = baseColor19.rgb;
			float alphaTextureMask37 = ( tex2DNode34.r * dissolveTex59.a );
			float alphaTex30 = ( _Color.a * i.vertexColor.a * alphaTextureMask37 );
			o.Alpha = alphaTex30;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;3930.813;1612.692;4.985061;True;True
Node;AmplifyShaderEditor.CommentaryNode;9;-2776.982,343.4514;Inherit;False;3040.705;1339.262;UV Scrolling;23;56;54;55;53;10;8;50;6;4;5;52;48;51;49;41;42;47;43;44;40;45;57;59;UV Scroll;0.006026864,1,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2743.148,957.2496;Inherit;False;Property;_NoiseSpeed;Noise Speed;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;-2743.437,813.2514;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2556.147,871.2485;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;43;-2576.589,704.2784;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-2291.772,815.3834;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;42;-2249.015,1131.934;Inherit;False;Property;_NoiseScale;Noise Scale;5;0;Create;True;0;0;False;0;4,0;4,4;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;41;-1981.515,955.4366;Inherit;True;Simplex2D;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1928.691,1183.601;Inherit;False;Property;_NoisePower;Noise Power;7;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;48;-1692.69,957.6005;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;4;-1620.772,671.8858;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;5;-1622.969,505.8653;Inherit;False;Property;_MainSpeed;Main Speed;4;0;Create;True;0;0;False;0;-0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;51;-1697.501,781.8814;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-1673.107,1193.372;Inherit;False;Property;_DistortionAmount;Distortion Amount;8;0;Create;True;0;0;False;0;0.05;0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1348.471,560.1691;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;50;-1366.473,914.0678;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1037.901,763.3822;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-729.941,753.8089;Inherit;False;uvScroll;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2757.228,-411.3851;Inherit;False;1614.452;596.0073;;12;61;60;37;36;35;13;34;33;58;3;11;1;Main Texture;1,0,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2707.228,-361.3851;Inherit;True;Property;_MainTexture;Main Texture;2;0;Create;True;0;0;False;0;4a1125656e409214fbee8fa710b36813;4a1125656e409214fbee8fa710b36813;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;-2685.035,-162.0387;Inherit;False;10;uvScroll;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-2434.985,-361.2483;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-1836.641,-358.7633;Inherit;False;mainTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1354.864,1179.791;Inherit;True;58;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;54;-1081.387,1285.805;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-804.7933,935.9528;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-748.2416,1408.718;Inherit;False;Property;_Dissolve;Dissolve;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;56;-477.1801,1188.883;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-101.3414,1187.489;Inherit;False;dissolveTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;33;-2703.01,-41.14883;Inherit;True;Property;_MaskTexture;Mask Texture;3;0;Create;True;0;0;False;0;538d0092659f8574fa992a0a6b002ddd;538d0092659f8574fa992a0a6b002ddd;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-2135.886,-217.0635;Inherit;False;59;dissolveTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;34;-2419.539,-41.37112;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;61;-1855.561,-110.849;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1788.276,-239.412;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1582.499,-18.3248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-2725.506,1846.784;Inherit;False;1068.944;703.9569;Apply Color to Texture;8;15;17;39;30;19;28;16;2;Color;0,0.2136707,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1524.742,-244.7988;Inherit;False;mainTexMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-1422.851,-24.53949;Inherit;False;alphaTextureMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;17;-2474.371,2194.782;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;15;-2693.506,2069.082;Inherit;True;13;mainTexMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-2504.65,1902.784;Inherit;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;0.65,0.65,0.65,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;39;-2498.376,2374.892;Inherit;False;37;alphaTextureMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2152.714,2286.741;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2168.799,2025.318;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-1911.84,2021.34;Inherit;True;baseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1887.714,2298.741;Inherit;True;alphaTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;1033.264,806.8438;Inherit;True;30;alphaTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;1024.925,595.1744;Inherit;True;19;baseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1354.915,585.7952;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Particles/Alpha Blend Scroll HDR;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;44;0;40;0
WireConnection;44;1;45;0
WireConnection;47;0;43;0
WireConnection;47;1;44;0
WireConnection;41;0;47;0
WireConnection;41;1;42;0
WireConnection;48;0;41;0
WireConnection;48;1;49;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;50;0;51;0
WireConnection;50;1;48;0
WireConnection;50;2;52;0
WireConnection;8;0;6;0
WireConnection;8;1;50;0
WireConnection;10;0;8;0
WireConnection;3;0;1;0
WireConnection;3;1;11;0
WireConnection;58;0;3;0
WireConnection;54;0;53;0
WireConnection;55;0;54;3
WireConnection;55;1;48;0
WireConnection;56;0;53;0
WireConnection;56;1;55;0
WireConnection;56;2;57;0
WireConnection;59;0;56;0
WireConnection;34;0;33;0
WireConnection;61;0;60;0
WireConnection;35;0;34;0
WireConnection;35;1;60;0
WireConnection;36;0;34;1
WireConnection;36;1;61;3
WireConnection;13;0;35;0
WireConnection;37;0;36;0
WireConnection;28;0;2;4
WireConnection;28;1;17;4
WireConnection;28;2;39;0
WireConnection;16;0;2;0
WireConnection;16;1;17;0
WireConnection;16;2;15;0
WireConnection;19;0;16;0
WireConnection;30;0;28;0
WireConnection;0;2;22;0
WireConnection;0;9;31;0
ASEEND*/
//CHKSM=835051BEED87B278AC0D67CAB8A64214F8EF2189