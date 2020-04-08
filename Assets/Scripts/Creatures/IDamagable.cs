namespace Game.Creatures
{
    public interface IDamagable
    {
        void TakeDamage(int amount);

        void TakeHealing(int amount);
    }
}