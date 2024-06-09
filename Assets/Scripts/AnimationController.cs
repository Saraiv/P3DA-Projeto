using System;
using System.Collections;
using UnityEngine;

public class AnimationController : MonoBehaviour{
    public Animator animator;
    public GameObject deadPirate;

    void Start(){
        animator = GetComponent<Animator>();
        
    }

    bool isAnimationStatePlaying(Animator anim, int animLayer, string stateName){
        if (anim.GetCurrentAnimatorStateInfo(animLayer).IsName(stateName) &&
                anim.GetCurrentAnimatorStateInfo(animLayer).normalizedTime < 1.0f)
            return true;
        else
            return false;
    }

    // Update is called once per frame
    void Update(){
        if (!isAnimationStatePlaying(animator, 0, "Dying")){
            Debug.Log("Dying finished playing");
            deadPirate.SetActive(true);
        }
    }
}
