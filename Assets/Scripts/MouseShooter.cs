using UnityEngine;

public class MouseShooter : MonoBehaviour
{
    public enum MouseButton { None = -1, Left = 0, Right = 1, Middle = 2 }

    [SerializeField, Tooltip("Mouse button to shot.")]
    private MouseButton mouseButton;

    [SerializeField, Tooltip("Fire rate.")]
    private float timeBtwAttack;

    [SerializeField, Tooltip("Animator component")]
    private Animator animator;

    [SerializeField, Tooltip("Basic attack animation")]
    private string basicAttack;

    private float nextAttack;

    void Update()
    {
        if ((Input.GetMouseButtonDown((int)mouseButton) && mouseButton != MouseButton.None) && 
            Time.time >= nextAttack)
        {
            animator.SetTrigger(basicAttack);
            nextAttack = Time.time + timeBtwAttack;
        }
    }
}
