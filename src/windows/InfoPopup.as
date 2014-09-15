package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class InfoPopup extends Sprite{
        private var view:info_popup = new info_popup();

        public function InfoPopup(message:String) {
        trace(message);
        view.info.text = message;
        view.ok.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        addChild(view);
    }

        private function onClick(event:MouseEvent):void {
            parent.removeChild(this);
            view.ok.removeEventListener(MouseEvent.CLICK, onClick);
//            delete this;
        }
}
}
