Shader "Shader Graphs/TileBreakShader" {
	Properties {
		[NoScaleOffset] _BaseTexture ("BaseTexture", 2D) = "white" {}
		[NoScaleOffset] _Color_Gradient ("Color Gradient", 2D) = "white" {}
		[NoScaleOffset] _IconTexture ("IconTexture", 2D) = "black" {}
		_BreakAmount ("Break Amount", Float) = 1
		[NoScaleOffset] _RockTile ("RockTile", 2D) = "white" {}
		_Color ("Color", Vector) = (1,1,1,1)
		_GoldOverflowValue ("GoldOverflowValue", Range(0, 2)) = 1
		_GoldOverflowBlend01 ("GoldOverflowBlend01", Range(0, 1)) = 0
		_PassoverTime ("PassoverTime", Range(0, 1)) = 0
		_PassoverGlowPow ("PassoverGlowPow", Float) = 1
		_OutlineColor ("OutlineColor", Vector) = (0.4901961,0.1960784,0.07058824,0)
		[ToggleUI] _Break_Tile_Icon ("Break Tile Icon", Float) = 0
		_GoldOverglowColor ("GoldOverglowColor", Vector) = (1,0.7533744,0,1)
		_GoldOverglowIconBurnColor ("GoldOverglowIconBurnColor", Vector) = (0.7924528,0.1621504,0,1)
		_TileBreakShadowColor ("TileBreakShadowColor", Vector) = (0.3647059,0.5176471,0.8156863,1)
		[NoScaleOffset] _Texture2DAsset_748bb12b4cf941cbb5073e68f14a0a1d_Out_0_Texture2D ("Texture2D", 2D) = "white" {}
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