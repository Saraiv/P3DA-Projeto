using Unity.VisualScripting;
using UnityEngine;

public class PostProcSinCityVerde : MonoBehaviour{
    public Material mat;
    [HideInInspector]
    public float secondTimer;
    [HideInInspector]
    public bool finished;

    public void Start(){
        secondTimer = 0;
        mat.SetFloat("_SliderTransition", -0.01f);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest){
        Graphics.Blit(src, dest, mat);
    }

    void Update(){
        if(Input.GetKeyDown(KeyCode.T)){
            finished = true;
        }

        if(finished){
            secondTimer += Time.deltaTime;
            mat.SetFloat("_SliderTransition", secondTimer / 5);
        }
    }
}
