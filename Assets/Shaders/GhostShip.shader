Shader "Custom/GhostShip" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (1,1,1,1)
        _GlitchTex ("Glitch Texture", 2D) = "white" {}
    }
    SubShader{
        Tags { "RenderType"="Transparent" }
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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _GlitchTex;
            fixed4 _Color;
            fixed4 _Color2;

            v2f vert (appdata v){
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float2 glitchUV = i.uv + float2(_Time.w / 2, _Time.w / 2); // Add time-dependent offset
                float2 glitch = tex2D(_GlitchTex, glitchUV); // Use red and green channels for glitch
                float2 uv = i.uv + glitch * 0.1; // Displace UV coordinates
                fixed4 tex = tex2D(_MainTex, uv); // Sample main texture with displaced UVs
                fixed4 col = _Color * tex;
                col.a = 0.1;

                // Add Fresnel rim light
                float fresnel = pow(1.0 - dot(normalize(i.vertex.xyz), float3(0, 0, 1)), 1.5);
                fixed4 rimColor = _Color2 * fresnel;
                rimColor.a = 0.5; // Make rim light fully opaque

                return col + rimColor;
            }
            ENDCG
        }
    }
}