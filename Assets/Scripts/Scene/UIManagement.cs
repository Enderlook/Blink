using System.Collections;

using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game.Scene
{
    public class UIManagement : MonoBehaviour
    {
        private const int MAIN_MENU_SCENE = 0;

        public void Load(string scene) => SceneManager.LoadSceneAsync(scene);

        public void Restart() => Load(SceneManager.GetActiveScene().name);

        public void Exit() => Application.Quit();

        public void GoToMenu()
            => SceneManager.LoadSceneAsync(MAIN_MENU_SCENE).completed += (_) => Destroy(Camera.main.gameObject);
    }
}