// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Mobile/Particles/Additive Scroll Noise"
{
	Properties
	{
		_ColorRamp("Color Ramp", 2D) = "white" {}
		_ColorMultiplier("ColorMultiplier", Range( 0 , 10)) = 0
		_MainTextureUSpeed("Main Texture U Speed", Float) = 0
		_MainTextureVSpeed("Main Texture V Speed", Float) = 0
		_MainTexture("Main Texture", 2D) = "white" {}
		[Toggle(_DISTORTMAINTEXTURE_ON)] _DistortMainTexture("Distort Main Texture?", Float) = 1
		_GradientPower("Gradient Power", Range( 0 , 50)) = 0
		_GradientUSpeed("Gradient U Speed", Float) = -0.2
		_GradientVSpeed("Gradient V Speed", Float) = -0.2
		_Gradient("Gradient", 2D) = "white" {}
		_NoiseAmount("Noise Amount", Range( -1 , 1)) = 0
		_DistortionUSpeed("Distortion U Speed", Float) = 0.2
		_DistortionVSpeed("Distortion V Speed", Float) = 0
		_Distortion("Distortion", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_DoubleSided("DoubleSided", Float) = 1
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
		#pragma shader_feature_local _DISTORTMAINTEXTURE_ON
		#pragma surface surf Unlit keepalpha noshadow noinstancing noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _MainTexture;
		uniform float _MainTextureUSpeed;
		uniform float _MainTextureVSpeed;
		uniform sampler2D _Distortion;
		uniform float _DistortionUSpeed;
		uniform float _DistortionVSpeed;
		uniform float _NoiseAmount;
		uniform float _ColorMultiplier;
		uniform sampler2D _ColorRamp;
		uniform float4 _ColorRamp_ST;
		uniform sampler2D _Gradient;
		uniform float _GradientUSpeed;
		uniform float _GradientVSpeed;
		uniform float _GradientPower;
		uniform float _DoubleSided;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode31 = tex2D( _Mask, uv_Mask );
			float4 MaskRGB78 = tex2DNode31;
			float Time19 = _Time.y;
			float MainUVBySpeed13 = ( Time19 * ( _MainTextureUSpeed * _MainTextureVSpeed ) );
			float2 appendResult17 = (float2(_DistortionUSpeed , _DistortionVSpeed));
			float2 temp_output_26_0 = ( i.uv_texcoord + ( Time19 * appendResult17 ) );
			float2 temp_cast_0 = (tex2D( _Distortion, temp_output_26_0 ).r).xx;
			float2 lerpResult35 = lerp( i.uv_texcoord , temp_cast_0 , _NoiseAmount);
			float2 DistortionUVAdd34 = temp_output_26_0;
			float2 lerpResult48 = lerp( i.uv_texcoord , lerpResult35 , tex2D( _Mask, DistortionUVAdd34 ).r);
			float2 DistortionUV29 = lerpResult48;
			#ifdef _DISTORTMAINTEXTURE_ON
				float2 staticSwitch73 = DistortionUV29;
			#else
				float2 staticSwitch73 = i.uv_texcoord;
			#endif
			float2 DistortionMainUVTex76 = ( MainUVBySpeed13 + staticSwitch73 );
			float4 tex2DNode2 = tex2D( _MainTexture, DistortionMainUVTex76 );
			float4 MainTexRGB79 = tex2DNode2;
			float4 MaskAndMainTex84 = ( MaskRGB78 * MainTexRGB79 );
			float2 uv_ColorRamp = i.uv_texcoord * _ColorRamp_ST.xy + _ColorRamp_ST.zw;
			float4 Color92 = ( _ColorMultiplier * i.vertexColor * tex2D( _ColorRamp, uv_ColorRamp ) );
			float MainTex5 = tex2DNode2.a;
			float2 appendResult41 = (float2(_GradientUSpeed , _GradientVSpeed));
			float Gradient57 = pow( tex2D( _Gradient, ( DistortionUV29 + ( Time19 * appendResult41 ) ) ).r , _GradientPower );
			float clampResult60 = clamp( i.ASEVFace , _DoubleSided , 1.0 );
			float DoubleSided62 = clampResult60;
			float GradientAndMainTex98 = ( MainTex5 * Gradient57 * DoubleSided62 );
			float ColorAlpha117 = i.vertexColor.a;
			float4 Union108 = ( MaskAndMainTex84 * Color92 * 2.0 * GradientAndMainTex98 * ColorAlpha117 );
			o.Emission = Union108.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;-1538.716;-3173.683;1.651544;True;True
Node;AmplifyShaderEditor.CommentaryNode;20;-3237.374,-926.7413;Inherit;False;715.5408;308.6907;Comment;2;19;10;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-3187.374,-871.0507;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;28;-3160.241,2369.8;Inherit;False;5048.433;1345.781;Comment;21;75;71;73;29;37;22;46;44;48;45;26;15;34;16;36;35;27;24;23;17;76;Distortion UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3111.296,3266.433;Inherit;True;Property;_DistortionVSpeed;Distortion V Speed;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-3114.844,2979.065;Inherit;True;Property;_DistortionUSpeed;Distortion U Speed;11;0;Create;True;0;0;False;0;0.2;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-2764.833,-876.7413;Inherit;True;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-2751.789,3158.819;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-2751.908,2824.034;Inherit;True;19;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2411.249,3006.114;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;24;-2424.5,2754.484;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;14;-3176.007,1432.44;Inherit;False;1526.841;735.4474;Comment;6;7;9;11;12;13;21;Main UV By Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2094.34,2917.255;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-1577.851,3376.167;Inherit;True;DistortionUVAdd;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;36;-1558.107,2676.629;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-1597.966,2888.894;Inherit;True;Property;_Distortion;Distortion;13;0;Create;True;0;0;False;0;-1;None;b9aa6ffb67a4be648909380bae5e11f5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-3126.007,1627.565;Inherit;True;Property;_MainTextureUSpeed;Main Texture U Speed;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-3118.609,1909.886;Inherit;True;Property;_MainTextureVSpeed;Main Texture V Speed;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;46;-1273.188,3160.982;Inherit;True;Property;_Mask;Mask;14;0;Fetch;True;0;0;False;0;None;538d0092659f8574fa992a0a6b002ddd;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1596.478,3116.493;Inherit;True;Property;_NoiseAmount;Noise Amount;10;0;Create;True;0;0;False;0;0;0.1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;44;-951.3843,2685.862;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2721.568,1820.328;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-2724.479,1508.758;Inherit;True;19;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;35;-963.0203,2898.273;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;45;-971.0864,3257.276;Inherit;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;48;-537.9517,2877.334;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-2333.121,1693.199;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;56;-3188.073,3956.056;Inherit;False;2840.17;803.5913;Comment;11;55;54;53;50;49;43;42;41;40;38;57;Gradient;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-3132.531,4186.871;Inherit;True;Property;_GradientUSpeed;Gradient U Speed;7;0;Create;True;0;0;False;0;-0.2;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-3138.073,4483.443;Inherit;True;Property;_GradientVSpeed;Gradient V Speed;8;0;Create;True;0;0;False;0;-0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-1942.165,1690.998;Inherit;True;MainUVBySpeed;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-159.7857,2872.224;Inherit;True;DistortionUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;188.9682,2465.79;Inherit;True;13;MainUVBySpeed;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;-2822.073,4360.443;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;73;163.1873,2682.076;Inherit;True;Property;_DistortMainTexture;Distort Main Texture?;5;0;Create;True;0;0;False;0;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2825.691,4115.861;Inherit;True;19;Time;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2454.99,4006.056;Inherit;True;29;DistortionUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2465.691,4272.861;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;566.3167,2582.357;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-2064.966,4161.087;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;897.439,2579.122;Inherit;True;DistortionMainUVTex;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;6;-3242.164,-304.073;Inherit;False;1172.685;640.9219;Comment;5;5;79;2;77;1;Main Tex;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;63;-3189.572,5026.182;Inherit;False;1269.634;780.5464;Comment;5;60;59;58;61;62;Double Sided;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-3217.671,544.6552;Inherit;False;1350.522;632.0695;Comment;4;32;31;30;78;Mask;1,1,1,1;0;0
Node;AmplifyShaderEditor.FaceVariableNode;61;-3139.572,5076.182;Inherit;True;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-3129.558,5548.728;Inherit;True;Constant;_Value;Value;14;1;[HideInInspector];Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-3124.626,5291.067;Inherit;True;Property;_DoubleSided;DoubleSided;15;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-3192.164,-254.073;Inherit;True;Property;_MainTexture;Main Texture;4;0;Create;True;0;0;False;0;None;1ce68a5a27d079f4d889e0e4dcd02a19;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1628.185,4440.696;Inherit;True;Property;_GradientPower;Gradient Power;6;0;Create;True;0;0;False;0;0;1.5;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;30;-3167.671,597.7906;Inherit;True;Property;_Mask;Mask;15;0;Create;True;0;0;False;0;029b4a508a61fa04683a31ee0a6d7d4b;538d0092659f8574fa992a0a6b002ddd;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-3208.135,59.38591;Inherit;True;76;DistortionMainUVTex;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;53;-1650.4,4161.397;Inherit;True;Property;_Gradient;Gradient;9;0;Create;True;0;0;False;0;-1;029b4a508a61fa04683a31ee0a6d7d4b;029b4a508a61fa04683a31ee0a6d7d4b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;55;-1165.471,4319.532;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-2759.249,599.1818;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;60;-2570.631,5279.645;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2800.32,-99.19228;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;93;-3229.93,6626.611;Inherit;False;1738.428;779.2061;Comment;6;92;89;88;91;117;119;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;99;-3236.883,7542.292;Inherit;False;1225.366;793.3545;Comment;5;94;95;96;97;98;Multiplying Gradient, Main & Double Sided;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-2366.294,-236.4496;Inherit;True;MainTexRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-2299.098,601.3738;Inherit;True;MaskRGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2162.939,5278.81;Inherit;True;DoubleSided;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;83;-3199.281,5959.147;Inherit;False;1300.25;530.5649;Comment;4;82;81;80;84;Multiplying Mask & Main Tex;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-2357.042,82.2293;Inherit;True;MainTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-766.733,4316.353;Inherit;True;Gradient;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;91;-3172.93,7150.611;Inherit;True;Property;_ColorRamp;Color Ramp;0;0;Create;True;0;0;False;0;-1;None;6bd3de2ca93249540af2df3016c2c346;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;119;-3152.992,6924.353;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;80;-3149.281,6009.147;Inherit;True;78;MaskRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;95;-3177.883,7841.646;Inherit;True;57;Gradient;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-3165.627,7592.292;Inherit;True;5;MainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-3140.041,6242.154;Inherit;True;79;MainTexRGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-3179.93,6676.611;Inherit;True;Property;_ColorMultiplier;ColorMultiplier;1;0;Create;True;0;0;False;0;0;1.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;96;-3186.883,8105.645;Inherit;True;62;DoubleSided;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;97;-2720.199,7824.171;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-2681.93,6903.611;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-2809.041,6147.154;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-2682.661,7158.372;Inherit;True;ColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;92;-2241.989,6898.363;Inherit;True;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-2299.517,7823.188;Inherit;True;GradientAndMainTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-2456.542,6141.145;Inherit;True;MaskAndMainTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;109;-3233.604,8422.142;Inherit;False;1330.76;1270.866;Comment;7;108;105;103;102;118;100;104;Unit All;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-3132.951,8927.204;Inherit;True;Constant;_Value1;Value1;20;1;[HideInInspector];Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-3159.454,8709.944;Inherit;True;92;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-3182.088,9177;Inherit;True;98;GradientAndMainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;-3172.848,8472.142;Inherit;True;84;MaskAndMainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-3163.694,9416.809;Inherit;True;117;ColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-2482.084,8917.478;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;111;3544.267,3152.251;Inherit;False;638.3994;482;Comment;2;0;110;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;108;-2175.378,8910.421;Inherit;True;Union;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-2294.872,880.6552;Inherit;True;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;3594.267,3241.799;Inherit;True;108;Union;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3919.666,3202.251;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Mobile/Particles/Additive Scroll Noise;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;True;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;16;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;10;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;23;0;22;0
WireConnection;23;1;17;0
WireConnection;26;0;24;0
WireConnection;26;1;23;0
WireConnection;34;0;26;0
WireConnection;27;1;26;0
WireConnection;11;0;7;0
WireConnection;11;1;9;0
WireConnection;35;0;36;0
WireConnection;35;1;27;1
WireConnection;35;2;37;0
WireConnection;45;0;46;0
WireConnection;45;1;34;0
WireConnection;48;0;44;0
WireConnection;48;1;35;0
WireConnection;48;2;45;1
WireConnection;12;0;21;0
WireConnection;12;1;11;0
WireConnection;13;0;12;0
WireConnection;29;0;48;0
WireConnection;41;0;38;0
WireConnection;41;1;40;0
WireConnection;73;1;44;0
WireConnection;73;0;29;0
WireConnection;43;0;42;0
WireConnection;43;1;41;0
WireConnection;71;0;75;0
WireConnection;71;1;73;0
WireConnection;50;0;49;0
WireConnection;50;1;43;0
WireConnection;76;0;71;0
WireConnection;53;1;50;0
WireConnection;55;0;53;1
WireConnection;55;1;54;0
WireConnection;31;0;30;0
WireConnection;60;0;61;0
WireConnection;60;1;58;0
WireConnection;60;2;59;0
WireConnection;2;0;1;0
WireConnection;2;1;77;0
WireConnection;79;0;2;0
WireConnection;78;0;31;0
WireConnection;62;0;60;0
WireConnection;5;0;2;4
WireConnection;57;0;55;0
WireConnection;97;0;94;0
WireConnection;97;1;95;0
WireConnection;97;2;96;0
WireConnection;89;0;88;0
WireConnection;89;1;119;0
WireConnection;89;2;91;0
WireConnection;82;0;80;0
WireConnection;82;1;81;0
WireConnection;117;0;119;4
WireConnection;92;0;89;0
WireConnection;98;0;97;0
WireConnection;84;0;82;0
WireConnection;105;0;100;0
WireConnection;105;1;102;0
WireConnection;105;2;103;0
WireConnection;105;3;104;0
WireConnection;105;4;118;0
WireConnection;108;0;105;0
WireConnection;32;0;31;4
WireConnection;0;2;110;0
ASEEND*/
//CHKSM=9233AB3BC75ADA50C5D3EF5821160C5A50A6A792