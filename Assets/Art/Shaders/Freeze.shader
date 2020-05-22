// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Freeze"
{
	Properties
	{
		_Primary("Primary", Color) = (0,0,0,0)
		_Opacity("Opacity", Range( 0 , 1)) = 0.7
		_Secondary("Secondary", Color) = (0,0,0,0)
		_Scale("Scale", Range( 0 , 100)) = 1
		_SecondaryPower("Secondary Power", Float) = 1
		_PrimaryPower("Primary Power", Float) = 3
		_TextureSpeed("Texture Speed", Range( 0 , 100)) = 0.1
		_RotationSpeed("Rotation Speed", Range( 0 , 100)) = 0.1
		_OpacityFactor("Opacity Factor", Float) = 15
		_MinOpacity("Min Opacity", Range( 0 , 1)) = 0.2
		_CrackedNormalFactor("Cracked Normal Factor", Range( 0 , 250)) = 25
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
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
		uniform float _CrackedNormalFactor;
		uniform float4 _Primary;
		uniform float _PrimaryPower;
		uniform float4 _Secondary;
		uniform float _SecondaryPower;
		uniform float _OpacityFactor;
		uniform float _Opacity;
		uniform float _MinOpacity;


		float2 voronoihash26( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi26( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash26( n + g );
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


		float2 voronoihash16( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi16( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash16( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_16_0_g1 = ( ase_worldPos * 100.0 );
			float3 crossY18_g1 = cross( ase_worldNormal , ddy( temp_output_16_0_g1 ) );
			float3 worldDerivativeX2_g1 = ddx( temp_output_16_0_g1 );
			float dotResult6_g1 = dot( crossY18_g1 , worldDerivativeX2_g1 );
			float crossYDotWorldDerivX34_g1 = abs( dotResult6_g1 );
			float time26 = _TextureSpeed;
			float cos14 = cos( ( _RotationSpeed * _Time.x ) );
			float sin14 = sin( ( _RotationSpeed * _Time.x ) );
			float2 rotator14 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos14 , -sin14 , sin14 , cos14 )) + float2( 0,0 );
			float2 coords26 = rotator14 * _Scale;
			float2 id26 = 0;
			float voroi26 = voronoi26( coords26, time26,id26, 0 );
			float time16 = ( _TextureSpeed * _Time.y );
			float2 coords16 = rotator14 * _Scale;
			float2 id16 = 0;
			float fade16 = 0.5;
			float voroi16 = 0;
			float rest16 = 0;
			for( int it16 = 0; it16 <2; it16++ ){
			voroi16 += fade16 * voronoi16( coords16, time16, id16,0 );
			rest16 += fade16;
			coords16 *= 2;
			fade16 *= 0.5;
			}//Voronoi16
			voroi16 /= rest16;
			float blendOpSrc32 = voroi26;
			float blendOpDest32 = voroi16;
			float temp_output_20_0_g1 = ( ( 1.0 - pow( ( 1.0 - ( saturate( (( blendOpDest32 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest32 ) * ( 1.0 - blendOpSrc32 ) ) : ( 2.0 * blendOpDest32 * blendOpSrc32 ) ) )) ) , _CrackedNormalFactor ) ) * voroi26 );
			float3 crossX19_g1 = cross( ase_worldNormal , worldDerivativeX2_g1 );
			float3 break29_g1 = ( sign( crossYDotWorldDerivX34_g1 ) * ( ( ddx( temp_output_20_0_g1 ) * crossY18_g1 ) + ( ddy( temp_output_20_0_g1 ) * crossX19_g1 ) ) );
			float3 appendResult30_g1 = (float3(break29_g1.x , -break29_g1.y , break29_g1.z));
			float3 normalizeResult39_g1 = normalize( ( ( crossYDotWorldDerivX34_g1 * ase_worldNormal ) - appendResult30_g1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g1 = mul( ase_worldToTangent, normalizeResult39_g1);
			o.Normal = worldToTangentDir42_g1;
			float temp_output_17_0 = ( 1.0 - voroi16 );
			float temp_output_19_0 = pow( temp_output_17_0 , _PrimaryPower );
			float4 temp_output_21_0 = ( temp_output_17_0 * _Primary * temp_output_19_0 );
			float4 blendOpSrc54 = temp_output_21_0;
			float4 blendOpDest54 = ( _Secondary * ( pow( voroi16 , _SecondaryPower ) / temp_output_19_0 ) );
			float4 lerpBlendMode54 = lerp(blendOpDest54,( 1.0 - ( 1.0 - blendOpSrc54 ) * ( 1.0 - blendOpDest54 ) ),0.24);
			float4 temp_output_54_0 = ( saturate( lerpBlendMode54 ));
			o.Albedo = temp_output_54_0.rgb;
			float grayscale23 = Luminance(temp_output_21_0.rgb);
			o.Alpha = (_MinOpacity + (( pow( ( 1.0 - grayscale23 ) , _OpacityFactor ) * _Opacity ) - 0.0) * (1.0 - _MinOpacity) / (1.0 - 0.0));
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
0;0;1360;717;2751.302;-414.5332;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;9;-3773.537,-69.57186;Inherit;False;Property;_RotationSpeed;Rotation Speed;7;0;Create;True;0;0;False;0;0.1;0.1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;8;-3822.864,88.6342;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-3617.831,187.9229;Inherit;False;Property;_TextureSpeed;Texture Speed;6;0;Create;True;0;0;False;0;0.1;0.1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;10;-3546.833,-274.0179;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3486.516,-55.0758;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;14;-3325.428,-104.8913;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-3313.047,214.8136;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;1;5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-3229.788,107.447;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;16;-3042.342,72.63151;Inherit;True;2;0;1;2;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;17;-2702.04,132.6869;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2715.682,394.8387;Inherit;False;Property;_PrimaryPower;Primary Power;5;0;Create;True;0;0;False;0;3;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-2491.405,422.164;Inherit;False;Property;_Primary;Primary;0;0;Create;True;0;0;False;0;0,0,0,0;0,0.5208681,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;19;-2510.343,138.5756;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;26;-3325.909,577.9927;Inherit;True;2;0;1;2;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2245.82,143.6988;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;32;-3080.745,589.734;Inherit;True;Overlay;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2913.99,816.3798;Inherit;False;Property;_CrackedNormalFactor;Cracked Normal Factor;10;0;Create;True;0;0;False;0;25;25;0;250;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;23;-1983.746,-378.6159;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2934.521,-173.3593;Inherit;False;Property;_SecondaryPower;Secondary Power;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;69;-2836.004,586.8754;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;70;-2661.233,590.951;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;25;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;40;-2728.245,-86.23891;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;59;-1761.568,-379.9717;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-1793.201,-163.5483;Inherit;False;Property;_OpacityFactor;Opacity Factor;8;0;Create;True;0;0;False;0;15;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1597.722,-173.1747;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;0.7;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;-1606.568,-388.9718;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-2461.962,-287.8864;Inherit;False;Property;_Secondary;Secondary;2;0;Create;True;0;0;False;0;0,0,0,0;0,0.8440862,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;73;-2430.795,614.7009;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-2487.273,-92.22433;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-2252.982,-89.35859;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-1287.256,-149.9864;Inherit;False;Property;_MinOpacity;Min Opacity;9;0;Create;True;0;0;False;0;0.2;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1376.92,-384.0963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-2277.927,609.8735;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;67;-1168.833,-370.4039;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;64;-1752.586,50.11919;Inherit;True;SoftLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;54;-2014.945,47.25549;Inherit;True;Screen;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0.24;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;58;-1904.961,655.2061;Inherit;True;Normal From Height;-1;;1;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Freeze;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;11;0;9;0
WireConnection;11;1;8;1
WireConnection;14;0;10;0
WireConnection;14;2;11;0
WireConnection;13;0;12;0
WireConnection;13;1;8;2
WireConnection;16;0;14;0
WireConnection;16;1;13;0
WireConnection;16;2;15;0
WireConnection;17;0;16;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;26;0;14;0
WireConnection;26;1;12;0
WireConnection;26;2;15;0
WireConnection;21;0;17;0
WireConnection;21;1;20;0
WireConnection;21;2;19;0
WireConnection;32;0;26;0
WireConnection;32;1;16;0
WireConnection;23;0;21;0
WireConnection;69;0;32;0
WireConnection;70;0;69;0
WireConnection;70;1;74;0
WireConnection;40;0;16;0
WireConnection;40;1;30;0
WireConnection;59;0;23;0
WireConnection;38;0;59;0
WireConnection;38;1;28;0
WireConnection;73;0;70;0
WireConnection;44;0;40;0
WireConnection;44;1;19;0
WireConnection;50;0;46;0
WireConnection;50;1;44;0
WireConnection;62;0;38;0
WireConnection;62;1;3;0
WireConnection;72;0;73;0
WireConnection;72;1;26;0
WireConnection;67;0;62;0
WireConnection;67;3;65;0
WireConnection;64;0;20;0
WireConnection;64;1;54;0
WireConnection;54;0;21;0
WireConnection;54;1;50;0
WireConnection;58;20;72;0
WireConnection;0;0;54;0
WireConnection;0;1;58;40
WireConnection;0;9;67;0
ASEEND*/
//CHKSM=F7F774CBC98DC3C3C40EAF4A6983C0F2323F2C06