// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Blend Two Sides HDR"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.26
		_MainTex("Main Tex", 2D) = "white" {}
		_MaskTex("Mask Tex", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_SpeedMainTexUVNoiseZW("Speed MainTex U/V + Noise Z/W", Vector) = (0,0,0,0)
		[HDR]_FrontFacesColor("Front Faces Color", Color) = (0.9433962,0.4788501,0.06674972,1)
		[HDR]_BackFacesColor("Back Faces Color", Color) = (0.9528302,0.06741722,0.06741722,1)
		_Emission("Emission", Float) = 2
		[Toggle]_UseFresnel("Use Fresnel?", Float) = 0
		[HDR]_FresnelColor("Fresnel Color", Color) = (1,1,1,1)
		_Fresnel("Fresnel", Float) = 1
		_FresnelEmission("Fresnel Emission", Float) = 2
		[Toggle]_UseCustomData("Use Custom Data?", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
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
		#pragma surface surf Unlit keepalpha noshadow novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float3 viewDir;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv_tex4coord;
		};

		uniform float4 _FrontFacesColor;
		uniform float _Fresnel;
		uniform float4 _FresnelColor;
		uniform float _FresnelEmission;
		uniform float _UseFresnel;
		uniform float4 _BackFacesColor;
		uniform float _Emission;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _SpeedMainTexUVNoiseZW;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;
		uniform sampler2D _Noise;
		uniform float4 _Noise_ST;
		uniform float _UseCustomData;
		uniform float _Cutoff = 0.26;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV22 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode22 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV22, _Fresnel ) );
			float4 lerpResult27 = lerp( _FrontFacesColor , ( ( _FrontFacesColor * ( 1.0 - fresnelNode22 ) ) + ( fresnelNode22 * _FresnelColor * _FresnelEmission ) ) , (( _UseFresnel )?( 1.0 ):( 0.0 )));
			float dotResult30 = dot( ase_worldNormal , i.viewDir );
			float4 lerpResult38 = lerp( lerpResult27 , _BackFacesColor , ( ( 1.0 + ( sign( dotResult30 ) - -1.0 ) ) * ( ( 0.0 - 1.0 ) / ( 1.0 - -1.0 ) ) ));
			float2 appendResult76 = (float2(_SpeedMainTexUVNoiseZW.x , _SpeedMainTexUVNoiseZW.y));
			float4 mainTex53 = tex2D( _MainTex, ( ( ( _MainTex_ST.xy + _MainTex_ST.zw ) * i.uv_texcoord ) + ( _Time.y * appendResult76 ) ) );
			float4 break57 = ( lerpResult38 * _Emission * i.vertexColor * mainTex53 * i.vertexColor.a );
			float3 appendResult58 = (float3(break57.r , break57.g , break57.b));
			float3 color59 = appendResult58;
			o.Emission = color59;
			o.Alpha = 1.0;
			float2 appendResult70 = (float2(i.uv_tex4coord.x , i.uv_tex4coord.y));
			float2 temp_output_72_0 = ( appendResult70 * ( _Noise_ST.xy + _Noise_ST.zw ) );
			float2 appendResult77 = (float2(_SpeedMainTexUVNoiseZW.z , _SpeedMainTexUVNoiseZW.w));
			float2 appendNoiseSpeed84 = appendResult77;
			float4 appendResult68 = (float4(temp_output_72_0 , i.uv_tex4coord.z , i.uv_tex4coord.w));
			float4 break79 = appendResult68;
			float lerpResult78 = lerp( 1.0 , break79.z , (( _UseCustomData )?( 1.0 ):( 0.0 )));
			clip( 0.0 );
			clip( ( ( tex2D( _MaskTex, ( ( _MaskTex_ST.xy + _MaskTex_ST.zw ) * i.uv_texcoord ) ) * tex2D( _Noise, ( temp_output_72_0 + ( ( _Time.y * appendNoiseSpeed84 ) + break79.w ) ) ) * lerpResult78 ).r - 0.0 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1918;1059;1245.951;-1328.575;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;101;-4423.85,-428.3813;Inherit;False;5089.846;2597.142;Comment;42;99;16;80;98;13;78;96;81;64;67;66;2;82;94;95;89;88;86;85;79;68;73;90;3;72;71;70;84;1;77;76;75;61;53;51;50;49;45;48;43;107;109;Tweaks;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;47;-4487.86,2615.382;Inherit;False;3901.331;1865.27;;30;59;58;57;56;55;54;7;11;12;23;10;6;38;37;34;36;35;33;32;31;30;29;28;9;27;22;24;25;26;5;Lerp Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-4197.253,-299.9501;Inherit;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;b109f76eccc05904589ca15eef2cb5a6;b109f76eccc05904589ca15eef2cb5a6;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-4373.85,1863.795;Inherit;True;Property;_Noise;Noise;3;0;Create;True;0;0;False;0;974194587b33cf245b35aaf6fd0590be;974194587b33cf245b35aaf6fd0590be;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector4Node;75;-3669.877,259.7804;Inherit;False;Property;_SpeedMainTexUVNoiseZW;Speed MainTex U/V + Noise Z/W;4;0;Create;True;0;0;False;0;0,0,0,0;0,-6,0,-2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;109;-4039.65,1246.426;Inherit;True;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;71;-4000.333,1865.176;Inherit;True;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.WorldNormalVector;28;-3983.978,3588.952;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;29;-3985.842,3802.725;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureTransformNode;61;-3894.822,-109.6248;Inherit;True;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.RangedFloatNode;11;-4414.904,3252.374;Inherit;False;Property;_Fresnel;Fresnel;10;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-3631.371,-114.2226;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;70;-3674.774,1651.378;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;-3960.488,567.3318;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;77;-3240.899,432.4587;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;30;-3672.305,3691.476;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;73;-3683.065,1871.199;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;22;-4176.907,3087.053;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;48;-3221.373,114.0615;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;76;-3197.208,252.2432;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;5;-3786.245,2665.382;Inherit;False;Property;_FrontFacesColor;Front Faces Color;5;1;[HDR];Create;True;0;0;False;0;0.9433962,0.4788501,0.06674972,1;1,0.6574083,0.4588236,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-3274.093,-337.0847;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SignOpNode;31;-3396.306,3692.476;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-4057.931,3307.52;Inherit;False;Property;_FresnelColor;Fresnel Color;9;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;23;-3745.413,2927.557;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-2916.373,160.0613;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-2968.996,431.7561;Inherit;False;appendNoiseSpeed;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-3494.419,1802.785;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-4437.861,3547.719;Inherit;False;Property;_FresnelEmission;Fresnel Emission;11;0;Create;True;0;0;False;0;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;-2957.195,1462.144;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-3460.62,859.2103;Inherit;True;Property;_MaskTex;Mask Tex;2;0;Create;True;0;0;False;0;6e67b84c3c1b80545bfbf51e17811870;6e67b84c3c1b80545bfbf51e17811870;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-3421.753,2920.037;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;89;-3029.195,1560.144;Inherit;False;84;appendNoiseSpeed;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-3391.431,3274.254;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;33;-3145.911,3960.87;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;68;-2963.996,1769.818;Inherit;True;FLOAT4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-3144.911,4197.868;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-3165.145,3692.476;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-2586.287,44.4753;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;79;-2621.385,1751.45;Inherit;True;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-2874.18,4115.869;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;51;-2313.889,-47.98051;Inherit;True;Property;_TextureSample1;Texture Sample 1;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;64;-3056.607,927.0015;Inherit;True;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-3091.254,3099.977;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2718.195,1508.144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-2921.814,3789.769;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;9;-3077.916,3385.889;Inherit;False;Property;_UseFresnel;Use Fresnel?;8;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2756.005,925.2245;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1951.527,-45.59733;Inherit;False;mainTex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-2329.53,1507.38;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;90;-3994.791,2091.278;Inherit;False;noiseVarTex;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.LerpOp;27;-2544.645,3008.115;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-2619.337,3979.606;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-2623.434,3807.815;Inherit;False;Property;_BackFacesColor;Back Faces Color;6;1;[HDR];Create;True;0;0;False;0;0.9528302,0.06741722,0.06741722,1;0.7,0.905,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;-2172.043,4348.489;Inherit;False;53;mainTex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-2158.304,1232.848;Inherit;False;90;noiseVarTex;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;85;-2091.195,1352.144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-2562.005,812.2242;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ToggleSwitchNode;13;-2130.77,1905.696;Inherit;False;Property;_UseCustomData;Use Custom Data?;12;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;-2218.553,3796.272;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2154.78,4014.395;Inherit;False;Property;_Emission;Emission;7;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;54;-2162.87,4112.534;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;78;-1794.812,1695.458;Inherit;True;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-1822.454,3842.136;Inherit;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;82;-1817.128,1346.7;Inherit;True;Property;_TextureSample2;Texture Sample 2;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;81;-2154.426,785.8073;Inherit;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;57;-1518.29,3897.075;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;-1068.509,1465.286;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;98;-665.1099,1472.536;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;58;-1218.764,3889.089;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1019.039,3884.408;Inherit;True;color;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;99;-290.3235,1634.249;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;710.6003,1361.756;Inherit;False;59;color;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;16;-225.3217,1947.701;Inherit;False;Property;_dirty;dirty;13;1;[HideInInspector];Create;True;0;0;False;0;1;1;0;1;INT;0
Node;AmplifyShaderEditor.ClipNode;80;13.54952,1514.261;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;733.0825,1485.694;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;996.3575,1318.774;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Particles/Blend Two Sides HDR;False;False;False;False;False;True;True;True;True;True;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.26;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;100;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;71;0;3;0
WireConnection;61;0;1;0
WireConnection;45;0;61;0
WireConnection;45;1;61;1
WireConnection;70;0;109;1
WireConnection;70;1;109;2
WireConnection;77;0;75;3
WireConnection;77;1;75;4
WireConnection;30;0;28;0
WireConnection;30;1;29;0
WireConnection;73;0;71;0
WireConnection;73;1;71;1
WireConnection;22;3;11;0
WireConnection;76;0;75;1
WireConnection;76;1;75;2
WireConnection;43;0;45;0
WireConnection;43;1;107;0
WireConnection;31;0;30;0
WireConnection;23;1;22;0
WireConnection;49;0;48;0
WireConnection;49;1;76;0
WireConnection;84;0;77;0
WireConnection;72;0;70;0
WireConnection;72;1;73;0
WireConnection;24;0;5;0
WireConnection;24;1;23;0
WireConnection;25;0;22;0
WireConnection;25;1;10;0
WireConnection;25;2;12;0
WireConnection;68;0;72;0
WireConnection;68;2;109;3
WireConnection;68;3;109;4
WireConnection;32;0;31;0
WireConnection;50;0;43;0
WireConnection;50;1;49;0
WireConnection;79;0;68;0
WireConnection;34;0;33;0
WireConnection;34;1;35;0
WireConnection;51;0;1;0
WireConnection;51;1;50;0
WireConnection;64;0;2;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;88;0;86;0
WireConnection;88;1;89;0
WireConnection;36;1;32;0
WireConnection;67;0;64;0
WireConnection;67;1;64;1
WireConnection;53;0;51;0
WireConnection;95;0;88;0
WireConnection;95;1;79;3
WireConnection;90;0;3;0
WireConnection;27;0;5;0
WireConnection;27;1;26;0
WireConnection;27;2;9;0
WireConnection;37;0;36;0
WireConnection;37;1;34;0
WireConnection;85;0;72;0
WireConnection;85;1;95;0
WireConnection;66;0;67;0
WireConnection;66;1;107;0
WireConnection;38;0;27;0
WireConnection;38;1;6;0
WireConnection;38;2;37;0
WireConnection;78;1;79;2
WireConnection;78;2;13;0
WireConnection;55;0;38;0
WireConnection;55;1;7;0
WireConnection;55;2;54;0
WireConnection;55;3;56;0
WireConnection;55;4;54;4
WireConnection;82;0;94;0
WireConnection;82;1;85;0
WireConnection;81;0;2;0
WireConnection;81;1;66;0
WireConnection;57;0;55;0
WireConnection;96;0;81;0
WireConnection;96;1;82;0
WireConnection;96;2;78;0
WireConnection;98;0;96;0
WireConnection;58;0;57;0
WireConnection;58;1;57;1
WireConnection;58;2;57;2
WireConnection;59;0;58;0
WireConnection;99;0;98;0
WireConnection;80;0;99;0
WireConnection;0;2;60;0
WireConnection;0;9;105;0
WireConnection;0;10;80;0
ASEEND*/
//CHKSM=715215D9DB21DE50F4AF5B2A75C2276F8C2677C1