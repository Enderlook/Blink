using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UIManagement : MonoBehaviour
{
    public void Load(string scene) => SceneManager.LoadSceneAsync(scene);

    public void Restart() => Load(SceneManager.GetActiveScene().name);

    public void Exit() => Application.Quit();
}
