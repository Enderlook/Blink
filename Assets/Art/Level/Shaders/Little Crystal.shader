// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Little Crystal"
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
			return F2;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_16_0_g3 = ( ase_worldPos * 100.0 );
			float3 crossY18_g3 = cross( ase_worldNormal , ddy( temp_output_16_0_g3 ) );
			float3 worldDerivativeX2_g3 = ddx( temp_output_16_0_g3 );
			float dotResult6_g3 = dot( crossY18_g3 , worldDerivativeX2_g3 );
			float crossYDotWorldDerivX34_g3 = abs( dotResult6_g3 );
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
			float temp_output_83_0 = pow( voroi9 , 3.0 );
			float temp_output_20_0_g3 = temp_output_83_0;
			float3 crossX19_g3 = cross( ase_worldNormal , worldDerivativeX2_g3 );
			float3 break29_g3 = ( sign( crossYDotWorldDerivX34_g3 ) * ( ( ddx( temp_output_20_0_g3 ) * crossY18_g3 ) + ( ddy( temp_output_20_0_g3 ) * crossX19_g3 ) ) );
			float3 appendResult30_g3 = (float3(break29_g3.x , -break29_g3.y , break29_g3.z));
			float3 normalizeResult39_g3 = normalize( ( ( crossYDotWorldDerivX34_g3 * ase_worldNormal ) - appendResult30_g3 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g3 = mul( ase_worldToTangent, normalizeResult39_g3);
			o.Normal = worldToTangentDir42_g3;
			float temp_output_10_0 = ( 1.0 - voroi9 );
			float temp_output_12_0 = pow( temp_output_10_0 , _PrimaryPower );
			float4 temp_output_14_0 = ( temp_output_10_0 * _Primary * temp_output_12_0 );
			float4 temp_output_36_0 = ( _Secondary * ( pow( voroi9 , _SecondaryPower ) / temp_output_12_0 ) );
			float4 blendOpSrc39 = temp_output_14_0;
			float4 blendOpDest39 = temp_output_36_0;
			float4 blendOpSrc43 = _Primary;
			float4 blendOpDest43 = ( saturate( (( blendOpDest39 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest39 ) * ( 1.0 - blendOpSrc39 ) ) : ( 2.0 * blendOpDest39 * blendOpSrc39 ) ) ));
			o.Albedo = ( saturate( (( blendOpSrc43 > 0.5 ) ? max( blendOpDest43, 2.0 * ( blendOpSrc43 - 0.5 ) ) : min( blendOpDest43, 2.0 * blendOpSrc43 ) ) )).rgb;
			o.Emission = temp_output_36_0.rgb;
			o.Occlusion = pow( ( 1.0 - temp_output_83_0 ) , 2.0 );
			float grayscale16 = Luminance(temp_output_14_0.rgb);
			float temp_output_21_0 = pow( ( 1.0 - grayscale16 ) , _OpacityFactor );
			float smoothstepResult50 = smoothstep( 0.4 , 1.0 , ( 1.0 - pow( ( temp_output_21_0 * (( temp_output_21_0 >= 0.0 && temp_output_21_0 <= 0.02 ) ? 1.0 :  0.0 ) ) , _Opacity ) ));
			o.Alpha = smoothstepResult50;
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
0;0;1360;717;3590.205;853.4196;3.37923;True;True
Node;AmplifyShaderEditor.TimeNode;1;-3501.961,15.95185;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-3452.635,-142.2542;Inherit;False;Property;_RotationSpeed;Rotation Speed;7;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-3165.613,-127.758;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3296.928,115.2406;Inherit;False;Property;_TextureSpeed;Texture Speed;6;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-3241.539,-322.438;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-2908.885,34.76473;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2992.143,142.1313;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;1;5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;8;-3004.525,-177.5737;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;9;-2721.438,-0.05079007;Inherit;True;2;0;1;1;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;10;-2378.074,79.73774;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2408.857,303.0379;Inherit;False;Property;_PrimaryPower;Primary Power;5;0;Create;True;0;0;False;0;3;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-2208.39,318.4582;Inherit;False;Property;_Primary;Primary;0;0;Create;True;0;0;False;0;0,0,0,0;0.7924528,0.1682093,0.73393,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;12;-2186.377,85.62645;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1921.854,90.74964;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;16;-1676.921,-470.4169;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1450.807,-377.4126;Inherit;False;Property;_OpacityFactor;Opacity Factor;8;0;Create;True;0;0;False;0;15;15.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;-1434.242,-480.8326;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2627.696,-265.1603;Inherit;False;Property;_SecondaryPower;Secondary Power;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;21;-1279.242,-489.8327;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;26;-2421.42,-178.0399;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;25;-1040.31,-360.8129;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.02;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-757.5637,-480.9325;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-2180.447,-184.0253;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-745.7147,-231.1374;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;0.7;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-2155.137,-379.6873;Inherit;False;Property;_Secondary;Secondary;2;0;Create;True;0;0;False;0;0,0,0,0;0.9528302,0.4809096,0.8644351,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;83;-1682.338,607.5094;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;35;-528.7128,-476.8421;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1929.015,-204.0136;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;37;-296.8892,-476.3195;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;39;-1700.32,19.1546;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;84;-1383.31,384.5874;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;85;-1186.78,392.8207;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;50;-104.5784,-481.5611;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;43;-1438.881,21.79032;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;80;-1353.666,618.5229;Inherit;True;Normal From Height;-1;;3;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;216.1153,-24.01281;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Little Crystal;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
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
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;14;0;10;0
WireConnection;14;1;13;0
WireConnection;14;2;12;0
WireConnection;16;0;14;0
WireConnection;18;0;16;0
WireConnection;21;0;18;0
WireConnection;21;1;17;0
WireConnection;26;0;9;0
WireConnection;26;1;20;0
WireConnection;25;0;21;0
WireConnection;31;0;21;0
WireConnection;31;1;25;0
WireConnection;29;0;26;0
WireConnection;29;1;12;0
WireConnection;83;0;9;0
WireConnection;35;0;31;0
WireConnection;35;1;27;0
WireConnection;36;0;30;0
WireConnection;36;1;29;0
WireConnection;37;0;35;0
WireConnection;39;0;14;0
WireConnection;39;1;36;0
WireConnection;84;0;83;0
WireConnection;85;0;84;0
WireConnection;50;0;37;0
WireConnection;43;0;13;0
WireConnection;43;1;39;0
WireConnection;80;20;83;0
WireConnection;0;0;43;0
WireConnection;0;1;80;40
WireConnection;0;2;36;0
WireConnection;0;5;85;0
WireConnection;0;9;50;0
ASEEND*/
//CHKSM=7F407730E9DD5706A3C40B00A6309A1B4F977F58