// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Alpha Blend HDR 01"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (1,1,1,0)
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
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodirlightmap nofog nometa 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 MainColorWithAlpha44 = _Color;
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 UVs14 = uv0_MainTex;
			float4 tex2DNode2 = tex2D( _MainTex, UVs14 );
			float4 MainTextureColor31 = tex2DNode2;
			float4 Color22 = ( ( MainColorWithAlpha44 * MainTextureColor31 ) * i.vertexColor );
			o.Emission = Color22.rgb;
			float MainTexture16 = tex2DNode2.a;
			float MainColorAlpha46 = _Color.a;
			float AlphaSlpit42 = ( MainTexture16 * i.vertexColor.a * MainColorAlpha46 );
			o.Alpha = AlphaSlpit42;
		}

		ENDCG
	}
	Fallback "AvalonStudios/Mobile/Particles/Alpha Blend 01"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
0;0;1920;1059;4179.887;1429.959;2.892908;True;True
Node;AmplifyShaderEditor.CommentaryNode;17;-2497.087,-485.6586;Inherit;False;1527.754;519.7872;Comment;6;31;16;2;14;1;36;Main Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2447.087,-432.8241;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;False;8734a3a6cfedbad4a9b061abbcf7830e;8734a3a6cfedbad4a9b061abbcf7830e;False;white;LockedToTexture2D;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-2158.649,-242.7697;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;50;-2489.451,-1141.247;Inherit;False;616.6031;499.6279;Comment;3;46;44;3;Main Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-1906.185,-243.2235;Inherit;True;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;3;-2439.451,-1091.247;Inherit;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;1.720795,1.720795,1.720795,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1632.597,-432.8689;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;25;-2526.206,190.4768;Inherit;False;1799.132;1124.54;Comment;10;56;18;22;6;5;54;4;51;57;42;Color & Alpha;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-1306.416,-173.1167;Inherit;True;MainTextureColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-2141.523,-1089.504;Inherit;True;MainColorWithAlpha;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2476.206,448.0649;Inherit;True;31;MainTextureColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-1304.245,-427.8622;Inherit;True;MainTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-2479.56,242.0915;Inherit;True;44;MainColorWithAlpha;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-2141.031,-880.6188;Inherit;True;MainColorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-2174.487,380.9364;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1895.927,1042.202;Inherit;False;46;MainColorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1891.425,898.0089;Inherit;False;16;MainTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;5;-2200.563,827.5077;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1639.395,942.8578;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1631.604,585.0371;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;30;-557.1404,-583.4671;Inherit;False;716.2175;724.6855;Comment;3;23;12;58;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1305.442,578.4634;Inherit;True;Color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-1365.129,937.3538;Inherit;True;AlphaSlpit;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-485.0657,-465.2345;Inherit;True;22;Color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-492.3957,-187.4809;Inherit;True;42;AlphaSlpit;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;12;-103.9224,-447.1319;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Particles/Alpha Blend HDR 01;False;False;False;False;True;True;True;False;True;True;True;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;AvalonStudios/Mobile/Particles/Alpha Blend 01;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;2;1;0
WireConnection;14;0;36;0
WireConnection;2;0;1;0
WireConnection;2;1;14;0
WireConnection;31;0;2;0
WireConnection;44;0;3;0
WireConnection;16;0;2;4
WireConnection;46;0;3;4
WireConnection;4;0;51;0
WireConnection;4;1;18;0
WireConnection;56;0;57;0
WireConnection;56;1;5;4
WireConnection;56;2;54;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;22;0;6;0
WireConnection;42;0;56;0
WireConnection;12;2;23;0
WireConnection;12;9;58;0
ASEEND*/
//CHKSM=4BDCAFDEFA48B2611F5558CFE4E3D62485F84F70