package windows {
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class ListWindow extends CancellableWindow {
        public function ListWindow(parent:Main) {
            super(parent, list_window);
            view.up.addEventListener(MouseEvent.CLICK, onUp);
            view.down.addEventListener(MouseEvent.CLICK, onDown);

        }

        private function onUp(event:MouseEvent):void {

        }

        private function onDown(event:MouseEvent):void {

        }
    }
}
