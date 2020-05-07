Shader "Orb"
{
	Properties
	{
		_Primary("Primary", Color) = (0,0,0,0)
		_Secondary("Secondary", Color) = (0,0,0,0)
		_Scale("Scale", Float) = 0
		_SecondaryPower("Secondary Power", Float) = 1
		_PrimaryPower("Primary Power", Float) = 3
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Primary;
		uniform float _Scale;
		uniform float _PrimaryPower;
		uniform float4 _Secondary;
		uniform float _SecondaryPower;


		float2 voronoihash67( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi67( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash67( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time67 = _Time.y;
			float cos20 = cos( _Time.x );
			float sin20 = sin( _Time.x );
			float2 rotator20 = mul( i.uv_texcoord - float2( 0,0 ) , float2x2( cos20 , -sin20 , sin20 , cos20 )) + float2( 0,0 );
			float2 coords67 = rotator20 * _Scale;
			float2 id67 = 0;
			float fade67 = 0.5;
			float voroi67 = 0;
			float rest67 = 0;
			for( int it67 = 0; it67 <3; it67++ ){
			voroi67 += fade67 * voronoi67( coords67, time67, id67,0 );
			rest67 += fade67;
			coords67 *= 2;
			fade67 *= 0.5;
			}//Voronoi67
			voroi67 /= rest67;
			float temp_output_71_0 = ( 1.0 - voroi67 );
			float temp_output_88_0 = pow( temp_output_71_0 , _PrimaryPower );
			float4 temp_output_59_0 = ( _Secondary * ( pow( voroi67 , _SecondaryPower ) / temp_output_88_0 ) );
			float4 blendOpSrc94 = ( temp_output_71_0 * _Primary * temp_output_88_0 );
			float4 blendOpDest94 = temp_output_59_0;
			float4 blendOpSrc150 = _Primary;
			float4 blendOpDest150 = ( saturate( (( blendOpDest94 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest94 ) * ( 1.0 - blendOpSrc94 ) ) : ( 2.0 * blendOpDest94 * blendOpSrc94 ) ) ));
			o.Albedo = ( saturate( (( blendOpSrc150 > 0.5 ) ? max( blendOpDest150, 2.0 * ( blendOpSrc150 - 0.5 ) ) : min( blendOpDest150, 2.0 * blendOpSrc150 ) ) )).rgb;
			o.Emission = temp_output_59_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}