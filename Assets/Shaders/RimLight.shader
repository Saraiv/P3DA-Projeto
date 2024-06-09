Shader "Custom/RimLight"{
    Properties{
        _Cor ("Cor", Color) = (1, 1, 1, 1)
        _Cor2 ("Cor", Color) = (1, 1, 1, 1)
        _RimIntensity ("Rim Intensity", Range (0, 1)) = 0
        _RimPower ("Rim Power", Range (0, 5)) = 1
    }

    SubShader{
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert alpha

        struct Input{
            float3 viewDir;
            float3 worldNormal;
        };
        
        fixed4 _Cor;
        fixed4 _Cor2;
        float _RimIntensity;
        float _RimPower;

        float4 rimLight(float4 color, float3 normal, float3 viewDirection){
            float NdotV = 1 - dot(normal, viewDirection);
            NdotV = pow(NdotV, _RimPower);
            NdotV *= _RimIntensity;
            float4 finalColor = lerp(color, _Cor, NdotV);
            return finalColor;
        }

        void surf (Input IN, inout SurfaceOutput o){
            fixed4 col = _Cor;
            o.Normal = normalize(o.Normal);
            IN.viewDir = normalize(IN.viewDir);
            col = rimLight(col, o.Normal, IN.viewDir);
            o.Albedo = col.rgb;
            o.Alpha = _RimIntensity;
            o.Emission = _Cor2.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
