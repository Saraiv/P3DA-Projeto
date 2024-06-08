Shader "Custom/Ship"{
    Properties{     
        _MainTex ("Main Texture", 2D) = "defaulttexture" {}   
        _Position ("Position", Vector) = (1,1,1,0)
        _Largura ("Largura", Range (-2, 2)) = 0
        _Cor ("Cor", Color) = (1,1,1,1)
    }

    SubShader{
        Cull off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
        };

        sampler2D _MainTex;
        half4 _Cor;
        float3 _Position;
        float _Largura;

        bool isInsideSquare(float3 worldP, float3 pontT, float rang){
            return (worldP.y > pontT.y -rang &&  worldP.y < pontT.y  + rang
            && worldP.x > pontT.x -rang &&  worldP.x < pontT.x  + rang);
        }

        bool isInsideSphere(float3 worldP, float3 center, float radius) {
            return distance(worldP, center) < radius;
        }


        void surf(Input IN, inout SurfaceOutput o) {
            float3 base = tex2D(_MainTex, IN.uv_MainTex);

            if(isInsideSquare(IN.worldPos, _Position, _Largura)){
                o.Albedo = base;
                o.Alpha = 0;
            }else{
                o.Albedo = _Cor;
                o.Alpha = 1;
            }
        }

        ENDCG
    }
    FallBack "Diffuse"
}