
using System.Collections;
using System.Collections.Generic;

using UnityEngine;

namespace AvalonStudios.VFX
{
    public class DestroyObjects
    {
        public IEnumerator DestroyObject(float waitTime, Transform transform, GameObject gameObject)
        {
            if (transform.childCount > 0 && waitTime != 0)
            {
                List<Transform> transforms = new List<Transform>();

                foreach (Transform t in transform.GetChild(0).transform)
                    transforms.Add(t);

                while (transform.GetChild(0).localScale.x > 0)
                {
                    yield return new WaitForSeconds(0.01f);
                    Vector3 newScale = new Vector3(.1f, .1f, .1f);
                    transform.GetChild(0).localScale -= newScale;
                    foreach (Transform t in transforms)
                        t.localScale -= newScale;
                }
            }

            yield return new WaitForSeconds(waitTime);
            Object.Destroy(gameObject);
        }
    }
}
