using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Tutorial : MonoBehaviour
{
    [SerializeField]
    private Animator animator;

    [SerializeField]
    private string[] parametersAnimation;

    public void NextAnimation() => animator.SetTrigger(parametersAnimation[0]);

    public void CloseAnimation() => animator.SetBool(parametersAnimation[1], true);
}
