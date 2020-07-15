using System;
using System.Collections.Generic;

using UnityEngine;

namespace Game.Scene.CLI
{
    public abstract class CommandsPack : MonoBehaviour
    {
        private Console console;

        protected Dictionary<(string command, int parameters), Action<string[]>> commands;

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Code Quality", "IDE0051:Remove unused private members", Justification = "Used by Unity.")]
        private void Start()
        {
            console = FindObjectOfType<Console>();
            console.SetCommandsPack(this);
        }

        public bool Process(string[] sections)
        {
            if (commands.TryGetValue((sections[0], sections.Length - 1), out Action<string[]> action))
            {
                action(sections);
                return true;
            }
            else
                return false;
        }

        public abstract IEnumerable<string> Help { get; }

        protected void Write(string input) => console.Write(input);
    }
}