package Events {
import flash.events.Event;

import vo.ClientVO;

public class ClentEvent extends Event
    {
    public static const SELECTED:String = "selected";

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
