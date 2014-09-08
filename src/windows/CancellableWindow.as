package windows {
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;

    public class CancellableWindow extends BaseWindow{
        public function CancellableWindow(parent:Main, viewClass:Class){
            super(parent, viewClass);
            view.cancel.addEventListener(MouseEvent.CLICK, onCancel, false, 0, true);
        }


        private function onCancel(event:MouseEvent = null):void {
            main.ShowWindow(main.start);
        }
    }
}
