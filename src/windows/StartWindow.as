package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;

    public class StartWindow extends BaseWindow {
        public static const NEW:String = "new";
        public static const LIST:String = "list";

        public function StartWindow(parent:Main) {
            super(parent, start_window);

            addChild(view);
            view.new_button.addEventListener(MouseEvent.CLICK, onNew, false, 0, true);
            view.list_button.addEventListener(MouseEvent.CLICK, onList, false, 0, true);

        }

        private function onNew(event:MouseEvent):void {
            main.ShowWindow(main.client);
        }

        private function onList(event:MouseEvent):void {
            main.ShowWindow(main.list);
        }
    }
}
