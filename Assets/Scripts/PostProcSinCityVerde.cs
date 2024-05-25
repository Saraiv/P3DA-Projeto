using UnityEngine;

public class PostProcSinCityVerde : MonoBehaviour{
    public Material mat;

    void OnRenderImage(RenderTexture src, RenderTexture dest){
        Graphics.Blit(src, dest, mat);
    }
}
