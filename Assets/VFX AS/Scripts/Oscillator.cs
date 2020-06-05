using UnityEngine;

public class Oscillator : MonoBehaviour
{
    [SerializeField]
    private float time = 0;

    private float smooth;

    private void Update()
    {
        smooth = Time.deltaTime * time;
        transform.Rotate(Vector3.up * smooth);
    }
}
