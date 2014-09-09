package Events {
    import flash.events.Event;

    public class ClentEvent extends Event
    {
        public static const SELECTED:String = "Selected";

        public var client:ClientVO;

        public function ClentEvent(type:String, client:ClientVO, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            this.client = client;
        }


        public override function clone():Event
        {
            return new ClentEvent(type, this.client, bubbles, cancelable);
        }

    }
}
