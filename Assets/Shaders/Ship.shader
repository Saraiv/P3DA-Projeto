Shader "Custom/Ship"{
    Properties{
        _Largura ("Square Size", Range(0,1)) = 0.1
        _Cor ("Square Color", Color) = (1,1,1,1)
        _Position ("Position", Vector) = (0,0,0,0)
    }
    SubShader{
        Tags { "RenderType"="Opaque" }
        Blend SrcAlpha OneMinusSrcAlpha
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

            float _Largura;
            float4 _Cor;
            float4 _Position;

            v2f vert (appdata v){
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            int isInsideSquare(float2 center, float lado, float2 ponto){
                if(ponto.x > center.x - lado && ponto.x < center.x + lado && 
                   ponto.y > center.y - lado && ponto.y < center.y + lado){
                    return 1;
                }else{
                    return 0;
                }
            }

            fixed4 frag (v2f i) : SV_Target{                
                if (isInsideSquare(_Position, _Largura, i.worldPos.xy)){
                    return fixed4(0, 0, 0, 0);
                }
                
                return _Cor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}