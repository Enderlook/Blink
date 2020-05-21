namespace Game.Creatures.Player.AbilitySystem
{
    public abstract class TriggerableAbility : Ability
    {
        public bool IsRunning { get; private set; }

        public override sealed bool IsReady => base.IsReady && !IsRunning;

        protected override sealed void ExecuteBehaviour()
        {
            IsRunning = true;
            ExecuteStart();
        }

        protected abstract void ExecuteStart();

        public void OnTrigger()
        {
            IsRunning = false;
            ExecuteEnd();
        }

        protected abstract void ExecuteEnd();
    }
}
