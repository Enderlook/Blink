using Game.Creatures;
using Game.Creatures.Player.AbilitySystem;

using System;
using System.Collections.Generic;
using System.Linq;

using UnityEngine;

namespace Game.Scene.CLI
{
    public class LevelCommandsPack : CommandsPack
    {
        [SerializeField]
        private ControlledAbilitiesPack[] abilities;

        private string[] help = new string[]
        {
            "/Heal ('player'|'crystal'|'enemies'): Restore all hit points of choosen creature(s).",
            "/Heal ('player'|'crystal'|'enemies') (int): Restore X hit points of choosen creature(s).",
            "/Hurt ('player'|'crystal'|'enemies'): Reduce all hit points of choosen creature(s).",
            "/Hurt ('player'|'crystal'|'enemies') (int): Reduce X hit points of choosen creature(s).",
            "/Reload: Reload all player's abilities.",
            "/Win: Auto win.",
            "/Lose: Auto loose",
            "/Goto (int): Go to the specified scene index.",
            "/Goto (int) (true): Go to the specified scene index and advances level counter.",
            "/AddEnergy (int): Add the specified amount of energy.",
            "/SetEnergy (int): Set the specified amount of energy.",
            "/SetAbilityPack (int): Set the specified ability pack."
        };

        public override IEnumerable<string> Help => help;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Awake() => commands = new Dictionary<(string command, int parameters), Action<string[]>>()
            {
                { ("freeze", 0), Freeze },
                { ("freeze", 1), Freeze1 },
                { ("heal", 1), Heal1 },
                { ("heal", 2), Heal2 },
                { ("hurt", 1), Hurt1 },
                { ("hurt", 2), Hurt2 },
                { ("reload", 0), Reload },
                { ("win", 0), Win },
                { ("loose", 0), Loose},
                { ("goto", 1), GoTo },
                { ("goto", 2), GoToAdvance },
                { ("setenergy", 1), SetEnergy},
                { ("addenergy", 1), AddEnergy},
                { ("setabilitypack", 1), SetAbilityPack},
            };

        private void SetEnergy(string[] sections)
        {
            if (int.TryParse(sections[1], out int value))
                if (value < 0)
                    Write("Goto amounts can't be negative.");
                else
                {
                    Write($"Setted energy to {value}.");
                    GameManager gameManager = FindObjectOfType<GameManager>();
                    gameManager.AddEnergy(value - gameManager.CurrentEnergy);
                }
            else
                Write($"Could not parse '{sections[1]}' as integer.");
        }

        private void AddEnergy(string[] sections)
        {
            if (int.TryParse(sections[1], out int value))
            {
                Write($"Added {value} energy!");
                FindObjectOfType<GameManager>().AddEnergy(value);
            }
            else
                Write($"Could not parse '{sections[1]}' as integer.");
        }

        private void Freeze(string[] sections)
        {
            if (Time.timeScale == 0)
            {
                Time.timeScale = 1;
                Write("Time unfreezed.");
            }
            else
            {
                Time.timeScale = 0;
                Write("Time freezed.");
            }
        }

        private void Freeze1(string[] sections)
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
                    action(CrystalAndPlayerTracker.Player.GetComponent<Hurtable>(), "Player");
                    break;
                case "crystal":
                    action(CrystalAndPlayerTracker.CrystalHurtable, "Crystal");
                    break;
                case "enemies":
                    foreach (Hurtable enemy in FindObjectsOfType<Hurtable>().Except(new[] { CrystalAndPlayerTracker.Player.GetComponent<Hurtable>(), CrystalAndPlayerTracker.CrystalHurtable }))
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

        private void Reload(string[] sections) => CrystalAndPlayerTracker.Player.GetComponent<AbilitiesManager>().ChargeAbilitiesToMaximum();

        private void Win(string[] sections) => FindObjectOfType<Menu>().Win();

        private void Loose(string[] sections) => FindObjectOfType<Menu>().Lose();

        public void GoTo(string[] sections)
        {
            if (int.TryParse(sections[1], out int index))
            {
                if (index < 2)
                    Write("Goto amounts can't be lower than 2.");
                else
                    FindObjectOfType<GameManager>().AdvanceScene(index, false);
            }
            else
                Write($"Could not parse '{sections[1]}' as integer.");
        }

        public void GoToAdvance(string[] sections)
        {
            if (int.TryParse(sections[1], out int index))
            {
                if (index < 2)
                    Write("Goto amounts can't be lower than 2.");
                else
                {
                    if (bool.TryParse(sections[2], out bool advance))
                        FindObjectOfType<GameManager>().AdvanceScene(index, advance);
                    else
                        Write($"Could not parse '{sections[2]}' as boolean.");
                }
            }
            else
                Write($"Could not parse '{sections[1]}' as integer.");
        }

        public void SetAbilityPack(string[] sections)
        {
            if (int.TryParse(sections[1], out int index))
            {
                if (index < 0)
                    Write("Index can't be negative.");
                else
                {
                    if (index >= abilities.Length)
                        Write("Abilities out of range.");
                    else
                    {
                        string name = FindObjectOfType<LevelConfiguration>().SetAbilityPack(abilities[index]);
                        Write($"Succesfully changed to {name}");
                    }
                }
            }
            else
                Write($"Could not parse '{sections[1]}' as integer.");
        }
    }
}