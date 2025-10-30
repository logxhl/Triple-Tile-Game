Shader "Shader Graphs/SagaMap_MistyCloud_AsShader" {
	Properties {
		[NoScaleOffset] _MainTex ("MainTex", 2D) = "white" {}
		_Color ("Color", Vector) = (1,1,1,1)
		_Body_Control ("Body Control", Vector) = (0,0.1,0,0)
		_Shadow_Height ("Shadow Height", Range(0, 1)) = 0.35
		_Shadow_Pow ("Shadow Pow", Float) = 1
		_Shadow_Colour ("Shadow Colour", Vector) = (0.3871485,0.8093608,0.9433962,1)
		_Rim_Light ("Rim Light", Float) = 0.2
		_Rim_Light_Blend_Power ("Rim Light Blend Power", Float) = 1
		_Inside_Glow ("Inside Glow", Float) = 0.1
		_Inside_Glow_Pow ("Inside Glow Pow", Float) = 1
		_Inside_Glow_Y ("Inside Glow Y", Float) = 0
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
			float4 _Color;

			struct Fragment_Stage_Input
			{
				float2 uv : TEXCOORD0;
			};

			float4 frag(Fragment_Stage_Input input) : SV_TARGET
			{
				return _MainTex.Sample(sampler_MainTex, input.uv.xy) * _Color;
			}

			ENDHLSL
		}
	}
	Fallback "Hidden/Shader Graph/FallbackError"
	//CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
}