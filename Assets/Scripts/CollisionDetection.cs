using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionDetection : MonoBehaviour{
    public Material mat;
    [HideInInspector]
    public Vector3 position;
    [HideInInspector]
    public float timer, secondTimer;
    [HideInInspector]
    public bool finished;

    public void Start(){
        mat.SetVector("_Position", new Vector3(0, 0, 0));
        mat.SetFloat("_GlowRange", 0.0f);
        mat.SetFloat("_GlowFalloff", 0.0f);
        mat.SetFloat("_DissolveAmount", 0.0f);
        finished = false;
        timer = 0;
        secondTimer = 0;
    }
    
    void Update(){
        if(finished){
            secondTimer += Time.deltaTime;
            Debug.Log(secondTimer);
            mat.SetFloat("_DissolveAmount", secondTimer);
        }
    }
    
    void OnTriggerEnter(Collider collision) {
        mat.SetFloat("_GlowRange", 0.014f);
        mat.SetFloat("_GlowFalloff", 0.136f);
        mat.SetVector("_Position", new Vector3(collision.transform.position.x, collision.transform.position.y, 0));
        finished = true;
    }


}
