Shader "Custom/Bola"{
    Properties{     
        _Cor1("Cor 1", Color) = (1,0,0,1)
        _Cor2("Cor 2", Color) = (0,1,0,1)
        _Cor3("Cor 3", Color) = (0,0,1,1)
        _MainTex("Texture", 2D) = "white" {}
        _NoiseTex("Noise Texture", 2D) = "white" {}
        _NoiseSpeed("Noise Speed", Float) = 1
    }

    SubShader{
     Cull off
        CGPROGRAM
        #pragma surface surf Lambert

        struct Input{
            float3 viewDir;
            float2 uv_MainTex;
        };

        half4 _Cor1;
        half4 _Cor2;
        half4 _Cor3;
        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _NoiseSpeed;

        void surf(Input IN, inout SurfaceOutput o) {
            float dotP = dot(o.Normal, normalize(IN.viewDir));
            float noise = tex2D(_NoiseTex, IN.uv_MainTex + _Time.y * _NoiseSpeed).r;
            if(dotP > 0.6){
                o.Albedo = mul(tex2D(_MainTex, IN.uv_MainTex), _Cor3) * (noise * _Cor1);
            }else{
                float transition = smoothstep(0.3, 0.6, dotP);
                half4 interpolatedColor = lerp(_Cor2, _Cor1, transition);
                o.Albedo = interpolatedColor * noise;
            }
        }

        ENDCG
    }
    FallBack "Diffuse"
}