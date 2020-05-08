using Enderlook.Unity.Prefabs.HealthBarGUI;

using Game.Scene.CLI;

using System.Collections;

using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game.Scene
{
    public class MainMenu : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField]
        private Scenes scenes;

        [SerializeField]
        private int hudScene;

        [SerializeField]
        private HealthBar loadingProgress;

        [SerializeField]
        private GameObject panel;

        [SerializeField, Tooltip("Key pressed to disable console.")]
        private KeyCode disableConsole;
#pragma warning restore CS0649

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        public void Awake()
        {
            GameObject core = GameObject.Find("Core");
            if (core != null)
                Destroy(core);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (Input.GetKeyDown(disableConsole) && Console.IsConsoleEnabled)
                Console.IsConsoleEnabled = false;
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