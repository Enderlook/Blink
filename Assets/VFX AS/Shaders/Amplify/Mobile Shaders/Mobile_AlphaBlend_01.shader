// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Mobile/Particles/Alpha Blend 01"
{
	Properties
	{
		_Intensity("Intensity", Range( 0 , 10)) = 1
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _Intensity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 MainColorWithAlpha44 = ( _Intensity * i.vertexColor );
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 UVs14 = uv0_MainTex;
			float4 tex2DNode2 = tex2D( _MainTex, UVs14 );
			float4 MainTextureColor31 = tex2DNode2;
			float4 Color22 = ( MainColorWithAlpha44 * MainTextureColor31 );
			o.Emission = Color22.rgb;
			float MainTexture16 = tex2DNode2.a;
			float MainColorAlpha46 = i.vertexColor.a;
			float AlphaSlpit42 = ( MainTexture16 * MainColorAlpha46 );
			o.Alpha = AlphaSlpit42;
		}

		ENDCG
	}
	Fallback "Mobile/Particles/Alpha Blended"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
0;0;1920;1059;4422.788;1725.57;3.626207;True;True
Node;AmplifyShaderEditor.CommentaryNode;17;-2499.98,-320.7628;Inherit;False;1461.334;523.6191;Comment;6;31;16;2;14;36;1;Main Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2449.98,-267.9283;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;False;8734a3a6cfedbad4a9b061abbcf7830e;8734a3a6cfedbad4a9b061abbcf7830e;False;white;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2161.542,-77.87399;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;50;-2518.461,-967.1885;Inherit;False;792.6031;504.6279;Comment;5;61;46;44;60;59;Main Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1909.078,-78.32771;Inherit;True;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;59;-2476.301,-793.1202;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-2503.156,-899.5147;Inherit;False;Property;_Intensity;Intensity;1;0;Create;True;0;0;False;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-2184.842,-817.386;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1635.49,-267.9731;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-2222.555,-662.0254;Inherit;True;MainColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1309.309,-8.220936;Inherit;True;MainTextureColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;25;-2500.17,338.0151;Inherit;False;935.454;873.6243;Comment;8;42;56;57;54;18;22;51;4;Color & Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1307.138,-262.9664;Inherit;True;MainTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1981.533,-911.4457;Inherit;True;MainColorWithAlpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2450.074,637.9304;Inherit;True;31;MainTextureColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-2443.035,1020.702;Inherit;False;46;MainColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2453.524,389.6299;Inherit;True;44;MainColorWithAlpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-2438.533,876.5089;Inherit;False;16;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-2186.503,921.3578;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2148.451,528.4748;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1825.567,525.3346;Inherit;True;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-1912.237,915.8538;Inherit;True;AlphaSlpit;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;30;-860.2322,-302.6742;Inherit;False;716.2175;724.6855;Comment;3;23;12;58;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-795.4877,93.31247;Inherit;True;42;AlphaSlpit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-788.1577,-184.4411;Inherit;True;22;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;-407.0151,-166.3385;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Mobile/Particles/Alpha Blend 01;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;Mobile/Particles/Alpha Blended;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;2;1;0
WireConnection;14;0;36;0
WireConnection;61;0;60;0
WireConnection;61;1;59;0
WireConnection;2;0;1;0
WireConnection;2;1;14;0
WireConnection;46;0;59;4
WireConnection;31;0;2;0
WireConnection;16;0;2;4
WireConnection;44;0;61;0
WireConnection;56;0;57;0
WireConnection;56;1;54;0
WireConnection;4;0;51;0
WireConnection;4;1;18;0
WireConnection;22;0;4;0
WireConnection;42;0;56;0
WireConnection;12;2;23;0
WireConnection;12;9;58;0
ASEEND*/
//CHKSM=512F4025E531CA82ED333E90944CE6DB720B6F44