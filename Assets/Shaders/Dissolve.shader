Shader "Custom/Dissolve"{
    Properties{
        _Color ("Color", Color) = (1,1,1,1)
        _Emission ("Emission", color) = (0,0,0)

        _DissolveTex ("Dissolve Texture", 2D) = "white" {}
        _DissolveAmount ("Dissolve Amount", Range(0, 1)) = 0.5

        _GlowColor("Glow Color", Color) = (1, 1, 1, 1)
        _GlowRange("Glow Range", Range(0, .3)) = 0.1
        _GlowFalloff("Glow Falloff", Range(0.001, .3)) = 0.1

        _Position ("Position", Vector) = (1,1,1,0)
        _Largura ("Largura", Range (-2, 2)) = 0
    }
    SubShader{
        Cull off
        Tags{ "IgnoreProjector" = "True" "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input{
            float2 uv_DissolveTex;
            float3 worldPos;
        };

        fixed4 _Color;
        fixed4 _Emission;
        sampler2D _DissolveTex;
        float _DissolveAmount;

        float3 _GlowColor;
        float _GlowRange;
        float _GlowFalloff;

        float3 _Position;
        float _Largura;

        bool isInsideSquare(float3 worldP, float3 pontT, float rang){
            return (worldP.y > pontT.y -rang &&  worldP.y < pontT.y  + rang
            && worldP.x > pontT.x -rang &&  worldP.x < pontT.x  + rang);
        }

        bool isInsideCircle(float3 worldP, float3 pointT, float radius) {
            float dx = worldP.x - pointT.x;
            float dy = worldP.y - pointT.y;
            float distanceSquared = dx * dx + dy * dy;
            float radiusSquared = radius * radius;

            return distanceSquared <= radiusSquared;
        }

        void surf(Input IN, inout SurfaceOutput o){
            float3 base = tex2D(_DissolveTex, IN.uv_DissolveTex);
            if(isInsideCircle(IN.worldPos, _Position, _Largura)){
                o.Alpha = 0;
            }else{
                float isVisible = base - _DissolveAmount;
                clip(isVisible);

                float isGlowing = smoothstep(_GlowRange + _GlowFalloff, _GlowRange, isVisible);
                float3 glow = isGlowing * _GlowColor;

                o.Albedo = _Color;
                o.Emission = _Emission + glow;
                o.Alpha = 1;
            }
            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
