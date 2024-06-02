Shader "Custom/Freznel"{
    Properties{    
        _Cor ("Cor", Color) = (1,0,0,0)
        _Cor2 ("Cor2", Color) = (0, 1, 0, 0)
        _NoiseTex ("Noise Texture", 2D) = "white" {}
    }

    SubShader{
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert alpha


        struct Input{
            float3 viewDir;
            float3 worldPos;
            float2 uv_NoiseTex;
        };


        float _Slider;
        half3 _Cor;
        half3 _Cor2;
        sampler2D _NoiseTex;

        void surf(Input IN, inout SurfaceOutput o){
            float dotP = dot(normalize(IN.viewDir), normalize(o.Normal));
            float dotPos = dot(normalize(IN.worldPos), IN.viewDir);

            float2 uv = IN.uv_NoiseTex + _Time.w * 0.01;
            float noise = tex2D(_NoiseTex, uv);
            
            o.Alpha = pow(frac(dotP), 4) * noise * abs(_SinTime.w);
            o.Albedo = _Cor * saturate(dotPos); //floor saturate trunc
            o.Emission = _Cor2; // * (1 - dotP);
        }
        ENDCG
    }
    FallBack "Diffuse"
}