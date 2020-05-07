﻿using UnityEngine;
using UnityEngine.SceneManagement;

namespace Game.Scene
{
    public class UIManagement : MonoBehaviour
    {
        private const int MAIN_MENU_SCENE = 0;

        public void Load(string scene) => FixTimeWhenSceneEndsLoading(SceneManager.LoadSceneAsync(scene));

        public void Exit() => Application.Quit();

        public void GoToMenu()
            => FixTimeWhenSceneEndsLoading(SceneManager.LoadSceneAsync(MAIN_MENU_SCENE)).completed += (_) => Destroy(Camera.main.gameObject);

        private AsyncOperation FixTimeWhenSceneEndsLoading(AsyncOperation asyncOperation)
        {
            asyncOperation.completed += (_) => Time.timeScale = 1;
            return asyncOperation;
        }
    }
}