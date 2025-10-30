Shader "Shader Graphs/GoldenTileShader_IconColorProcessor_Blossom" {
	Properties {
		[NoScaleOffset] _Base_Tiile_Texture ("Base_Tiile_Texture", 2D) = "white" {}
		[NoScaleOffset] _GoldenTile_Texture ("GoldenTile_Texture", 2D) = "white" {}
		_Color ("Color", Vector) = (1,1,1,1)
		[NoScaleOffset] _IconTexture ("IconTexture", 2D) = "white" {}
		_IconSize ("IconSize", Range(1, 2)) = 1.59
		_InlineWidth ("InlineWidth", Range(1, 2)) = 1.531
		[HDR] _InlineColor ("InlineColor", Vector) = (1,0.145098,0,0)
		_OutlineWidth ("OutlineWidth", Range(1, 2)) = 1.464
		_OutlineColor ("OutlineColor", Vector) = (0.3018868,0.06083527,0.02990388,0)
		[HDR] _GoldenTile_Icon_Color ("GoldenTile Icon Color", Vector) = (4.115653,1.67779,0.1358943,0)
		_LuminanceWeight ("LuminanceWeight", Vector) = (0.07,1.34,-0.36,0)
		[Toggle(_ISGREENFILTER)] _ISGREENFILTER ("IsGreenFilterEnabled", Float) = 0
		_LuminanceWeightGreen ("_LuminanceWeightGreen", Vector) = (0.07,1.34,-0.36,0)
		_GT_Saturation ("GT Saturation", Range(0.5, 1.5)) = 0.732
		_GT_Brightness ("GT Brightness", Range(-2, 1)) = -0.62
		_GT_Contrast ("GT Contrast", Range(1, 5)) = 2.8
		_BreakAmount ("BreakAmount", Range(0, 4)) = 1
		_BreakLineThickness ("BreakLineThickness", Vector) = (0.76,0.82,0,0)
		_BreakOutlineColor ("BreakOutlineColor", Vector) = (0.3490196,0.007843138,0.1137255,1)
		_BrokenTileShadowColor ("BrokenTileShadowColor", Vector) = (0.5137255,0.4196078,0.7843137,1)
		[NoScaleOffset] _GlintGradient ("GlintGradient", 2D) = "white" {}
		_PassoverTime ("PassoverTime", Range(0, 1)) = 0
		_PassoverGlowPow ("PassoverGlowPow", Float) = 1
		[HideInInspector] _QueueOffset ("_QueueOffset", Float) = 0
		[HideInInspector] _QueueControl ("_QueueControl", Float) = -1
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4x4 unity_ObjectToWorld;
			float4x4 unity_MatrixVP;

			struct Vertex_Stage_Input
			{
				float4 pos : POSITION;
			};

			struct Vertex_Stage_Output
			{
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.pos));
				return output;
			}

			float4 _Color;

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				return _Color; // RGBA
			}

			ENDHLSL
		}
	}
	Fallback "Hidden/Shader Graph/FallbackError"
	//CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
}