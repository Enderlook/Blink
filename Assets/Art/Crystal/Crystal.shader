// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Crystal"
{
	Properties
	{
		_Primary("Primary", Color) = (0,0,0,0)
		_Opacity("Opacity", Range( 0 , 1)) = 0.7
		_Secondary("Secondary", Color) = (0,0,0,0)
		_Scale("Scale", Range( 0 , 100)) = 1
		_SecondaryPower("Secondary Power", Float) = 1
		_PrimaryPower("Primary Power", Float) = 3
		_TextureSpeed("Texture Speed", Range( 0 , 100)) = 1
		_RotationSpeed("Rotation Speed", Range( 0 , 100)) = 1
		_OpacityFactor("Opacity Factor", Float) = 15
		_CracksScale("Cracks Scale", Range( 0 , 100)) = 3
		_CracksMaskScale("Cracks Mask Scale", Range( 0 , 100)) = 5
		_Health("Health", Range( 0 , 1)) = 0.5
		_CrackMaskPower("Crack Mask Power", Range( 0 , 50)) = 4
		_HealthScalingPower("Health Scaling Power", Range( 0 , 10)) = 2.5
		_CrackPower("Crack Power", Range( 0 , 25)) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _Scale;
		uniform float _TextureSpeed;
		uniform float _RotationSpeed;
		uniform float _CracksScale;
		uniform float _CrackPower;
		uniform float _CracksMaskScale;
		uniform float _Health;
		uniform float _HealthScalingPower;
		uniform float _CrackMaskPower;
		uniform float4 _Primary;
		uniform float _PrimaryPower;
		uniform float4 _Secondary;
		uniform float _SecondaryPower;
		uniform float _OpacityFactor;
		uniform float _Opacity;


		float2 voronoihash9( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi9( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash9( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F2 - F1;
		}


		float2 voronoihash32( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi32( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -3; j <= 3; j++ )
			{
				for ( int i = -3; i <= 3; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash32( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F2 - F1;
		}


		float2 voronoihash39( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi39( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash39( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F2 - F1;
		}


		//https://www.shadertoy.com/view/XdXGW8
		float2 GradientNoiseDir( float2 x )
		{
			const float2 k = float2( 0.3183099, 0.3678794 );
			x = x * k + k.yx;
			return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
		}
		
		float GradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );
			return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
					lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_16_0_g1 = ( ase_worldPos * 100.0 );
			float3 crossY18_g1 = cross( ase_worldNormal , ddy( temp_output_16_0_g1 ) );
			float3 worldDerivativeX2_g1 = ddx( temp_output_16_0_g1 );
			float dotResult6_g1 = dot( crossY18_g1 , worldDerivativeX2_g1 );
			float crossYDotWorldDerivX34_g1 = abs( dotResult6_g1 );
			float time9 = ( _TextureSpeed * _Time.y );
			float cos8 = cos( ( _RotationSpeed * _Time.x ) );
			float sin8 = sin( ( _RotationSpeed * _Time.x ) );
			float2 rotator8 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos8 , -sin8 , sin8 , cos8 )) + float2( 0,0 );
			float2 coords9 = rotator8 * _Scale;
			float2 id9 = 0;
			float fade9 = 0.5;
			float voroi9 = 0;
			float rest9 = 0;
			for( int it9 = 0; it9 <2; it9++ ){
			voroi9 += fade9 * voronoi9( coords9, time9, id9,0 );
			rest9 += fade9;
			coords9 *= 2;
			fade9 *= 0.5;
			}//Voronoi9
			voroi9 /= rest9;
			float time32 = 0.0;
			float2 coords32 = i.uv_texcoord * _CracksScale;
			float2 id32 = 0;
			float voroi32 = voronoi32( coords32, time32,id32, 0 );
			float time39 = 0.0;
			float2 coords39 = i.uv_texcoord * _CracksScale;
			float2 id39 = 0;
			float fade39 = 0.5;
			float voroi39 = 0;
			float rest39 = 0;
			for( int it39 = 0; it39 <2; it39++ ){
			voroi39 += fade39 * voronoi39( coords39, time39, id39,0 );
			rest39 += fade39;
			coords39 *= 2;
			fade39 *= 0.5;
			}//Voronoi39
			voroi39 /= rest39;
			float blendOpSrc54 = voroi32;
			float blendOpDest54 = voroi39;
			float temp_output_41_0 = ( 1.0 - ( saturate( (( blendOpDest54 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest54 ) * ( 1.0 - blendOpSrc54 ) ) : ( 2.0 * blendOpDest54 * blendOpSrc54 ) ) )) );
			float gradientNoise36 = GradientNoise(i.uv_texcoord,_CracksMaskScale);
			gradientNoise36 = gradientNoise36*0.5 + 0.5;
			float temp_output_49_0 = ( 1.0 - ( pow( temp_output_41_0 , ( _CrackPower * 100.0 ) ) * pow( gradientNoise36 , (0.15 + (pow( _Health , _HealthScalingPower ) - 0.0) * (_CrackMaskPower - 0.15) / (1.0 - 0.0)) ) ) );
			float temp_output_20_0_g1 = ( ( 1.0 - pow( ( 1.0 - voroi9 ) , 2.0 ) ) * temp_output_49_0 * ( 1.0 - pow( temp_output_41_0 , 4.0 ) ) );
			float3 crossX19_g1 = cross( ase_worldNormal , worldDerivativeX2_g1 );
			float3 break29_g1 = ( sign( crossYDotWorldDerivX34_g1 ) * ( ( ddx( temp_output_20_0_g1 ) * crossY18_g1 ) + ( ddy( temp_output_20_0_g1 ) * crossX19_g1 ) ) );
			float3 appendResult30_g1 = (float3(break29_g1.x , -break29_g1.y , break29_g1.z));
			float3 normalizeResult39_g1 = normalize( ( ( crossYDotWorldDerivX34_g1 * ase_worldNormal ) - appendResult30_g1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g1 = mul( ase_worldToTangent, normalizeResult39_g1);
			o.Normal = worldToTangentDir42_g1;
			float temp_output_10_0 = ( 1.0 - voroi9 );
			float temp_output_13_0 = pow( temp_output_10_0 , _PrimaryPower );
			float4 temp_output_14_0 = ( temp_output_10_0 * _Primary * temp_output_13_0 );
			float4 temp_output_27_0 = ( _Secondary * ( pow( voroi9 , _SecondaryPower ) / temp_output_13_0 ) );
			float4 blendOpSrc28 = temp_output_14_0;
			float4 blendOpDest28 = temp_output_27_0;
			float4 blendOpSrc31 = _Primary;
			float4 blendOpDest31 = ( saturate( (( blendOpDest28 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest28 ) * ( 1.0 - blendOpSrc28 ) ) : ( 2.0 * blendOpDest28 * blendOpSrc28 ) ) ));
			o.Albedo = ( ( saturate( (( blendOpSrc31 > 0.5 ) ? max( blendOpDest31, 2.0 * ( blendOpSrc31 - 0.5 ) ) : min( blendOpDest31, 2.0 * blendOpSrc31 ) ) )) * temp_output_49_0 ).rgb;
			o.Emission = temp_output_27_0.rgb;
			o.Occlusion = temp_output_49_0;
			float grayscale15 = Luminance(temp_output_14_0.rgb);
			float temp_output_19_0 = pow( ( 1.0 - grayscale15 ) , _OpacityFactor );
			float smoothstepResult30 = smoothstep( 0.4 , 1.0 , ( 1.0 - pow( ( temp_output_19_0 * (( temp_output_19_0 >= 0.0 && temp_output_19_0 <= 0.02 ) ? 1.0 :  0.0 ) ) , _Opacity ) ));
			o.Alpha = smoothstepResult30;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
0;0;1360;717;6565.989;1487.846;6.550373;True;True
Node;AmplifyShaderEditor.TimeNode;1;-3819.403,268.7169;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-3770.077,110.5108;Inherit;False;Property;_RotationSpeed;Rotation Speed;7;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-3552.003,516.8009;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-3483.056,125.0069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3614.371,368.0056;Inherit;False;Property;_TextureSpeed;Texture Speed;6;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-3226.328,287.5297;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;8;-3321.968,75.19127;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-3309.586,394.8963;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;1;5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;9;-3038.881,252.7142;Inherit;True;2;0;1;2;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;10;-2681.439,351.6214;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2712.222,574.9214;Inherit;False;Property;_PrimaryPower;Primary Power;5;0;Create;True;0;0;False;0;3;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-2489.742,357.5101;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-2511.755,590.3417;Inherit;False;Property;_Primary;Primary;0;0;Create;True;0;0;False;0;0,0,0,0;0.7924528,0.1682093,0.73393,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2225.219,362.6333;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-3576.606,893.8856;Inherit;False;Property;_CracksScale;Cracks Scale;9;0;Create;True;0;0;False;0;3;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;15;-1980.286,-198.5332;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-3718.297,1489.169;Inherit;False;Property;_HealthScalingPower;Health Scaling Power;13;0;Create;True;0;0;False;0;2.5;2.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-3722.886,1409.554;Inherit;False;Property;_Health;Health;11;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;32;-3295.629,689.3464;Inherit;True;2;0;1;2;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.VoronoiNode;39;-3299.514,936.5663;Inherit;True;0;0;1;2;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;16;-1737.607,-208.9489;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1754.172,-105.529;Inherit;False;Property;_OpacityFactor;Opacity Factor;8;0;Create;True;0;0;False;0;15;15.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2961.095,1049.802;Inherit;False;Property;_CrackPower;Crack Power;14;0;Create;True;0;0;False;0;5;10;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2931.061,6.723328;Inherit;False;Property;_SecondaryPower;Secondary Power;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-3534.372,1574.724;Inherit;False;Property;_CrackMaskPower;Crack Mask Power;12;0;Create;True;0;0;False;0;4;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;54;-2995.101,809.9082;Inherit;True;Overlay;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-3432.073,1432.753;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-3571.152,1190.037;Inherit;False;Property;_CracksMaskScale;Cracks Mask Scale;10;0;Create;True;0;0;False;0;5;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;41;-2738.26,822.7803;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-2666.231,1053.685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;36;-3288.956,1183.158;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;3.35;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-1582.607,-217.9491;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-3251.3,1426.992;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.15;False;4;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;20;-2724.785,93.84374;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;64;-2510.751,1142.245;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;42;-2542.138,816.5305;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;44;-2962.061,1191.607;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;22;-2483.813,87.85835;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;21;-1343.675,-88.92926;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.02;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-2458.502,-107.8036;Inherit;False;Property;_Secondary;Secondary;2;0;Create;True;0;0;False;0;0,0,0,0;0.9528302,0.4809096,0.8644351,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1049.079,40.74624;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;0.7;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;65;-2316.935,1150.02;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-2282.711,820.4171;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1060.928,-209.0488;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;67;-2517.597,1358.395;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2232.38,67.87006;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;49;-2058.19,815.412;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;66;-2070.921,1150.447;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;68;-2269.854,1360.091;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;28;-2003.685,291.0382;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;26;-832.0776,-204.9585;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;31;-1742.246,293.674;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;29;-600.254,-204.4358;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1880.684,1158.727;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1400.465,343.3022;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;61;-1387.754,1119.148;Inherit;True;Normal From Height;-1;;1;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;30;-407.9431,-209.6774;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Crystal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;1;1
WireConnection;6;0;4;0
WireConnection;6;1;1;2
WireConnection;8;0;5;0
WireConnection;8;2;3;0
WireConnection;9;0;8;0
WireConnection;9;1;6;0
WireConnection;9;2;7;0
WireConnection;10;0;9;0
WireConnection;13;0;10;0
WireConnection;13;1;11;0
WireConnection;14;0;10;0
WireConnection;14;1;12;0
WireConnection;14;2;13;0
WireConnection;15;0;14;0
WireConnection;32;0;5;0
WireConnection;32;2;33;0
WireConnection;39;0;5;0
WireConnection;39;2;33;0
WireConnection;16;0;15;0
WireConnection;54;0;32;0
WireConnection;54;1;39;0
WireConnection;56;0;45;0
WireConnection;56;1;58;0
WireConnection;41;0;54;0
WireConnection;60;0;59;0
WireConnection;36;0;5;0
WireConnection;36;1;37;0
WireConnection;19;0;16;0
WireConnection;19;1;17;0
WireConnection;47;0;56;0
WireConnection;47;4;57;0
WireConnection;20;0;9;0
WireConnection;20;1;18;0
WireConnection;64;0;9;0
WireConnection;42;0;41;0
WireConnection;42;1;60;0
WireConnection;44;0;36;0
WireConnection;44;1;47;0
WireConnection;22;0;20;0
WireConnection;22;1;13;0
WireConnection;21;0;19;0
WireConnection;65;0;64;0
WireConnection;43;0;42;0
WireConnection;43;1;44;0
WireConnection;25;0;19;0
WireConnection;25;1;21;0
WireConnection;67;0;41;0
WireConnection;27;0;24;0
WireConnection;27;1;22;0
WireConnection;49;0;43;0
WireConnection;66;0;65;0
WireConnection;68;0;67;0
WireConnection;28;0;14;0
WireConnection;28;1;27;0
WireConnection;26;0;25;0
WireConnection;26;1;23;0
WireConnection;31;0;12;0
WireConnection;31;1;28;0
WireConnection;29;0;26;0
WireConnection;76;0;66;0
WireConnection;76;1;49;0
WireConnection;76;2;68;0
WireConnection;48;0;31;0
WireConnection;48;1;49;0
WireConnection;61;20;76;0
WireConnection;30;0;29;0
WireConnection;0;0;48;0
WireConnection;0;1;61;40
WireConnection;0;2;27;0
WireConnection;0;5;49;0
WireConnection;0;9;30;0
ASEEND*/
//CHKSM=0CA5FAF0BF71A65A01B0FB09894AA360543E1897