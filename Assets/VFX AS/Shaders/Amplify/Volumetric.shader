// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Volumetric"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Offset("Offset", Range( 0 , 1)) = 0.150702
		_Constrast("Constrast", Range( 0 , 1)) = 0
		_Brightness("Brightness", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
		};

		struct SurfaceOutputStandardCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			half3 Transmission;
		};

		uniform float _Constrast;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Offset;
		uniform float _Brightness;

		inline half4 LightingStandardCustom(SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
		{
			half3 transmission = max(0 , -dot(s.Normal, gi.light.dir)) * gi.light.color * s.Transmission;
			half4 d = half4(s.Albedo * transmission , 0);

			SurfaceOutputStandard r;
			r.Albedo = s.Albedo;
			r.Normal = s.Normal;
			r.Emission = s.Emission;
			r.Metallic = s.Metallic;
			r.Smoothness = s.Smoothness;
			r.Occlusion = s.Occlusion;
			r.Alpha = s.Alpha;
			return LightingStandard (r, viewDir, gi) + d;
		}

		inline void LightingStandardCustom_GI(SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
		{
			#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
				gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
			#else
				UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
				gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
			#endif
		}

		void surf( Input i , inout SurfaceOutputStandardCustom o )
		{
			o.Normal = float3(0,0,1);
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 UVs3 = uv0_MainTex;
			float MainTexture5 = tex2D( _MainTex, UVs3 ).a;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 LightDirection10 = mul( ase_worldlightDir, ase_worldToTangent );
			float Offset28 = _Offset;
			float lerpResult26 = lerp( MainTexture5 , ( 1.0 - ( ( MainTexture5 - tex2D( _MainTex, ( float3( UVs3 ,  0.0 ) + ( LightDirection10 * Offset28 ) ).xy ).a ) + 0.5 ) ) , 0.5);
			float Sample_0122 = saturate( lerpResult26 );
			float temp_output_46_0 = ( Offset28 * 0.5 );
			float lerpResult43 = lerp( MainTexture5 , ( 1.0 - ( ( MainTexture5 - tex2D( _MainTex, ( float3( UVs3 ,  0.0 ) + ( LightDirection10 * temp_output_46_0 ) ).xy ).a ) + 0.5 ) ) , 0.5);
			float Sample_0245 = saturate( lerpResult43 );
			float lerpResult103 = lerp( Sample_0122 , Sample_0245 , 0.5);
			float temp_output_52_0 = ( temp_output_46_0 * 0.5 );
			float lerpResult62 = lerp( MainTexture5 , ( 1.0 - ( ( MainTexture5 - tex2D( _MainTex, ( float3( UVs3 ,  0.0 ) + ( LightDirection10 * temp_output_52_0 ) ).xy ).a ) + 0.5 ) ) , 0.5);
			float Sample_0364 = saturate( lerpResult62 );
			float lerpResult104 = lerp( lerpResult103 , Sample_0364 , 0.5);
			float temp_output_68_0 = ( temp_output_52_0 * 0.5 );
			float lerpResult78 = lerp( MainTexture5 , ( 1.0 - ( ( MainTexture5 - tex2D( _MainTex, ( float3( UVs3 ,  0.0 ) + ( LightDirection10 * temp_output_68_0 ) ).xy ).a ) + 0.5 ) ) , 0.5);
			float Sample_0480 = saturate( lerpResult78 );
			float lerpResult105 = lerp( lerpResult104 , Sample_0480 , 0.5);
			float lerpResult94 = lerp( MainTexture5 , ( 1.0 - ( ( MainTexture5 - tex2D( _MainTex, ( float3( UVs3 ,  0.0 ) + ( LightDirection10 * ( temp_output_68_0 * 0.5 ) ) ).xy ).a ) + 0.5 ) ) , 0.5);
			float Sample_0596 = saturate( lerpResult94 );
			float lerpResult106 = lerp( lerpResult105 , Sample_0596 , 0.5);
			float AllSamples48 = lerpResult106;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 Combined116 = saturate( ( float4( ( ( ( 1.0 - ( _Constrast + AllSamples48 ) ) * _Brightness ) + ( ase_lightColor.rgb * ( ase_lightColor.a * 0.1 ) ) ) , 0.0 ) * i.vertexColor ) );
			o.Albedo = Combined116.rgb;
			float3 temp_cast_12 = (0.1).xxx;
			o.Transmission = temp_cast_12;
			float Alpha120 = ( i.vertexColor.a * MainTexture5 );
			o.Alpha = Alpha120;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustom alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

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
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandardCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
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
0;0;1440;879;5682.083;1609.929;5.045335;True;True
Node;AmplifyShaderEditor.CommentaryNode;11;-2941.642,554.7106;Inherit;False;911.6316;370.3594;Comment;4;7;9;8;10;Light Direction;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-2922.3,1029.637;Inherit;False;641.1121;308.0699;Comment;2;14;28;Offset;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2872.3,1079.637;Inherit;True;Property;_Offset;Offset;1;0;Create;True;0;0;False;0;0.150702;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;6;-2946.822,-91.75574;Inherit;False;1492.836;526.3131;Comment;5;2;3;4;1;5;Main Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;9;-2883.132,815.0699;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;7;-2891.642,604.7106;Inherit;True;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-2524.188,1079.707;Inherit;True;Offset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2896.822,-29.24222;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;20e3872ebc20dc443a96e04a25a5714b;32b8070f4ae478b41bd9d0f8091ba29d;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2549.264,651.0898;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3x3;0,0,0,1,1,1,1,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;31;-3490.115,2263.657;Inherit;False;3603.184;596.1945;Comment;15;45;44;43;42;41;40;39;38;37;36;35;34;32;46;97;Sample 02;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-3408.831,2590.671;Inherit;True;28;Offset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;27;-3901.293,1488.5;Inherit;False;3317.843;582.3879;Comment;14;12;16;13;17;15;20;18;19;21;24;25;22;26;29;Sample 01;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-2619.403,135.5574;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2273.01,646.6575;Inherit;True;LightDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;-2331.063,130.9923;Inherit;True;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-3109.49,2596.457;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;12;-3830.434,1550.318;Inherit;True;10;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-3820.395,1812.502;Inherit;True;28;Offset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-3119.257,2338.476;Inherit;True;10;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;49;-2962.662,3035.311;Inherit;False;3365.023;590.7819;Comment;14;51;64;63;62;61;60;59;58;57;56;55;54;53;52;Sample 03;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-2811.809,2318.26;Inherit;True;3;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-2816.24,2573.832;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-2820.197,3368.11;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-2072.556,-28.5209;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2823.964,3116.129;Inherit;True;10;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-3430.089,1538.5;Inherit;True;3;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;65;-2664.434,3791.013;Inherit;False;3359.611;596.1945;Comment;14;67;80;79;78;77;76;75;74;73;72;71;70;69;68;Sample 04;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-3434.52,1794.071;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;36;-2449.244,2337.896;Inherit;True;Property;_MainTex;MainTex;0;0;Fetch;True;0;0;False;0;20e3872ebc20dc443a96e04a25a5714b;8734a3a6cfedbad4a9b061abbcf7830e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-1696.986,-41.75573;Inherit;True;MainTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2527.381,4123.812;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-2522.516,3089.914;Inherit;True;3;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-2512.383,3852.832;Inherit;True;10;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;81;-2287.89,4556.235;Inherit;False;3332.06;596.1945;Comment;14;83;96;95;94;93;92;91;90;89;88;87;86;85;84;Sample 05;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-3067.525,1558.136;Inherit;True;Property;_MainTex;MainTex;0;0;Fetch;True;0;0;False;0;20e3872ebc20dc443a96e04a25a5714b;8734a3a6cfedbad4a9b061abbcf7830e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-3057.551,1772.312;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2439.271,2552.073;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-2526.947,3345.485;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2229.7,3845.617;Inherit;True;3;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;39;-2095.302,2564.968;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-2713.582,1785.207;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;55;-2159.95,3109.55;Inherit;True;Property;_MainTex;MainTex;0;0;Fetch;True;0;0;False;0;20e3872ebc20dc443a96e04a25a5714b;8734a3a6cfedbad4a9b061abbcf7830e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;-2178.388,4889.035;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2163.39,4623.466;Inherit;True;10;LightDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-2052.26,2343.45;Inherit;True;5;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;-2149.976,3323.726;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-2670.541,1563.691;Inherit;True;5;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2234.131,4101.187;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-2290.082,1699.196;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;72;-1857.16,4079.427;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-1867.134,3865.253;Inherit;True;Property;_MainTex;MainTex;0;0;Fetch;True;0;0;False;0;20e3872ebc20dc443a96e04a25a5714b;8734a3a6cfedbad4a9b061abbcf7830e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1885.138,4866.41;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-1671.8,2478.957;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-1806.006,3336.621;Inherit;True;Property;_TextureSample3;Texture Sample 3;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;86;-1880.707,4610.839;Inherit;True;3;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-1762.964,3115.104;Inherit;True;5;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-1366.105,2479.052;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-1470.15,3870.807;Inherit;True;5;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-1513.192,4092.323;Inherit;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1984.385,1699.292;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;87;-1518.142,4630.475;Inherit;True;Property;_MainTex;MainTex;0;0;Fetch;True;0;0;False;0;20e3872ebc20dc443a96e04a25a5714b;8734a3a6cfedbad4a9b061abbcf7830e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-1508.168,4844.65;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;59;-1382.504,3250.61;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;60;-1076.811,3250.706;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;42;-1022.795,2478.166;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;75;-1089.69,4006.313;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-1641.074,1698.405;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;-1164.2,4857.546;Inherit;True;Property;_TextureSample5;Texture Sample 5;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;90;-1121.158,4636.028;Inherit;True;5;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;43;-776.8813,2347.602;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;91;-740.6985,4771.535;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-783.9968,4006.409;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;26;-1395.159,1567.841;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;61;-733.5007,3249.819;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;25;-1081.231,1696.094;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-435.0044,4771.631;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;44;-462.9541,2475.854;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;77;-440.6859,4005.521;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;62;-487.5875,3119.255;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;-194.7725,3874.958;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;93;-91.69376,4770.744;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-208.172,2470.297;Inherit;True;Sample_02;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;107;920.8291,2360.171;Inherit;False;1627.695;1170.061;Comment;10;48;98;99;100;101;102;103;104;105;106;Lerp Samples;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-826.4498,1690.537;Inherit;True;Sample_01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;63;-173.6597,3247.508;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;98;970.8291,2410.171;Inherit;True;22;Sample_01;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;154.2198,4640.18;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;64;81.12225,3241.951;Inherit;True;Sample_03;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;79;119.1553,4003.21;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;972.095,2625.028;Inherit;True;45;Sample_02;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;100;980.9562,2846.552;Inherit;True;64;Sample_03;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;95;468.1476,4768.433;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;373.9373,3997.653;Inherit;True;Sample_04;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;103;1294.836,2478.169;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;1521.163,2829;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;722.9296,4762.875;Inherit;True;Sample_05;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;101;980.9565,3071.62;Inherit;True;80;Sample_04;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;1746.001,3055.851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;993.362,3300.232;Inherit;True;96;Sample_05;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;106;1973.461,3276.471;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;2305.524,3184.36;Inherit;True;AllSamples;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;131;-3008.152,-2517.217;Inherit;False;2575.411;1089.859;Comment;15;125;126;128;127;130;111;109;110;114;112;113;124;123;115;116;Final Tweaks;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-2924.601,-2210.632;Inherit;True;48;AllSamples;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-2958.152,-2467.217;Inherit;True;Property;_Constrast;Constrast;2;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;110;-2555.935,-2339.274;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;125;-2892.696,-1887.071;Inherit;True;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;127;-2818.945,-1685.358;Inherit;True;Constant;_LightInfluence;Light Influence;9;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2552.945,-1773.358;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;112;-2245.385,-2340.301;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-2244.342,-2122.624;Inherit;True;Property;_Brightness;Brightness;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-1989.647,-2230.799;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-2267.333,-1862.549;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-1559.313,-1889.802;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;124;-1569.447,-1657.304;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;121;-2980.461,-777.1056;Inherit;False;924.4647;536.1601;Comment;4;118;117;119;120;Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;117;-2930.461,-727.1056;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;119;-2915.569,-470.9454;Inherit;True;5;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-1233.62,-1767.92;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-2596.857,-557.3248;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;115;-922.7411,-1767.968;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-675.741,-1772.968;Inherit;True;Combined;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-2298.996,-560.304;Inherit;True;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;23.80096,-82.5217;Inherit;False;553.7642;739.5713;Comment;4;0;132;122;23;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;73.80093,-32.52169;Inherit;True;116;Combined;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;72.81366,426.1321;Inherit;True;120;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;83.59241,184.6077;Inherit;True;Constant;_Float0;Float 0;9;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;324.8527,-27.65319;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AvalonStudios/Particles/Volumetric;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;14;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;2;2;1;0
WireConnection;10;0;8;0
WireConnection;3;0;2;0
WireConnection;46;0;97;0
WireConnection;34;0;32;0
WireConnection;34;1;46;0
WireConnection;52;0;46;0
WireConnection;4;0;1;0
WireConnection;4;1;3;0
WireConnection;13;0;12;0
WireConnection;13;1;29;0
WireConnection;5;0;4;4
WireConnection;68;0;52;0
WireConnection;15;0;16;0
WireConnection;15;1;13;0
WireConnection;37;0;35;0
WireConnection;37;1;34;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;39;0;36;0
WireConnection;39;1;37;0
WireConnection;18;0;17;0
WireConnection;18;1;15;0
WireConnection;84;0;68;0
WireConnection;56;0;54;0
WireConnection;56;1;53;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;19;0;20;0
WireConnection;19;1;18;4
WireConnection;72;0;70;0
WireConnection;72;1;69;0
WireConnection;85;0;83;0
WireConnection;85;1;84;0
WireConnection;40;0;38;0
WireConnection;40;1;39;4
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;41;0;40;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;21;0;19;0
WireConnection;88;0;86;0
WireConnection;88;1;85;0
WireConnection;59;0;58;0
WireConnection;59;1;57;4
WireConnection;60;0;59;0
WireConnection;42;0;41;0
WireConnection;75;0;74;0
WireConnection;75;1;73;4
WireConnection;24;0;21;0
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;43;0;38;0
WireConnection;43;1;42;0
WireConnection;91;0;90;0
WireConnection;91;1;89;4
WireConnection;76;0;75;0
WireConnection;26;0;20;0
WireConnection;26;1;24;0
WireConnection;61;0;60;0
WireConnection;25;0;26;0
WireConnection;92;0;91;0
WireConnection;44;0;43;0
WireConnection;77;0;76;0
WireConnection;62;0;58;0
WireConnection;62;1;61;0
WireConnection;78;0;74;0
WireConnection;78;1;77;0
WireConnection;93;0;92;0
WireConnection;45;0;44;0
WireConnection;22;0;25;0
WireConnection;63;0;62;0
WireConnection;94;0;90;0
WireConnection;94;1;93;0
WireConnection;64;0;63;0
WireConnection;79;0;78;0
WireConnection;95;0;94;0
WireConnection;80;0;79;0
WireConnection;103;0;98;0
WireConnection;103;1;99;0
WireConnection;104;0;103;0
WireConnection;104;1;100;0
WireConnection;96;0;95;0
WireConnection;105;0;104;0
WireConnection;105;1;101;0
WireConnection;106;0;105;0
WireConnection;106;1;102;0
WireConnection;48;0;106;0
WireConnection;110;0;109;0
WireConnection;110;1;111;0
WireConnection;126;0;125;2
WireConnection;126;1;127;0
WireConnection;112;0;110;0
WireConnection;113;0;112;0
WireConnection;113;1;114;0
WireConnection;128;0;125;1
WireConnection;128;1;126;0
WireConnection;130;0;113;0
WireConnection;130;1;128;0
WireConnection;123;0;130;0
WireConnection;123;1;124;0
WireConnection;118;0;117;4
WireConnection;118;1;119;0
WireConnection;115;0;123;0
WireConnection;116;0;115;0
WireConnection;120;0;118;0
WireConnection;0;0;23;0
WireConnection;0;6;132;0
WireConnection;0;9;122;0
ASEEND*/
//CHKSM=9B4CFBCC0C9041FFEA39B1E14A058C05ACEAE359