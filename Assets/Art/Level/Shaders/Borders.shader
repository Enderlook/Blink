Shader "Game/Borders"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_Speed("Speed", Vector) = (0,0,0,0)
		_NoiseScale("Noise Scale", Range( 0 , 25)) = 0
		_VoronoiScale("Voronoi Scale", Range( 0 , 25)) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow exclude_path:deferred
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _Color;
		uniform float2 _Speed;
		uniform float _NoiseScale;
		uniform float _VoronoiScale;


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


		float2 voronoihash15( float2 p )
		{
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi15( float2 v, float time, inout float2 id, float smoothness )
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
			 		float2 o = voronoihash15( n + g );
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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner108 = ( _Time.y * _Speed + i.uv_texcoord);
			float simplePerlin2D14 = snoise( panner108*_NoiseScale );
			simplePerlin2D14 = simplePerlin2D14*0.5 + 0.5;
			float time15 = _Time.y;
			float2 coords15 = panner108 * _VoronoiScale;
			float2 id15 = 0;
			float fade15 = 0.5;
			float voroi15 = 0;
			float rest15 = 0;
			for( int it15 = 0; it15 <2; it15++ ){
			voroi15 += fade15 * voronoi15( coords15, time15, id15,0 );
			rest15 += fade15;
			coords15 *= 2;
			fade15 *= 0.5;
			}//Voronoi15
			voroi15 /= rest15;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_97_0 = pow( ( simplePerlin2D14 * voroi15 * pow( max( ( ( 1.0 - ase_vertex3Pos.y ) / 2.0 ) , 0.0 ) , 0.55 ) ) , 0.5 );
			float4 temp_output_101_0 = ( _Color * temp_output_97_0 );
			o.Albedo = temp_output_101_0.rgb;
			o.Emission = temp_output_101_0.rgb;
			o.Alpha = temp_output_97_0;
		}

		ENDCG
	}
}