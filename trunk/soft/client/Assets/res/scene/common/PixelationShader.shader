Shader "Custom/PixelationShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_PixelSize("Pixel Size", Range(32, 256)) = 256
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _PixelSize;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col;

				float ratioX = (int)(i.uv.x * _PixelSize) / _PixelSize;
				float ratioY = (int)(i.uv.y * _PixelSize) / _PixelSize;

				col = tex2D(_MainTex, float2(ratioX, ratioY));

				if (col.a < 0.5)
				{
					col.a = 0;
				}

				return col;
			}
			ENDCG
		}
	}
}