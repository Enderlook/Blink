
using System;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace Game.Scene.CLI
{
    public class Console : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Console that can be hidden.")]
        private GameObject console;

        [SerializeField, Tooltip("Were all logs are stored.")]
        private RectTransform content;

        [SerializeField, Tooltip("Text used as input.")]
        private Text inputText;

        [SerializeField, Tooltip("Input field.")]
        private InputField inputField;

        [SerializeField, Tooltip("Key used to execute command.")]
        private KeyCode introCode;

        [SerializeField, Tooltip("Key used to open console.")]
        private KeyCode openConsole;

        [SerializeField, Tooltip("Prefab used for console logs.")]
        private GameObject logPrefab;

        [SerializeField, Tooltip("Scroll rect of logs.")]
        private ScrollRect scrollRect;
#pragma warning restore CS0649

        private EventSystem eventSystem;

        private int logLength = 10;

        private Dictionary<(string command, int parameters), Action<string[]>> commands;

        private CommandsPack commandsPack;

        private bool cleaning;

        private static Console instance;

        public static bool IsConsoleEnabled {
            get => instance.console.activeSelf;
            set => instance.console.SetActive(value);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            // Avoid being instanced several times if player go to Main Menu several times.
            if (instance == null)
                instance = this;
            else
                Destroy(gameObject);

            eventSystem = FindObjectOfType<EventSystem>();

            commands = new Dictionary<(string command, int parameters), Action<string[]>>()
            {
                { ("log", 0), LogAmount0 },
                { ("log", 1), LogAmount1 },
                { ("exit", 0), Exit },
                { ("close", 0), Close },
                { ("help", 0), Help },
                { ("clear", 0), Clear },
            };
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (!console.activeSelf && Input.GetKeyDown(openConsole))
            {
                console.SetActive(true);
                eventSystem.SetSelectedGameObject(inputField.gameObject, null);
            }
            else if (Input.GetKeyDown(introCode))
                Accept();

            if (content.childCount > logLength)
                Destroy(content.GetChild(0).gameObject);

            if (cleaning)
            {
                while (content.childCount > 0)
                    Destroy(content.GetChild(0).gameObject);
                cleaning = false;
            }
        }

        public void Accept()
        {
            string text = inputText.text.ToLower();
            inputText.text = string.Empty;
            Write(text);
            Process(text);
            scrollRect.verticalNormalizedPosition = 0;
        }

        private void Process(string text)
        {
            if (!text.StartsWith("/"))
            {
                Write("The input text didn't started with an slash '/'");
                return;
            }

            string subtext = text.Substring(1);
            string[] sections = subtext.Split(' ');
            if (sections.Length == 0)
            {
                Write("The given command was empty.");
                return;
            }

            if (commands.TryGetValue((sections[0], sections.Length - 1), out Action<string[]> action))
                action(sections);
            else if (commandsPack == null || !commandsPack.Process(sections))
                Write("The given command with the specified amount of parameters was not found. Try /help.");
        }

        private void LogAmount0(string[] sections)
            => Write($"Maximum amount of logs: {logLength}");

        private void LogAmount1(string[] sections)
        {
            if (int.TryParse(sections[1], out int amount))
            {
                if (amount < 1)
                    Write("Log amounts can't be lower than 1.");
                logLength = amount;
                Write("New amount of logs successfuly set.");
            }
            else
                Write($"Could not parse '{sections[1]}' as integer.");
        }

        private static void Exit(string[] sections)
            => Application.Quit();

        private void Close(string[] sections)
            => console.SetActive(false);

        public void SetCommandsPack(CommandsPack commandsPack)
            => this.commandsPack = commandsPack;

        private void Help(string[] sections)
        {
            Write("Avariable commands are:");
            Write("/Log (int): Determined the amount of stored logs in console.");
            Write("/Log: Get the amount of stored logs in console.");
            Write("/Help: Get help.");
            Write("/Exit: Close game.");
            Write("/Close: Close console.");
            Write("/Clear. Clear console logs.");
            if (commandsPack != null)
                foreach (string str in commandsPack.Help)
                    Write(str);
        }

        private void Clear(string[] sections) => cleaning = true;

        public void Write(string text)
        {
            GameObject instance = Instantiate(logPrefab);
            instance.transform.SetParent(content.transform);
            instance.GetComponentInChildren<Text>().text = text;
        }
    }
}