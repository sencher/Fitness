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

        private var wm:WindowManager = WindowManager.instance;
        private var stringId:String = "";

        public function Main() {
            DataBase.load();
            addChild(new bg());
            addChild(wm);
            wm.ShowWindow(StartWindow);
            addVersion();
            stage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
        }

        private function addVersion():void {
            var v:TextField = new TextField();
            v.text = "Version " + Config.VERSION;
            v.x = stage.stageWidth - v.textWidth - 10;
            v.y = stage.stageHeight - v.textHeight;
            addChild(v);
        }

        private function onKey(event:KeyboardEvent):void {
            var keyCode:uint = event.keyCode;
            if (keyCode == Keyboard.ESCAPE) {
                wm.ShowWindow(StartWindow);
            }else if (keyCode > 47 && keyCode < 58){
                stringId += keyCode - 48;
            }else if(keyCode == Keyboard.ENTER){
                recognize(stringId);
                stringId = "";
            }else if(keyCode == Keyboard.F12){
                recognize("2410000000050");
            }else if(keyCode == Keyboard.F11){
                recognize("2410000003273");
            }
        }

        private function recognize(string:String):void {
            if(string.length == 13){
                var id:String = string.substr(9, 3);
                var clientVO:ClientVO = DataBase.getClientById(int(id)) || new ClientVO(id);
                wm.ShowWindow(ClientWindow, clientVO);
            }
        }
    }
}
