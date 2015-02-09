package Events {
import flash.events.Event;

public class CalendarEvent extends Event {
    public static const SELECTED:String = "Selected";
    public static const REDRAW:String = 'redraw';

    public var date:Date;

    public function CalendarEvent(type:String, date:Date, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.date = date;
    }


    public override function clone():Event {
        return new CalendarEvent(type, this.date, bubbles, cancelable);
    }

}
}
