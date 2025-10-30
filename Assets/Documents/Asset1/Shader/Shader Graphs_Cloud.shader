Shader "Shader Graphs/Cloud" {
	Properties {
		[NoScaleOffset] _MainTex ("_MainTex", 2D) = "white" {}
		[NoScaleOffset] _NormalMap ("NormalMap", 2D) = "white" {}
		_Alpha_intensity ("Alpha intensity", Float) = 4.19
		_RimLightColor ("RimLightColor", Vector) = (0,0,0,0)
		_RimLightDepth ("RimLightDepth", Range(0, 1)) = 0
		_LightColor_01 ("LightColor_01", Vector) = (0,0,0,0)
		_LightDirection_01 ("LightDirection_01", Vector) = (0,0,0,0)
		_DepthMask_01 ("DepthMask_01", Range(0, 1)) = 0
		_Smoothness_01 ("Smoothness_01", Range(1, 5)) = 1
		_Contrast_01 ("Contrast_01", Range(1, 5)) = 1
		_LightColor_02 ("LightColor_02", Vector) = (0,0,0,0)
		_LightDirection_02 ("LightDirection_02", Vector) = (0,0,0,0)
		_DepthMask_02 ("DepthMask_02", Range(0, 1)) = 0
		_Smoothness_02 ("Smoothness_02", Range(1, 5)) = 1
		_Contrast_02 ("Contrast_02", Range(1, 5)) = 1
		_LightColor_03 ("LightColor_03", Vector) = (0,0,0,0)
		_LightDirection_03 ("LightDirection_03", Vector) = (0,0,0,0)
		_DepthMask_03 ("DepthMask_03", Range(0, 1)) = 0
		_Smoothness_03 ("Smoothness_03", Range(1, 5)) = 1
		_Contrast_03 ("Contrast_03", Range(1, 5)) = 1
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