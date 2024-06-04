Shader "Custom/Dissolve"{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
        _Emission ("Emission", color) = (0,0,0)

        _DissolveTex ("Dissolve Texture", 2D) = "white" {}
        _DissolveAmount ("Dissolve Amount", Range(0, 1)) = 0.5

        _GlowColor("Glow Color", Color) = (1, 1, 1, 1)
        _GlowRange("Glow Range", Range(0, .3)) = 0.1
        _GlowFalloff("Glow Falloff", Range(0.001, .3)) = 0.1
    }
    SubShader{
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input{
            float2 uv_DissolveTex;
        };

        fixed4 _Color;
        fixed4 _Emission;
        sampler2D _DissolveTex;
        float _DissolveAmount;

        float3 _GlowColor;
        float _GlowRange;
        float _GlowFalloff;

        void surf(Input IN, inout SurfaceOutput o){
            float dissolve = tex2D(_DissolveTex, IN.uv_DissolveTex).r;
            // dissolve = dissolve;
            float isVisible = dissolve - _DissolveAmount;
            clip(isVisible);

            float isGlowing = smoothstep(_GlowRange + _GlowFalloff, _GlowRange, isVisible);
            float3 glow = isGlowing * _GlowColor;

            o.Albedo = _Color;
            o.Emission = _Emission + glow;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
