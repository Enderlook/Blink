// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Orb"
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
		_MaxInflation("Max Inflation", Range( 0 , 1)) = 1
		_InflationSpeed("Inflation Speed", Range( 0 , 10)) = 1
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
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _InflationSpeed;
		uniform float _MaxInflation;
		uniform float4 _Primary;
		uniform float _Scale;
		uniform float _TextureSpeed;
		uniform float _RotationSpeed;
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
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 normalizeResult79 = normalize( ase_vertexNormal );
			float3 temp_output_81_0 = ( ( normalizeResult79 * ( ( abs( sin( ( _Time.y * _InflationSpeed ) ) ) * _MaxInflation ) + 1.0 ) ) - normalizeResult79 );
			v.vertex.xyz += temp_output_81_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time9 = ( _TextureSpeed * _Time.y );
			float cos7 = cos( ( _RotationSpeed * _Time.x ) );
			float sin7 = sin( ( _RotationSpeed * _Time.x ) );
			float2 rotator7 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos7 , -sin7 , sin7 , cos7 )) + float2( 0,0 );
			float2 coords9 = rotator7 * _Scale;
			float2 id9 = 0;
			float fade9 = 0.5;
			float voroi9 = 0;
			float rest9 = 0;
			for( int it9 = 0; it9 <3; it9++ ){
			voroi9 += fade9 * voronoi9( coords9, time9, id9,0 );
			rest9 += fade9;
			coords9 *= 2;
			fade9 *= 0.5;
			}//Voronoi9
			voroi9 /= rest9;
			float temp_output_12_0 = ( 1.0 - voroi9 );
			float temp_output_14_0 = pow( temp_output_12_0 , _PrimaryPower );
			float4 temp_output_22_0 = ( temp_output_12_0 * _Primary * temp_output_14_0 );
			float4 temp_output_25_0 = ( _Secondary * ( pow( voroi9 , _SecondaryPower ) / temp_output_14_0 ) );
			float4 blendOpSrc27 = temp_output_22_0;
			float4 blendOpDest27 = temp_output_25_0;
			float4 blendOpSrc30 = _Primary;
			float4 blendOpDest30 = ( saturate( (( blendOpDest27 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest27 ) * ( 1.0 - blendOpSrc27 ) ) : ( 2.0 * blendOpDest27 * blendOpSrc27 ) ) ));
			o.Albedo = ( saturate( (( blendOpSrc30 > 0.5 ) ? max( blendOpDest30, 2.0 * ( blendOpSrc30 - 0.5 ) ) : min( blendOpDest30, 2.0 * blendOpSrc30 ) ) )).rgb;
			o.Emission = temp_output_25_0.rgb;
			float grayscale90 = Luminance(temp_output_22_0.rgb);
			float temp_output_93_0 = pow( ( 1.0 - grayscale90 ) , _OpacityFactor );
			float smoothstepResult110 = smoothstep( 0.4 , 1.0 , ( 1.0 - pow( ( temp_output_93_0 * (( temp_output_93_0 >= 0.0 && temp_output_93_0 <= 0.02 ) ? 1.0 :  0.0 ) ) , _Opacity ) ));
			o.Alpha = smoothstepResult110;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float3 worldPos : TEXCOORD2;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
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
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
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
0;0;1360;717;876.7917;661.5785;1;True;True
Node;AmplifyShaderEditor.TimeNode;1;-2412.915,-97.33626;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-2363.589,-255.5423;Inherit;False;Property;_RotationSpeed;Rotation Speed;9;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2076.567,-241.0461;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2207.882,1.952457;Inherit;False;Property;_TextureSpeed;Texture Speed;8;0;Create;True;0;0;False;0;1;1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-2152.493,-435.726;Inherit;True;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;7;-1915.479,-290.8618;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1819.84,-78.52338;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1903.097,28.84318;Inherit;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;1;10;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;9;-1632.392,-113.3389;Inherit;True;2;0;1;0;3;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.OneMinusNode;12;-1289.029,-33.55037;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1319.812,189.7498;Inherit;False;Property;_PrimaryPower;Primary Power;5;0;Create;True;0;0;False;0;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-1097.332,-27.66166;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-1119.345,205.1701;Inherit;False;Property;_Primary;Primary;0;0;Create;True;0;0;False;0;0,0,0,0;0.2470588,0.6509804,0.1490196,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-832.8087,-22.53847;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1936.171,503.761;Inherit;False;Property;_InflationSpeed;Inflation Speed;12;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;90;-587.8754,-583.705;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-345.1967,-594.1207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-368.7616,-490.7007;Inherit;False;Property;_OpacityFactor;Opacity Factor;13;0;Create;True;0;0;False;0;15;15.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-1627.011,472.6974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1538.651,-378.4484;Inherit;False;Property;_SecondaryPower;Secondary Power;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;93;-190.1967,-603.1207;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;45;-1477.519,459.9745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareWithRange;98;48.73568,-474.101;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.02;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;62;-1304.861,461.3096;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-1547.819,570.047;Inherit;False;Property;_MaxInflation;Max Inflation;11;0;Create;True;0;0;False;0;1;0.048;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;15;-1332.375,-291.328;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;50;-1229.781,589.351;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1143.16,460.3842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;18;-1091.401,-297.3134;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;19;-1066.092,-492.9754;Inherit;False;Property;_Secondary;Secondary;2;0;Create;True;0;0;False;0;0,0,0,0;0.5019608,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;331.4817,-594.2206;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;343.3306,-344.4255;Inherit;False;Property;_Opacity;Opacity;1;0;Create;True;0;0;False;0;0.7;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;79;-1017.297,569.9971;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-983.7538,458.0283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;105;560.3326,-590.1302;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-839.9691,-317.3017;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;107;792.1562,-589.6076;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-819.1605,482.0172;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;27;-611.2747,-94.1335;Inherit;True;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;87;-979.3661,1081.638;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1826.465,908.1152;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-312.47,627.8962;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1647.247,1183.522;Inherit;False;Property;_DeformAmount;Deform Amount;6;0;Create;True;0;0;False;0;1;0.2;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-581.7482,518.539;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1934.922,1027.679;Inherit;False;Property;_DeformScale;Deform Scale;7;0;Create;True;0;0;False;0;1;5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;24;-1600.234,941.1458;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-1132.632,1057.34;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;110;984.467,-594.8492;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;30;-349.8357,-91.49779;Inherit;True;PinLight;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-740.1218,1100.329;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;28;-1350.91,1066.581;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2146.308,906.2877;Inherit;False;Property;_DeformSpeed;Deform Speed;10;0;Create;True;0;0;False;0;1;2;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1504.984,-79.64565;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Orb;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;1;1;1
WireConnection;7;0;3;0
WireConnection;7;2;4;0
WireConnection;6;0;5;0
WireConnection;6;1;1;2
WireConnection;9;0;7;0
WireConnection;9;1;6;0
WireConnection;9;2;8;0
WireConnection;12;0;9;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;22;0;12;0
WireConnection;22;1;21;0
WireConnection;22;2;14;0
WireConnection;90;0;22;0
WireConnection;92;0;90;0
WireConnection;77;0;1;2
WireConnection;77;1;78;0
WireConnection;93;0;92;0
WireConnection;93;1;91;0
WireConnection;45;0;77;0
WireConnection;98;0;93;0
WireConnection;62;0;45;0
WireConnection;15;0;9;0
WireConnection;15;1;10;0
WireConnection;75;0;62;0
WireConnection;75;1;55;0
WireConnection;18;0;15;0
WireConnection;18;1;14;0
WireConnection;99;0;93;0
WireConnection;99;1;98;0
WireConnection;79;0;50;0
WireConnection;76;0;75;0
WireConnection;105;0;99;0
WireConnection;105;1;29;0
WireConnection;25;0;19;0
WireConnection;25;1;18;0
WireConnection;107;0;105;0
WireConnection;74;0;79;0
WireConnection;74;1;76;0
WireConnection;27;0;22;0
WireConnection;27;1;25;0
WireConnection;87;0;86;0
WireConnection;87;1;79;0
WireConnection;17;0;13;0
WireConnection;17;1;1;1
WireConnection;84;0;81;0
WireConnection;84;1;88;0
WireConnection;81;0;74;0
WireConnection;81;1;79;0
WireConnection;24;0;3;0
WireConnection;24;1;17;0
WireConnection;24;2;20;0
WireConnection;86;0;28;0
WireConnection;110;0;107;0
WireConnection;30;0;21;0
WireConnection;30;1;27;0
WireConnection;88;0;87;0
WireConnection;88;1;79;0
WireConnection;28;0;24;0
WireConnection;28;4;16;0
WireConnection;0;0;30;0
WireConnection;0;2;25;0
WireConnection;0;9;110;0
WireConnection;0;11;81;0
ASEEND*/
//CHKSM=4F2E72D356CB9FD9A5DF1B057D1909F1CFF5DC08