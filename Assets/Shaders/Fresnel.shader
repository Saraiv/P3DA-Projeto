Shader "Custom/Freznel"{
    Properties{
        _Cor ("Cor", Color) = (1,0,0,0)
        _Cor2 ("Cor2", Color) = (0, 1, 0, 0)
    }

    SubShader{
        Cull off
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert alpha


        struct Input{
            float3 viewDir;
            float3 worldPos;
        };


        float _Slider;
        half3 _Cor;
        half3 _Cor2;

        void surf(Input IN, inout SurfaceOutput o){
            float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));
            float dotPos = dot(normalize(IN.worldPos), IN.viewDir);
            
            o.Alpha = pow(frac(dotP), 4);
            o.Albedo = _Cor * saturate(dotPos);
            o.Emission = _Cor2 * dotP;
        }
        ENDCG
    }
    FallBack "Diffuse"
}