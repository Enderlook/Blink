// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AvalonStudios/Particles/Rim Light Transparent"
{
	Properties
	{
		_InnerColor("Inner Color", Color) = (0,0,0,0)
		_RimColor("Rim Color", Color) = (0,0,0,0)
		_RimWidth("Rim Width", Range( 0.2 , 20)) = 0.2
		_RimGlowMultiplier("Rim Glow Multiplier", Range( 0 , 9)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		Blend One One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Lambert keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 viewDir;
			float3 worldNormal;
			float4 vertexColor : COLOR;
		};

		uniform float4 _InnerColor;
		uniform float4 _RimColor;
		uniform float _RimGlowMultiplier;
		uniform float _RimWidth;

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Albedo = _InnerColor.rgb;
			float3 normalizeResult6 = normalize( i.viewDir );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float dotResult7 = dot( normalizeResult6 , ase_vertexNormal );
			float rim11 = ( 1.0 - saturate( dotResult7 ) );
			o.Emission = ( _RimColor * _RimGlowMultiplier * pow( rim11 , _RimWidth ) * i.vertexColor.a ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
0;0;1440;879;1804.7;-132.8264;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;10;-2995.196,-320.0627;Inherit;False;1561.342;400.0971;Comment;7;11;9;8;7;6;5;19;Rim;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;5;-2945.196,-253.2604;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;6;-2701.397,-248.8601;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;19;-2707.788,-102.2882;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;7;-2408.178,-248.292;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-2196.306,-248.7397;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;9;-1949.503,-270.0626;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-1744.448,-273.705;Inherit;True;rim;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-1313.463,441.459;Inherit;False;11;rim;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1396.662,545.176;Inherit;False;Property;_RimWidth;Rim Width;3;0;Create;True;0;0;False;0;0.2;3.4;0.2;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;21;-1084.596,661.3046;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-1159.418,106.4099;Inherit;False;Property;_RimColor;Rim Color;2;0;Create;True;0;0;False;0;0,0,0,0;0,1,0.08972353,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1185.316,311.0104;Inherit;False;Property;_RimGlowMultiplier;Rim Glow Multiplier;4;0;Create;True;0;0;False;0;1;2.45;0;9;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-1087.579,445.5908;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1;-736.8002,-80.90002;Inherit;False;Property;_InnerColor;Inner Color;1;0;Create;True;0;0;False;0;0,0,0,0;0.1377512,0.3018867,0.08971158,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-671.7548,292.7341;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-258.6484,143.1333;Float;False;True;-1;2;ASEMaterialInspector;0;0;Lambert;AvalonStudios/Particles/Rim Light Transparent;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Off;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;7;0;6;0
WireConnection;7;1;19;0
WireConnection;8;0;7;0
WireConnection;9;1;8;0
WireConnection;11;0;9;0
WireConnection;13;0;14;0
WireConnection;13;1;3;0
WireConnection;12;0;2;0
WireConnection;12;1;4;0
WireConnection;12;2;13;0
WireConnection;12;3;21;4
WireConnection;0;0;1;0
WireConnection;0;2;12;0
ASEEND*/
//CHKSM=3B64F406F689D99D7F21418DFB650E9C5535838A