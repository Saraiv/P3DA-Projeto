Shader "Custom/WaterShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _NormalTexture1 ("Normal texture 1", 2D) = "bump" {}
        _NormalTexture2 ("Normal texture 2", 2D) = "bump" {}
        _Alpha ("Alpha", Range(0, 1)) = 1
        _NormalStrength ("Normal Strength", Range(0, 1)) = 0.5
    }
    SubShader{
        CGPROGRAM
        #pragma surface surf Lambert alpha

        sampler2D _NormalTexture1;
        sampler2D _NormalTexture2;
        sampler2D _CameraDepthTexture;

        float _NormalStrength;
        float _Alpha;
        fixed4 _Color;

        struct Input{
            float2 uv_NormalTexture1;
            float2 uv_NormalTexture2;
            float4 screenPos;
        };

        void surf (Input IN, inout SurfaceOutput o){
            fixed4 col = _Color;

            float normalUVX = IN.uv_NormalTexture1.x + sin(_Time) * 5;
            float normalUVY = IN.uv_NormalTexture1.y + sin(_Time) * 5;

            float2 normalUV1 = float2(normalUVX, IN.uv_NormalTexture1.y);
            float2 normalUV2 = float2(IN.uv_NormalTexture2.x, normalUVY);

            o.Normal = UnpackNormal((tex2D(_NormalTexture1, normalUV1) + tex2D(_NormalTexture2, normalUV2)) * _NormalStrength);
            o.Alpha = _Alpha;
            o.Albedo = col;
        }
        ENDCG
    }
    FallBack "Diffuse"
}