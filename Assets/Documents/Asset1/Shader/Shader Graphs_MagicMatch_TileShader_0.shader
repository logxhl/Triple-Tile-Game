Shader "Shader Graphs/MagicMatch_TileShader" {
	Properties {
		_Color ("OverallColor", Vector) = (1,1,1,1)
		[NoScaleOffset] _BaseTexture ("BaseTexture", 2D) = "white" {}
		_TileBackgroundColor ("TileBackgroundColor", Vector) = (0,0.7002699,1,0)
		[NoScaleOffset] _IconTexture ("IconTexture", 2D) = "black" {}
		_IconSize ("IconSize", Range(1, 2)) = 1.521
		[NoScaleOffset] _EffectsTexture ("EffectsTexture", 2D) = "white" {}
		_RaysTextureSize ("RaysTextureSize", Range(1, 2)) = 1.24
		_RaysGlowColor ("RaysGlowColor", Vector) = (0.2470588,0.2431373,0.2431373,0)
		_RaysIntensity ("RaysIntensity", Range(0, 4)) = 1.59
		_GlowBehindIconColor ("GlowBehindIconColor", Vector) = (0.3882353,0.2627451,0.2627451,0)
		_GlowBehindSize ("GlowBehindSize", Range(1, 1.8)) = 1.8
		_GlowBehindIntensity ("GlowBehindIntensity", Range(0, 2)) = 0.156
		_CornersSize ("CornersSize", Range(1, 2)) = 1.31
		_CornersGlowColor ("CornersGlowColor", Vector) = (1,0,0,0)
		_CornersGlowIntensity ("CornersGlowIntensity", Range(0, 4)) = 0.86
		_StarsColor ("StarsColor", Vector) = (1,1,1,0)
		_StarsTextureSize ("StarsTextureSize", Range(1, 2)) = 1.367
		_StarsIntensity ("StarsIntensity", Range(0, 1)) = 1
		[NoScaleOffset] _SampleTexture2D_805dbee0839448529669fda550bc16c2_Texture_1_Texture2D ("Texture2D", 2D) = "white" {}
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