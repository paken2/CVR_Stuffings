Shader "Neitri/Debug/World Rotation Gizmo"
{
	Properties
	{
		_MainTex ("_MainTex", 2D) = "white" {}
	}
	SubShader
	{
		Blend SrcAlpha OneMinusSrcAlpha
		Tags { "RenderType"="Opaque" "Queue"="Transparent" "IgnoreProjector"="True" }

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
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID  // inserted by FixShadersRightEye.cs
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 color : TEXCOORD1;
				UNITY_VERTEX_OUTPUT_STEREO  // inserted by FixShadersRightEye.cs
			};
			
			sampler2D _MainTex;

			v2f vert (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);  // inserted by FixShadersRightEye.cs
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);  // inserted by FixShadersRightEye.cs

				float4 worldPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
				float4 scale = mul(unity_ObjectToWorld, normalize(float4(1, 1, 1, 0)));

				worldPos.xyz += v.vertex.xyz * length(scale.xyz);

				o.pos = mul(UNITY_MATRIX_VP, worldPos);
				o.uv = v.uv;
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				if (dot(i.color,1) > 3.5)
				{
					fixed4 col = tex2D(_MainTex, i.uv);
					clip(col.a-0.05);
					return col;
				}
				else
				{
					return i.color;
				}
			}
			ENDCG
		}
	}

	Fallback Off
}


