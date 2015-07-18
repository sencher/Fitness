package Events {
import flash.events.Event;

public class PopupEvent extends Event {
    public static const CLOSE:String = "close";
    private var answer:Boolean;

    public function PopupEvent(type:String, answer:Boolean, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.answer = answer;
    }

    public override function clone():Event {
        return new PopupEvent(type, this.answer, bubbles, cancelable);
    }

}
}
