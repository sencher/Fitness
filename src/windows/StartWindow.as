package windows {
    import flash.events.MouseEvent;

    public class StartWindow extends BaseWindow {

        public function StartWindow() {
            super(start_window);

            addChild(view);
            view.new_button.addEventListener(MouseEvent.CLICK, onNew, false, 0, true);
            view.list_button.addEventListener(MouseEvent.CLICK, onList, false, 0, true);

        }

        private function onNew(event:MouseEvent):void {
            wm.ShowWindow(ClientWindow);
        }

        private function onList(event:MouseEvent):void {
            wm.ShowWindow(ListWindow);
        }
    }
}
