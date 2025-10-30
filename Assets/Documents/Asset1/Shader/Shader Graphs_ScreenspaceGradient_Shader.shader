Shader "Shader Graphs/ScreenspaceGradient_Shader" {
	Properties {
		_ColorSmoothness ("ColorSmoothness", Range(0, 5)) = 0.89
		_ColorBalance ("ColorBalance", Range(0, 3)) = 1.11
		_Color01 ("Color01", Vector) = (1,0,0,1)
		_Color02 ("Color02", Vector) = (0,0,1,1)
		_Highlight_Color ("Highlight Color", Vector) = (0.6978707,0,1,1)
		_Line_Choke ("Line Choke", Range(0, 2)) = 1.23
		_Line_Size ("Line Size", Range(0, 3)) = 2
		_Line_Intensity ("Line Intensity", Range(0, 2)) = 0.07
		_Mid_Glow_Size ("Mid Glow Size", Range(0, 2)) = 1.14
		_Mid_Glow_Intensity ("Mid Glow Intensity", Range(0, 2)) = 0.19
		_Mid_Glow_Choke ("Mid Glow Choke", Range(0, 2)) = 0.1
		_Rim_Color ("Rim Color", Vector) = (0,0.9248903,1,1)
		_Rim_Size ("Rim Size", Range(0, 1)) = 0.566
		_Rim_Choke ("Rim Choke", Range(0, 2)) = 1.35
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