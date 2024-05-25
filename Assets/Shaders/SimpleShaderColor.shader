Shader "Custom/SimpleShaderColor"{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
    }
    
    SubShader{
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input{
            float2 uv_MainTex;
        };
        
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o){
            o.Albedo = _Color;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
