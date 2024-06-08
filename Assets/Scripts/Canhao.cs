using UnityEngine;

public class Canhao : MonoBehaviour{
    public float speed = 1000.0f;
    public KeyCode fireKey = KeyCode.Space;
    private Rigidbody rb;

    void Start() {
        rb = GetComponent<Rigidbody>();
        rb.useGravity = false;
    }

    void Update() {
        if (Input.GetKeyDown(fireKey)){
            Fire();
        }
    }

    void Fire() {
        rb.useGravity = true;
        rb.velocity = transform.forward * speed;
    }
}