Shader "Unlit/SinCityVerde"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
        _Slider ("Slider", Range(0,1)) = 0.5
    }

    SubShader{
        Cull Off ZWrite Off ZTest Always

        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata{
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f{
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float _Slider;

            fixed4 frag (v2f i) : SV_Target{
                fixed4 col = tex2D(_MainTex, i.uv);
                if(col.g > col.r + _Slider && col.g > col.b + _Slider){
                    col.rgb = float3(((col.r + col.b) / 3), col.g, ((col.r + col.b) / 3));
                }else{
                    col.rgb = float3((col.r+col.g+col.b)/3,(col.r+col.g+col.b)/3,(col.r+col.g+col.b)/3);
                }
                return col;
            }
            ENDCG
        }
    }
}