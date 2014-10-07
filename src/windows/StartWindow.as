package windows {
    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;

    import utils.Utils;

    public class StartWindow extends BaseWindow {

        public function StartWindow() {
            super(start_window);

            addChild(view);
            Utils.initButton(view.new_button, onNew);
            Utils.initButton(view.list_button, onList);
            Utils.initButton(view.exit_button, onExit);
        }

        private function onNew(event:MouseEvent):void {
            wm.ShowWindow(ClientWindow);
        }

        private function onList(event:MouseEvent):void {
            wm.ShowWindow(ListWindow);
        }

        private function onExit(event:MouseEvent):void {
            NativeApplication.nativeApplication.exit();
        }
    }
}
