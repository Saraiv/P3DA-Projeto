Shader "Custom/RimLight"{
    Properties{
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Color2 ("Color", Color) = (1, 1, 1, 1)
        _Slider ("Slider", Range(0.0019, 0.1)) = 0
    }

    SubShader{
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input{
            float3 viewDir;
        };
        
        fixed4 _Color;
        fixed4 _Color2;
        float _Slider;

        void surf (Input IN, inout SurfaceOutput o){
            float dotp =  dot(normalize(IN.viewDir), normalize(o.Normal));
            
            float effect = pow(_Slider * (1 - dotp), 1 - dotp);
            o.Alpha = _Slider;
            o.Albedo = _Color;
            o.Emission = (_Color2 * effect) / _Slider;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
