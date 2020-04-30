using Enderlook.Unity.Prefabs.HealthBarGUI;

using System.Collections;

using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game.Scene
{
    public class MainMenu : MonoBehaviour
    {
        [SerializeField]
        private Scenes scenes;

        [SerializeField]
        private int hudScene;

        [SerializeField]
        private HealthBar loadingProgress;

        [SerializeField]
        private GameObject panel;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        public void Awake()
        {
            GameObject core = GameObject.Find("Core");
            if (core != null)
                Destroy(core);
        }

        public void InitializeGame()
        {
            UnityEngine.SceneManagement.Scene current = SceneManager.GetActiveScene();

            AsyncOperation hud = SceneManager.LoadSceneAsync(hudScene, LoadSceneMode.Additive);
            AsyncOperation level = SceneManager.LoadSceneAsync(scenes.GetScene(), LoadSceneMode.Additive);

            level.completed += (_) =>
            {
                SceneManager.UnloadSceneAsync(current);
                SceneManager.UnloadSceneAsync(hudScene);
            };

            panel.SetActive(false);

            loadingProgress.gameObject.SetActive(true);
            loadingProgress.ManualUpdate(0, 1);

            StartCoroutine(Loading(level));
        }

        private IEnumerator Loading(AsyncOperation asyncOperation)
        {
            while (!asyncOperation.isDone)
            {
                loadingProgress.UpdateValues(asyncOperation.progress * 100);
                yield return null;
            }
        }
    }
}