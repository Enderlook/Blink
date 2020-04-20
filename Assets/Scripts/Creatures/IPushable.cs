using UnityEngine;

namespace Game.Creatures
{
    public interface IPushable
    {
        void AddForce(Vector3 force, ForceMode mode = ForceMode.Force);
    }
}