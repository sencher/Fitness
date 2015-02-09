package windows {
<<<<<<< HEAD
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import utils.Utils;
=======
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import utils.Utils;

    public class InfoPopup extends Sprite {
        private var view:info_popup = new info_popup();
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8

public class InfoPopup extends Sprite {
    private var view:info_popup = new info_popup();

<<<<<<< HEAD
    public function InfoPopup() {
        addChild(view);
    }

    public function init(message:String):void {
        view.info.text = message;
        Utils.initButton(view.ok, onClick);
    }

    private function onClick(event:MouseEvent):void {
//            WindowManager(parent).ClosePopup();
//            view.ok.removeEventListener(MouseEvent.CLICK, onClick);
        dispatchEvent(new Event(Event.CLOSE));
=======
        public function init(message:String):void{
            trace(message);
            view.info.text = message;
            Utils.initButton(view.ok, onClick);
        }

        private function onClick(event:MouseEvent):void {
//            WindowManager(parent).ClosePopup();
//            view.ok.removeEventListener(MouseEvent.CLICK, onClick);
            dispatchEvent(new Event(Event.CLOSE));
        }
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
    }

    public function append(message:String):void {
        view.info.text += "\n" + message;
    }
}
}
