Shader "Custom/Sails"{
    Properties{
        _MainTex ("Texture", 2D) = "white" {}
        _Color1 ("Color", Color) = (1,1,1,1)
        _Color2 ("Color2", Color) = (1,1,1,1)
        _WindStrength ("Wind Strength", Range(0,1)) = 0.5
        _WindSpeed ("Wind Speed", Range(0,10)) = 1.0
        _WindDirection ("Wind Direction", Vector) = (1, 0, 0)
    }
    SubShader{
        Cull Off
        CGPROGRAM
        #pragma surface surf Lambert alpha vertex:vert
        
        struct Input{
            float3 viewDir;
            float3 worldPos;
            float3 vertex : POSITION;
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        half _WindStrength;
        half _WindSpeed;
        float3 _WindDirection;
        half4 _Color1;
        half4 _Color2;
        sampler2D _GlitchTex;

        void vert (inout appdata_full v, out Input o){
            // tencnica de vertex displacement
            float time = _Time.y * _WindSpeed;
            float windEffect = sin(dot(v.vertex.xy, _WindDirection.xy) + time) * _WindStrength;
            v.vertex.xyz += windEffect * _WindDirection;

             UNITY_INITIALIZE_OUTPUT(Input, o);
            o.worldPos = mul(UNITY_MATRIX_M, v.vertex).xyz;
        }

        void surf (Input IN, inout SurfaceOutput o){
            float2 glitchUV = IN.uv_MainTex + float2(_Time.w / 2, _Time.w / 2);
            float2 glitch = tex2D(_GlitchTex, glitchUV);
            float2 uv = IN.uv_MainTex + glitch * 0.1;
            fixed4 tex = tex2D(_MainTex, uv);
            fixed4 col = _Color1 * tex;
            col.a = 0.1;

            float fresnel = pow(1.0 - dot(normalize(IN.worldPos), float3(0, 0, 1)), 1.5);
            fixed4 rimColor = _Color2 * fresnel;
            rimColor.a = 0.5;

            o.Albedo = (col + rimColor).rgb;
            o.Alpha = (col + rimColor).a;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
