Shader "Unlit/Canhao"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
        _Cor ("Cor", Color) = (1,1,1,1)
        _Cor2 ("Cor2", Color) = (1,1,1,1)
        _PulseSpeed ("Potência", Range(0, 5)) = 1.0
        _MinScale ("Scale minima", Range(0, 5)) = 0.8
        _MaxScale ("Scale maxima", Range(0, 5)) = 1.2
    }
    SubShader{
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
                float3 worldPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _Cor;
            half4 _Cor2;
            float _PulseSpeed;
            float _MinScale;
            float _MaxScale;

            v2f vert (appdata v){
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
                float scale = lerp(_MinScale, _MaxScale, (sin(_Time.w * _PulseSpeed) + 1.0) / 2.0);
                float4 pos = v.vertex;
                if(o.worldPos.z >= -15){ // Tentativa erro
                    pos.z *= scale;
                }
                o.vertex = UnityObjectToClipPos(pos);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target{
                fixed4 col = tex2D(_MainTex, i.uv) * _Cor;
                // if(i.worldPos.z >= -13.8){
                //     col = lerp(_Cor, _Cor2, (sin(_Time.w * _PulseSpeed) + 1.0) / 2.0);
                // }
                return col;
            }
            ENDCG
        }
    }
}
