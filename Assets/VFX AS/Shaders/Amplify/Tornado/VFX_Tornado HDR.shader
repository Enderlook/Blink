// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/VFX HDR/VFX Tornado HDR"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.88
		_NoiseSpeed("Noise Speed", Vector) = (0,0,0,0)
		_NoiseScale("Noise Scale", Float) = 3
		_NoisePower("Noise Power", Float) = 0
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_TwirlSpeed("Twirl Speed", Vector) = (0.5,0.5,0,0)
		_TwirlCenter("Twirl Center", Vector) = (0.5,0.5,0,0)
		_TwirlNoiseScale("Twirl Noise Scale", Float) = 0
		_TwirlAmount("Twirl Amount", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseScale;
		uniform float2 _TwirlCenter;
		uniform float _TwirlAmount;
		uniform float2 _TwirlSpeed;
		uniform float _TwirlNoiseScale;
		uniform float _NoisePower;
		uniform float _Dissolve;
		uniform float _Cutoff = 0.88;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_output_1_0_g4 = i.uv_texcoord;
			float2 temp_output_11_0_g4 = ( temp_output_1_0_g4 - float2( 0.5,0.5 ) );
			float2 break18_g4 = temp_output_11_0_g4;
			float2 appendResult19_g4 = (float2(break18_g4.y , -break18_g4.x));
			float dotResult12_g4 = dot( temp_output_11_0_g4 , temp_output_11_0_g4 );
			float timer33 = _Time.y;
			float simplePerlin2D4 = snoise( ( temp_output_1_0_g4 + ( appendResult19_g4 * ( dotResult12_g4 * float2( 5,5 ) ) ) + ( timer33 * _NoiseSpeed ) )*_NoiseScale );
			simplePerlin2D4 = simplePerlin2D4*0.5 + 0.5;
			float radialNoise15 = simplePerlin2D4;
			float2 center45_g5 = _TwirlCenter;
			float2 delta6_g5 = ( i.uv_texcoord - center45_g5 );
			float angle10_g5 = ( length( delta6_g5 ) * _TwirlAmount );
			float x23_g5 = ( ( cos( angle10_g5 ) * delta6_g5.x ) - ( sin( angle10_g5 ) * delta6_g5.y ) );
			float2 break40_g5 = center45_g5;
			float2 break41_g5 = ( timer33 * _TwirlSpeed );
			float y35_g5 = ( ( sin( angle10_g5 ) * delta6_g5.x ) + ( cos( angle10_g5 ) * delta6_g5.y ) );
			float2 appendResult44_g5 = (float2(( x23_g5 + break40_g5.x + break41_g5.x ) , ( break40_g5.y + break41_g5.y + y35_g5 )));
			float simplePerlin2D26 = snoise( appendResult44_g5*_TwirlNoiseScale );
			simplePerlin2D26 = simplePerlin2D26*0.5 + 0.5;
			float twirlNoise41 = simplePerlin2D26;
			float twirlAndRadialNoise46 = pow( ( radialNoise15 * twirlNoise41 ) , _NoisePower );
			float4 tornadoColor22 = ( ( _Color * twirlAndRadialNoise46 ) * i.vertexColor );
			o.Emission = tornadoColor22.rgb;
			o.Alpha = 1;
			float alphaDissolve52 = (0.0 + (_Dissolve - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			clip( ( twirlAndRadialNoise46 - alphaDissolve52 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;3918.125;-2349.437;1.574646;True;True
Node;AmplifyShaderEditor.CommentaryNode;36;-3710.221,-430.6026;Inherit;False;514.2549;165;;2;1;33;Time;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-3660.221,-375.73;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;37;-3783.331,1172.998;Inherit;False;1604.52;534.832;;9;27;32;31;30;35;29;26;41;51;Twirl Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;-3766.573,291.5114;Inherit;False;1393.262;686.7395;Comment;9;2;3;14;13;8;10;4;34;15;Radial Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-3438.966,-380.6025;Inherit;False;timer;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-3716.573,676.9979;Inherit;False;33;timer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;2;-3712.094,817.2507;Inherit;False;Property;_NoiseSpeed;Noise Speed;1;0;Create;True;0;0;False;0;0,0;0,-0.8;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;32;-3733.331,1530.169;Inherit;False;Property;_TwirlSpeed;Twirl Speed;6;0;Create;True;0;0;False;0;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;35;-3725.396,1394.158;Inherit;False;33;timer;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3512.925,1365.998;Inherit;False;Property;_TwirlAmount;Twirl Amount;9;0;Create;True;0;0;False;0;5;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;30;-3514.925,1222.998;Inherit;False;Property;_TwirlCenter;Twirl Center;7;0;Create;True;0;0;False;0;0.5,0.5;0.6,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-3496.331,1460.467;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;14;-3691.772,478.7058;Inherit;False;Constant;_Vector4;Vector 4;3;0;Create;True;0;0;False;0;5,5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-3483.004,737.9952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;13;-3547.708,341.5114;Inherit;False;Constant;_Vector3;Vector 3;3;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;10;-3226.029,682.7352;Inherit;False;Property;_NoiseScale;Noise Scale;2;0;Create;True;0;0;False;0;3;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3154.152,1573.243;Inherit;False;Property;_TwirlNoiseScale;Twirl Noise Scale;8;0;Create;True;0;0;False;0;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-3282.82,441.3503;Inherit;True;Radial Shear;-1;;4;c6dc9fc7fa9b08c4d95138f2ae88b526;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;27;-3231.187,1325.263;Inherit;True;Twirl;-1;;5;90936742ac32db8449cd21ab6dd337c8;0;4;1;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;26;-2853.01,1457.087;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;4;-2940.811,559.7827;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;15;-2616.311,559.5554;Inherit;False;radialNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-3779.712,1781.197;Inherit;False;1158.924;513.4033;;6;44;42;43;46;49;50;Twirl & Radial;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2529.482,1457.018;Inherit;False;twirlNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-3729.712,1831.197;Inherit;True;15;radialNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-3726.817,2052.225;Inherit;True;41;twirlNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-3378.023,2214.927;Inherit;False;Property;_NoisePower;Noise Power;3;0;Create;True;0;0;False;0;0;-0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-3400.281,1965.429;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;50;-3112.023,2076.927;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;40;-3731.125,2426.974;Inherit;False;1241.242;680.9321;;6;18;39;19;20;21;22;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-2901.137,2071.137;Inherit;True;twirlAndRadialNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;53;-3709.336,3233.423;Inherit;False;996.4814;258.1636;;3;48;17;52;Dissolve;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3659.336,3283.423;Inherit;False;Property;_Dissolve;Dissolve;4;0;Create;True;0;0;False;0;0;0.297;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-3681.125,2476.974;Inherit;False;Property;_Color;Color;5;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.2121562,0.5381523,0.6830394,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;39;-3684.517,2750.597;Inherit;False;46;twirlAndRadialNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-3370.289,2655.909;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;20;-3342.884,2905.907;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;48;-3269.461,3289.586;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;52;-2957.855,3287.551;Inherit;False;alphaDissolve;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-3044.884,2774.907;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-611.5437,410.2657;Inherit;False;52;alphaDissolve;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-2732.883,2772.453;Inherit;True;tornadoColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-651.0998,535.7537;Inherit;True;46;twirlAndRadialNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-287.5437,469.2656;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-354.14,37.69589;Inherit;False;22;tornadoColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/VFX HDR/VFX Tornado HDR;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.88;True;False;0;True;Opaque;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;1;0
WireConnection;31;0;35;0
WireConnection;31;1;32;0
WireConnection;3;0;34;0
WireConnection;3;1;2;0
WireConnection;8;2;13;0
WireConnection;8;3;14;0
WireConnection;8;4;3;0
WireConnection;27;2;30;0
WireConnection;27;3;29;0
WireConnection;27;4;31;0
WireConnection;26;0;27;0
WireConnection;26;1;51;0
WireConnection;4;0;8;0
WireConnection;4;1;10;0
WireConnection;15;0;4;0
WireConnection;41;0;26;0
WireConnection;44;0;42;0
WireConnection;44;1;43;0
WireConnection;50;0;44;0
WireConnection;50;1;49;0
WireConnection;46;0;50;0
WireConnection;19;0;18;0
WireConnection;19;1;39;0
WireConnection;48;0;17;0
WireConnection;52;0;48;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;22;0;21;0
WireConnection;55;0;16;0
WireConnection;55;1;54;0
WireConnection;0;2;23;0
WireConnection;0;10;55;0
ASEEND*/
//CHKSM=1C3A9BD18CE39DCE7BBAB7BFC38DD1F7D0FB93DF