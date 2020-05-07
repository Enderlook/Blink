namespace Game.Pickups
{
    public interface IPickupable<T>
    {
        void Accept(T picker);
    }
}