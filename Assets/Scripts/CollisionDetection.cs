using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CollisionDetection : MonoBehaviour{
    public Material mat;
    public Vector3 position;

    public void Start(){
        mat.SetVector("_Position", new Vector3(0, 0, 0));
    }
    
    void OnTriggerEnter(Collider collision) {
        Debug.Log("Entrou " + collision.transform.position);
        mat.SetVector("_Position", new Vector3(collision.transform.position.x, collision.transform.position.y, 0));
    }
}
