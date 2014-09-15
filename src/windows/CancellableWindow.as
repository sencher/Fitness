package windows {
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;

    public class CancellableWindow extends BaseWindow{
        public function CancellableWindow(viewClass:Class){
            super(viewClass);
            view.cancel.addEventListener(MouseEvent.CLICK, onCancel, false, 0, true);
        }


        private function onCancel(event:MouseEvent = null):void {
            wm.ShowWindow(StartWindow);
        }
    }
}
