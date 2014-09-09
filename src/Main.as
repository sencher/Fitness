package {
    import flash.display.Sprite;
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    import flash.ui.Keyboard;

    import windows.BaseWindow;
    import windows.ClientWindow;
    import windows.ListWindow;
    import windows.StartWindow;

    [SWF(backgroundColor="0x95F0BB", width="1024", height="768")]
    public class Main extends Sprite {

        public var start:StartWindow = new StartWindow(this);
        public var client:ClientWindow = new ClientWindow(this);
        public var list:ListWindow = new ListWindow(this);
        private var currentWindow:BaseWindow;

        public function Main() {
            DataBase.load();
            addChild(new bg());
            ShowWindow(start);
            addVersion();
            stage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
        }


        public function ShowWindow(window:BaseWindow, params:* = null):void {
            if (currentWindow) currentWindow.close();
            currentWindow = window;
            currentWindow.init(params);
            addChild(currentWindow);
        }

        private function addVersion():void {
            var v:TextField = new TextField();
            v.text = "Version 0.1b";
            v.x = stage.stageWidth - v.textWidth - 10;
            v.y = stage.stageHeight - v.textHeight;
            addChild(v);
        }

        private function onKey(event:KeyboardEvent):void {
            if (event.keyCode == Keyboard.ESCAPE) {
                ShowWindow(start);
            }
        }
    }
}
