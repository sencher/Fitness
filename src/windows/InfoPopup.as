package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class InfoPopup extends Sprite {
        private var view:info_popup = new info_popup();

        public function InfoPopup() {
            addChild(view);
        }

        public function init(message:String):void{
            trace(message);
            view.info.text = message;
            view.ok.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        private function onClick(event:MouseEvent):void {
            WindowManager(parent).ClosePopup();
//            view.ok.removeEventListener(MouseEvent.CLICK, onClick);
        }
    }
}
