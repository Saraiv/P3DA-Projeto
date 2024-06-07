Shader "Custom/Sails"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _WindStrength ("Wind Strength", Range(0,1)) = 0.5
        _WindSpeed ("Wind Speed", Range(0,10)) = 1.0
        _WindDirection ("Wind Direction", Vector) = (1, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert

        sampler2D _MainTex;
        fixed4 _Color;
        half _WindStrength;
        half _WindSpeed;
        float3 _WindDirection;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        void vert (inout appdata_full v)
        {
            // tencnica de vertex displacement
            float time = _Time.y * _WindSpeed;
            float windEffect = sin(dot(v.vertex.xy, _WindDirection.xy) + time) * _WindStrength;
            v.vertex.xyz += windEffect * _WindDirection;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
