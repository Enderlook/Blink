using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game.Scene
{
    public class UIManagement : MonoBehaviour
    {
        public void Load(string scene) => SceneManager.LoadSceneAsync(scene);

        public void Restart() => Load(SceneManager.GetActiveScene().name);

        public void Exit() => Application.Quit();

        public void GoToMenu() => Load("Menu");
    }
}