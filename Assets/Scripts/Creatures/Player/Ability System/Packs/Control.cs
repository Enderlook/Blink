using Enderlook.Unity.Attributes;

using System;

using UnityEngine;
using UnityEngine.UIElements;

namespace Game.Creatures.Player.AbilitySystem
{
    [Serializable]
    public class Control
    {
#pragma warning disable CS0649
        [SerializeField]
        private bool useMouse;

        [SerializeField/*, ShowIf(nameof(useMouse), false)*/]
        private KeyCode key;

        [SerializeField/*, ShowIf(nameof(useMouse), true)*/]
        private MouseButton button;

        [SerializeField]
        private bool canBeHoldDown;
#pragma warning restore CS0649

        public bool HasUserRequestTrigger()
        {
            if (useMouse)
            {
                if (canBeHoldDown)
                    return Input.GetMouseButton((int)button);
                else
                    return Input.GetMouseButtonDown((int)button);
            }
            else
            {
                if (canBeHoldDown)
                    return Input.GetKey(key);
                else
                    return Input.GetKeyDown(key);
            }
        }
    }
}
