Shader "Shader Graphs/UI-GrayscaleTo2Color" {
	Properties {
		[ToggleUI] _UseHighlight ("UseHighlight", Float) = 0
		_HighlightsThreshold ("HighlightsThreshold", Range(0, 1)) = 0.853
		_HighlightsColor ("HighlightsColor", Vector) = (1,1,1,0)
		_LightColor ("LightColor", Vector) = (1,0.9751503,0.5424528,0)
		_DarkColor ("DarkColor", Vector) = (0.4039216,0,0.1058071,0)
		[ToggleUI] _UseShadows ("UseShadows", Float) = 0
		_ShadowsThreshold ("ShadowsThreshold", Float) = 0.25
		[HideInInspector] [NoScaleOffset] unity_Lightmaps ("unity_Lightmaps", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_LightmapsInd ("unity_LightmapsInd", 2DArray) = "" {}
		[HideInInspector] [NoScaleOffset] unity_ShadowMasks ("unity_ShadowMasks", 2DArray) = "" {}
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType" = "Opaque" }
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

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				return float4(1.0, 1.0, 1.0, 1.0); // RGBA
			}

			ENDHLSL
		}
	}
	Fallback "Hidden/Shader Graph/FallbackError"
	//CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
}