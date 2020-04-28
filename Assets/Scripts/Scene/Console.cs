using Game.Creatures;
using Game.Creatures.Player.AbilitySystem;
using System;
using System.Collections.Generic;
using System.Linq;

using UnityEngine;
using UnityEngine.UI;

namespace Game.Scene
{
    public class Console : MonoBehaviour
    {
#pragma warning disable CS0649
        [SerializeField, Tooltip("Console that can be hidden.")]
        private GameObject console;

        [SerializeField, Tooltip("Were all logs are stored.")]
        private RectTransform content;

        [SerializeField, Tooltip("Text used as input.")]
        private Text input;

        [SerializeField, Tooltip("Key used to execute command.")]
        private KeyCode introCode;

        [SerializeField, Tooltip("Key used to open console.")]
        private KeyCode openConsole;

        [SerializeField, Tooltip("Prefab used for console logs.")]
        private Text logPrefab;

        [SerializeField]
        private Hurtable player;

        [SerializeField]
        private Hurtable crystal;
#pragma warning restore CS0649

        private int logLength = 10;

        private Dictionary<(string command, int parameters), Action<string[]>> commands;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake()
        {
            commands = new Dictionary<(string command, int parameters), Action<string[]>>()
            {
                { ("log", 0), LogAmount0 },
                { ("log", 1), LogAmount1 },
                { ("exit", 0), Exit },
                { ("close", 0), Close },
                { ("freeze", 1), Freeze },
                { ("heal", 1), Heal1 },
                { ("heal", 2), Heal2 },
                { ("hurt", 1), Hurt1 },
                { ("hurt", 2), Hurt2 },
                { ("help", 0), Help },
                { ("clear", 0), Clear },
                { ("reload", 0), Reload }
            };
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Update()
        {
            if (!console.activeSelf && Input.GetKeyDown(openConsole))
                console.SetActive(true);

            if (Input.GetKeyDown(introCode))
                Accept();

            if (content.childCount > logLength)
                Destroy(content.GetChild(0).gameObject);
        }
		
		public void Accept()
		{
			Write(input.text);
			Process(input.text);
			input.text = "";
		}
		
        private void Process(string text)
        {
            if (!text.StartsWith("/"))
            {
                Write($"The input text didn't started with an slash '/'");
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
            else
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

        private void Freeze(string[] sections)
        {
            switch (sections[1].ToLower())
            {
                case "true":
                    Time.timeScale = 0;
                    Write("Time freezed.");
                    break;
                case "false":
                    Time.timeScale = 1;
                    Write("Time unfreezed.");
                    break;
                default:
                    Write($"Value '{sections[1]}' is not recognized as boolean.");
                    break;
            }
        }

        private void DoInCreatures(string[] sections, Action<Hurtable, string> action)
        {
            switch (sections[1].ToLower())
            {
                case "player":
                    action(player, "Player");
                    break;
                case "crystal":
                    action(crystal, "Crystal");
                    break;
                case "enemies":
                    foreach (Hurtable enemy in FindObjectsOfType<Hurtable>().Except(new[] { player, crystal }))
                        action(enemy, enemy.gameObject.name);
                    break;
                default:
                    Write("Type of creature unknown. Accepted values are 'player', 'crystal' and 'enemies'");
                    break;
            }
        }

        private void Heal1(string[] sections)
        {
            DoInCreatures(sections, Heal);

            void Heal(Hurtable entity, string name)
            {
                int amount = entity.MaxHealth - entity.Health;
                entity.TakeHealing(amount);
                Write($"Healed {name} {amount} hitpoints.");
            }
        }

        private void Heal2(string[] sections)
        {
            if (!int.TryParse(sections[2], out int value))
            {
                Write($"Second parameter value '{sections[2]}' could not be parsed as integer.");
                return;
            }

            DoInCreatures(sections, Heal);

            void Heal(Hurtable entity, string name)
            {
                entity.TakeHealing(value);
                Write($"Healed {name} {value} hitpoints.");
            }
        }

        private void Hurt1(string[] sections)
        {
            DoInCreatures(sections, Hurt);

            void Hurt(Hurtable entity, string name)
            {
                entity.TakeDamage(entity.Health);
                Write($"Hurted {name} {entity.Health} hitpoints.");
            }
        }

        private void Hurt2(string[] sections)
        {
            if (!int.TryParse(sections[2], out int value))
            {
                Write($"Second parameter value '{sections[2]}' could not be parsed as integer.");
                return;
            }

            DoInCreatures(sections, Hurt);

            void Hurt(Hurtable entity, string name)
            {
                entity.TakeDamage(value);
                Write($"Hurted {name} {value} hitpoints.");
            }
        }

        private void Help(string[] sections)
        {
            Write("Avariable commands are:");
            Write("/Log (int): Determined the amount of stored logs in console.");
            Write("/Log: Get the amount of stored logs in console.");
            Write("/Help: Get help.");
            Write("/Exit: Close game.");
            Write("/Close: Close console.");
            Write("/Clear. Clear console logs.");
            Write("/Heal ('player'|'crystal'|'enemies'): Restore all hit points of choosen creature(s).");
            Write("/Heal ('player'|'crystal'|'enemies') (int): Restore X hit points of choosen creature(s).");
            Write("/Hurt ('player'|'crystal'|'enemies'): Reduce all hit points of choosen creature(s).");
            Write("/Hurt ('player'|'crystal'|'enemies') (int): Reduce X hit points of choosen creature(s).");
            Write("/Reload: Reload all player's abilities.");
        }

        private void Clear(string[] sections)
        {
            while (content.childCount > 0)
                Destroy(content.GetChild(0).gameObject);
        }

        private void Reload(string[] sections) => player.GetComponent<AbilitiesManager>().InstantReload();

        private void Write(string text)
        {
            Text instance = Instantiate(logPrefab);
            instance.text = text;
            instance.transform.SetParent(content.transform);
        }
    }
}