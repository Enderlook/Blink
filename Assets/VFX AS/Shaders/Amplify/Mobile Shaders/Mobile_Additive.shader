// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Mobile/Particles/Additive"
{
	Properties
	{
		_MainTex("Main Tex", 2D) = "white" {}
		_ColorIntensity("Color Intensity", Range( 0 , 10)) = 1.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma exclude_renderers xbox360 xboxone ps4 psp2 n3ds wiiu 
		#pragma surface surf Unlit keepalpha noshadow noinstancing noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
		};

		uniform float _ColorIntensity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 colorRGBA7 = ( _ColorIntensity * i.vertexColor );
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float mainTex4 = tex2D( _MainTex, uv0_MainTex ).a;
			float colorAlpha11 = i.vertexColor.a;
			float4 tintColor20 = ( colorRGBA7 * 2.0 * mainTex4 * colorAlpha11 );
			o.Emission = tintColor20.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;2644.308;-96.7018;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;5;-2225.458,-361.6745;Inherit;False;1240.082;609.4243;Comment;4;1;2;3;4;Main Texture;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-2217.693,344.8871;Inherit;False;1179.902;653.3196;Comment;5;7;11;8;9;31;Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2175.458,-311.6745;Inherit;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;8734a3a6cfedbad4a9b061abbcf7830e;8734a3a6cfedbad4a9b061abbcf7830e;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.VertexColorNode;31;-2140.134,532.5802;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-2184.802,406.9802;Inherit;False;Property;_ColorIntensity;Color Intensity;2;0;Create;True;0;0;False;0;1.5;1.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1899.648,-51.25013;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1619.955,-310.7701;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1719.184,488.1087;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2197.819,1119.704;Inherit;False;1237.064;1031.522;Comment;6;20;18;14;30;13;16;Apply Color;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;4;-1228.377,-310.1469;Inherit;True;mainTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1932.005,711.1157;Inherit;True;colorAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1304.541,484.6357;Inherit;True;colorRGBA;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;-2137.997,1228.056;Inherit;True;7;colorRGBA;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2119.861,1449.23;Inherit;True;Constant;_Value;Value;6;1;[HideInInspector];Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-2137.115,1693.296;Inherit;True;4;mainTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-2135.423,1927.813;Inherit;True;11;colorAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1552.509,1487.661;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;23;-341.7588,-50;Inherit;False;865.6782;543.7803;Comment;2;0;22;Output;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-1234.158,1481.505;Inherit;True;tintColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-291.7588,38.80527;Inherit;True;20;tintColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;230.5993,-0.4439051;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;AvalonStudios/Mobile/Particles/Additive;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;True;False;True;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;8;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;2;1;0
WireConnection;3;0;1;0
WireConnection;3;1;2;0
WireConnection;8;0;9;0
WireConnection;8;1;31;0
WireConnection;4;0;3;4
WireConnection;11;0;31;4
WireConnection;7;0;8;0
WireConnection;16;0;13;0
WireConnection;16;1;30;0
WireConnection;16;2;14;0
WireConnection;16;3;18;0
WireConnection;20;0;16;0
WireConnection;0;2;22;0
ASEEND*/
//CHKSM=DF0D92462293AEF7E76908F13504D7684AED31A4