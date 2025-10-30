Shader "Shader Graphs/RacesHeaderText" {
	Properties {
		[NoScaleOffset] _MainTex ("_MainTex", 2D) = "white" {}
		_innerThickness ("innerThickness", Range(0, 1)) = 0.5
		_PerspectiveOffset ("PerspectiveOffset", Range(0, 1)) = 1
		_PerspectiveXOffset ("PerspectiveXOffset", Range(0, 1E-05)) = 1E-05
		_YCompensation ("YCompensation", Float) = 0
		_ScalingFactor ("ScalingFactor", Float) = 1
		_InnerTwoColorEdgeSoftness ("InnerTwoColorEdgeSoftness", Range(0, 100)) = 100
		_InnerTwoColorEdgeYPos ("InnerTwoColorEdgeYPos", Float) = 0
		_InnerTopColor ("InnerTopColor", Vector) = (1,1,1,0)
		_InnerBottomColor ("InnerBottomColor", Vector) = (0,0,0,0)
		_InnerShadowThickness ("InnerShadowThickness", Float) = 0
		_InnerShadowColor ("InnerShadowColor", Vector) = (0,0,0,0)
		_InnerShadowYPos ("InnerShadowYPos", Range(0, 0.003)) = 0
		_InnerYOffset ("InnerYOffset", Float) = 0
		_OuterThickness ("OuterThickness", Range(0, 1)) = 0.5
		_OuterColor ("OuterColor", Vector) = (0,0,0,0)
		_OuterShadowColor ("OuterShadowColor", Vector) = (0,0,0,0)
		_OuterShadowYOffset ("OuterShadowYOffset", Float) = 0
		_HighlightEdgeSoftness ("HighlightEdgeSoftness", Range(0, 100)) = 100
		_HighlightEdgeYPos ("HighlightEdgeYPos", Float) = 0
		_HighlightBrightColor ("HighlightBrightColor", Vector) = (1,1,1,0)
		_HighlightDarkColor ("HighlightDarkColor", Vector) = (0,0,0,0)
		_HIghlightShadowEdgeSoftness ("HIghlightShadowEdgeSoftness", Range(0, 5)) = 5
		_HighlightShadowEdgeYPos ("HighlightShadowEdgeYPos", Float) = -0.35
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
			float4 _MainTex_ST;

			struct Vertex_Stage_Input
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct Vertex_Stage_Output
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.uv = (input.uv.xy * _MainTex_ST.xy) + _MainTex_ST.zw;
				output.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.pos));
				return output;
			}

			Texture2D<float4> _MainTex;
			SamplerState sampler_MainTex;

			struct Fragment_Stage_Input
			{
				float2 uv : TEXCOORD0;
			};

			float4 frag(Fragment_Stage_Input input) : SV_TARGET
			{
				return _MainTex.Sample(sampler_MainTex, input.uv.xy);
			}

			ENDHLSL
		}
	}
	Fallback "Hidden/Shader Graph/FallbackError"
	//CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
}