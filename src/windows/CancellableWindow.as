package windows {
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;

    import utils.Utils;

    public class CancellableWindow extends BaseWindow{
        public function CancellableWindow(viewClass:Class){
            super(viewClass);
            Utils.initButton(view.cancel, onCancel);
        }


        private function onCancel(event:MouseEvent = null):void {
            wm.ShowPrevious();
        }
    }
}
