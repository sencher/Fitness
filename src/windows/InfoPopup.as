package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import utils.Utils;

    public class InfoPopup extends Sprite {
        private var view:info_popup = new info_popup();

        public function InfoPopup() {
            addChild(view);
        }

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
    }
}
