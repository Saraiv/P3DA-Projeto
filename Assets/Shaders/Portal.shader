Shader "Unlit/Portal"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            float colormap_red(float x) {
                if (x < 0.0) {
                    return 54.0 / 255.0;
                } else if (x < 20049.0 / 82979.0) {
                    return (829.79 * x + 54.51) / 255.0;
                } else {
                    return 1.0;
                }
            }

            float colormap_green(float x) {
                if (x < 20049.0 / 82979.0) {
                    return 0.0;
                } else if (x < 327013.0 / 810990.0) {
                    return (8546482679670.0 / 10875673217.0 * x - 2064961390770.0 / 10875673217.0) / 255.0;
                } else if (x <= 1.0) {
                    return (103806720.0 / 483977.0 * x + 19607415.0 / 483977.0) / 255.0;
                } else {
                    return 1.0;
                }
            }

            float colormap_blue(float x) {
                if (x < 0.0) {
                    return 54.0 / 255.0;
                } else if (x < 7249.0 / 82979.0) {
                    return (829.79 * x + 54.51) / 255.0;
                } else if (x < 20049.0 / 82979.0) {
                    return 127.0 / 255.0;
                } else if (x < 327013.0 / 810990.0) {
                    return (792.02249341361393720147485376583 * x - 64.364790735602331034989206222672) / 255.0;
                } else {
                    return 1.0;
                }
            }

            float4 colormap(float x) {
                return float4(colormap_red(x), colormap_green(x), colormap_blue(x), 1.0);
            }

            float rand(float2 n) { 
                return frac(sin(dot(n, float2(12.9898, 4.1414))) * 43758.5453);
            }

            float noise(float2 p){
                float2 ip = floor(p);
                float2 u = frac(p);
                u = u * u * (3.0 - 2.0 * u);

                float res = lerp(
                    lerp(rand(ip), rand(ip + float2(1.0,0.0)), u.x),
                    lerp(rand(ip + float2(0.0, 1.0)), rand(ip + float2(1.0, 1.0)), u.x), u.y);
                return res * res;
            }

            const float2x2 mtx = float2x2( 0.80,  0.60, -0.60,  0.80 );

            float fbm( float2 p ){
                float f = 0.0;

                f += 0.500000 * noise( p + (_Time.w));
                p = mul(mtx, p) * 2.02;
                f += 0.031250 * noise( p );
                p = mul(mtx, p) * 2.01;
                f += 0.250000 * noise( p );
                p = mul(mtx, p) * 2.03;
                f += 0.125000 * noise( p );
                p = mul(mtx, p) * 2.01;
                f += 0.062500 * noise( p );
                p = mul(mtx, p) * 2.04;
                f += 0.015625 * noise( p + sin(_Time.w) );

                return f / 0.96875;
            }

            float pattern( in float2 p ){
                return fbm( p + fbm( p + fbm( p ) ) );
            }

            v2f vert (appdata v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target{
                float2 uv = i.vertex / _ScreenParams.x;
                float shade = pattern(uv);
                return float4(colormap(shade).rgb, shade);
            }
            ENDCG
        }
    }
}
