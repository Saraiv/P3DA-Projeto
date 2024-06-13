Shader "Unlit/PortalBack"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (1,1,1,1)
    }
    SubShader{
        Cull Back
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            fixed4 _Color2;

            float randomNoise(float2 p){
                return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453123);
            }

            float BINoise(float2 p){
                float tiles = 50.0;

                float2 base = floor(p / tiles);
                p = frac(p / tiles);
                float2 f = smoothstep(0.0, 1.0, p);

                float q11 = randomNoise(base);
                float q12 = randomNoise(float2(base.x, base.y + 1.0));
                float q21 = randomNoise(float2(base.x + 1.0, base.y));
                float q22 = randomNoise(float2(base.x + 1.0, base.y + 1.0));

                float r1 = lerp(q11, q21, f.x);
                float r2 = lerp(q12, q22, f.x);

                return lerp(r1, r2, f.y);
            }

            float2 gradn(float2 p){
                float ep = 0.09;
                float gradx = BINoise(float2(p.x + ep, p.y)) - BINoise(float2(p.x - ep, p.y));
                float grady = BINoise(float2(p.x, p.y + ep)) - BINoise(float2(p.x, p.y - ep));
                return float2(gradx, grady);
            }

            float2x2 makeRotM2(float theta){
                float c = cos(theta);
                float s = sin(theta);
                return float2x2(c, -s, s, c);
            }

            float perlinNoise(float2 p){
                float t = _Time.w * 3.0;
                float a = 0.5;
                float total = 0.0;
                float2 bp = p;

                for (int i = 1; i < 7; ++i){
                    p += t * 1.6;
                    bp -= t * 2.6;
                    
                    float2 gr = gradn(i * p * 0.34 + t) * 100.0;
                    
                    gr = mul(makeRotM2(i * t * 0.05 + 0.8), gr);
                    
                    p += gr;
                    
                    total += (sin(BINoise(p) * 7.0) * 0.5 + 0.5) * a;
                    
                    p = lerp(bp, p, 0.77);
                    
                    a *= 0.75;
                    p *= 2.0;
                    bp *= 1.5;
                }
                return total;
            }

            v2f vert (appdata v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target{
                float t = _Time.w * 1.2;

                float2 d1 = float2(t, t * 0.5);
                float2 d2 = float2(t * 2.0, t * -4.0);
                float2 d3 = float2(t * -6.0, t * 8.0);

                float p1 = perlinNoise(i.vertex.xy - d1);
                float p2 = perlinNoise(i.vertex.xy + d2);
                float p3 = perlinNoise(i.vertex.xy - d3);

                float pn = lerp(p1, p2, p3);  
                    
                float3 color1 = _Color.rgb;
                float3 color2 = _Color2.rgb;

                return float4(lerp(color1, color2, pn), 1.0);
            }
            ENDCG
        }
    }
}
