using UnityEngine;

namespace AvalonStudios.Extensions
{
    public static class LayerMaskExtensions
    {
        /// <summary>
        /// Convert a <see cref="LayerMask"/> value to it's true layer value.<br/>
        /// This should only be used if the <paramref name="layerMask"/> has a single layer.
        /// </summary>
        /// <param name="layerMask"><see cref="LayerMask"/></param>
        /// <returns>int layer number.</returns>
        public static int ToLayer(this LayerMask layerMask)
        {
            int value = layerMask.value;
            int exp = 2;
            int b = 1;
            int result = 0;
            while (result != value)
            {
                result = (int)Mathf.Pow(exp, b);
                b += result != value ? 1 : 0;
            }

            return b;
        }
    }
}
