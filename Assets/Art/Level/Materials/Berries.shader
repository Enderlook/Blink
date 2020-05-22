// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Custom/Berries"
{
	Properties
	{
		_PrimaryColor("Primary Color", Color) = (0,0,0,0)
		_SecondaryColor("Secondary Color", Color) = (0,0,0,0)
		_MaskScale("Mask Scale", Range( 0 , 100)) = 1
		_Scale("Scale", Range( 0 , 100)) = 1
		_TextureSpeed("Texture Speed", Range( 0 , 100)) = 1
		_RotationSpeed("Rotation Speed", Range( 0 , 100)) = 1
		_MinColor("Min Color", Range( 0 , 1)) = 0
		_MaxInflation("Max Inflation", Range( 0 , 1)) = 1
		_InflationSpeed("Inflation Speed", Range( 0 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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

		uniform float _InflationSpeed;
		uniform float _MaxInflation;
		uniform float4 _PrimaryColor;
		uniform float _Scale;
		uniform float _TextureSpeed;
		uniform float _RotationSpeed;
		uniform float _MaskScale;
		uniform float4 _SecondaryColor;
		uniform float _MinColor;


		float2 voronoihash3( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi3( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash3( n + g );
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
			return (F2 + F1) * 0.5;
		}


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 normalizeResult49 = normalize( ase_vertexNormal );
			v.vertex.xyz += ( ( normalizeResult49 * ( ( abs( sin( ( _Time.y * _InflationSpeed ) ) ) * _MaxInflation ) + 1.0 ) ) - normalizeResult49 );
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
			float time3 = ( _TextureSpeed * _Time.y );
			float cos30 = cos( ( _RotationSpeed * _Time.x ) );
			float sin30 = sin( ( _RotationSpeed * _Time.x ) );
			float2 rotator30 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos30 , -sin30 , sin30 , cos30 )) + float2( 0,0 );
			float2 coords3 = rotator30 * _Scale;
			float2 id3 = 0;
			float fade3 = 0.5;
			float voroi3 = 0;
			float rest3 = 0;
			for( int it3 = 0; it3 <2; it3++ ){
			voroi3 += fade3 * voronoi3( coords3, time3, id3,0 );
			rest3 += fade3;
			coords3 *= 2;
			fade3 *= 0.5;
			}//Voronoi3
			voroi3 /= rest3;
			float simplePerlin2D18 = snoise( rotator30*_MaskScale );
			simplePerlin2D18 = simplePerlin2D18*0.5 + 0.5;
			float4 temp_output_17_0 = ( pow( ( voroi3 * pow( simplePerlin2D18 , 2.4 ) ) , 1.0 ) * _SecondaryColor );
			float4 temp_cast_0 = (_MinColor).xxxx;
			float4 blendOpSrc16 = _PrimaryColor;
			float4 blendOpDest16 = min( max( pow( temp_output_17_0 , 0.4 ) , temp_cast_0 ) , float4( 1,1,1,0 ) );
			float4 temp_output_16_0 = ( saturate( (( blendOpDest16 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest16 ) * ( 1.0 - blendOpSrc16 ) ) : ( 2.0 * blendOpDest16 * blendOpSrc16 ) ) ));
			float grayscale36 = Luminance(temp_output_16_0.rgb);
			float temp_output_20_0_g1 = pow( grayscale36 , 2.0 );
			float3 crossX19_g1 = cross( ase_worldNormal , worldDerivativeX2_g1 );
			float3 break29_g1 = ( sign( crossYDotWorldDerivX34_g1 ) * ( ( ddx( temp_output_20_0_g1 ) * crossY18_g1 ) + ( ddy( temp_output_20_0_g1 ) * crossX19_g1 ) ) );
			float3 appendResult30_g1 = (float3(break29_g1.x , -break29_g1.y , break29_g1.z));
			float3 normalizeResult39_g1 = normalize( ( ( crossYDotWorldDerivX34_g1 * ase_worldNormal ) - appendResult30_g1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g1 = mul( ase_worldToTangent, normalizeResult39_g1);
			o.Normal = worldToTangentDir42_g1;
			o.Albedo = temp_output_16_0.rgb;
			o.Emission = pow( temp_output_17_0 , 1.5 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
0;0;1360;717;2858.39;417.8471;1.877361;True;True
Node;AmplifyShaderEditor.TimeNode;26;-2517.945,154.0236;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-2613.193,-2.597516;Inherit;False;Property;_RotationSpeed;Rotation Speed;5;0;Create;True;0;0;False;0;1;2;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;23;-2388.779,-203.3612;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-2326.172,11.89857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;30;-2163.499,-49.01201;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2040.561,-234.1519;Inherit;False;Property;_MaskScale;Mask Scale;2;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2221.323,302.4471;Inherit;False;Property;_TextureSpeed;Texture Speed;4;0;Create;True;0;0;False;0;1;2;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1882.853,96.74842;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;1;3;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;18;-1864.314,-233.2307;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1.73;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1950.569,174.4214;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;3;-1612.657,-5.37084;Inherit;True;2;0;1;3;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.PowerNode;22;-1632.477,-223.1269;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1371.77,-3.075043;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;8;-1145.862,-0.7621181;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1099.2,-189.4067;Inherit;False;Property;_SecondaryColor;Secondary Color;1;0;Create;True;0;0;False;0;0,0,0,0;0.8922057,0,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-891.2,2.593353;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2115.68,479.0642;Inherit;False;Property;_InflationSpeed;Inflation Speed;8;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1806.52,448.0006;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;33;-688.0476,8.98526;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.4;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-745.0262,264.5293;Inherit;False;Property;_MinColor;Min Color;6;0;Create;True;0;0;False;0;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;44;-1657.028,435.2777;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;34;-455.4298,5.764557;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.154;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMinOpNode;35;-252.63,13.56455;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1727.328,545.3503;Inherit;False;Property;_MaxInflation;Max Inflation;7;0;Create;True;0;0;False;0;1;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;45;-1484.37,436.6129;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-279.3062,262.2104;Inherit;False;Property;_PrimaryColor;Primary Color;0;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.2417459,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1322.669,435.6874;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;16;-26.90086,28.30049;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;48;-1409.29,564.6543;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;36;227.1034,262.8711;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;49;-1196.806,545.3004;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-1163.263,433.3315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;418.8073,269.021;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-998.6694,457.3205;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;39;-639.6654,-237.1846;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-766.5352,466.1735;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;37;656.5212,268.3839;Inherit;True;Normal From Height;-1;;1;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;988.2135,29.3151;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Custom/Berries;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;27;0
WireConnection;28;1;26;1
WireConnection;30;0;23;0
WireConnection;30;2;28;0
WireConnection;18;0;30;0
WireConnection;18;1;19;0
WireConnection;29;0;24;0
WireConnection;29;1;26;2
WireConnection;3;0;30;0
WireConnection;3;1;29;0
WireConnection;3;2;25;0
WireConnection;22;0;18;0
WireConnection;20;0;3;0
WireConnection;20;1;22;0
WireConnection;8;0;20;0
WireConnection;17;0;8;0
WireConnection;17;1;2;0
WireConnection;43;0;26;2
WireConnection;43;1;42;0
WireConnection;33;0;17;0
WireConnection;44;0;43;0
WireConnection;34;0;33;0
WireConnection;34;1;41;0
WireConnection;35;0;34;0
WireConnection;45;0;44;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;16;0;1;0
WireConnection;16;1;35;0
WireConnection;36;0;16;0
WireConnection;49;0;48;0
WireConnection;50;0;47;0
WireConnection;38;0;36;0
WireConnection;51;0;49;0
WireConnection;51;1;50;0
WireConnection;39;0;17;0
WireConnection;52;0;51;0
WireConnection;52;1;49;0
WireConnection;37;20;38;0
WireConnection;0;0;16;0
WireConnection;0;1;37;40
WireConnection;0;2;39;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=EE61A7A9DCEBFDF4D584FEF823FC6896F744EE6D