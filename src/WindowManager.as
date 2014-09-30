package {
    import flash.display.Sprite;

    import utils.Hash;

    import windows.BaseWindow;
    import windows.ClientWindow;
    import windows.InfoPopup;
    import windows.ListWindow;
    import windows.StartWindow;

    public class WindowManager extends Sprite{
        private static var _instance:WindowManager;

        private var currentWindowClass:Class;
        private var previousWindowClass:Class;

        private var currentWindow:BaseWindow;
        private var popup:InfoPopup;

        private var _windows:Hash = new Hash();
        private var popupShowed:Boolean;
        private var popupQueue:Vector.<String> = new Vector.<String>();

        public function WindowManager(){
            if(_instance){
                throw new Error("WindowManager... use getInstance()");
            }
            _instance = this;
        }

        public static function get instance():WindowManager{
            if(!_instance){
                new WindowManager();
            }
            return _instance;
        }

        public function ShowWindow(window:Class, params:* = null):void {
            if (currentWindow) currentWindow.close();
            currentWindow = BaseWindow(_windows.getKey(window));
            if(!currentWindow){
                currentWindow = new window();
                _windows.setKey(window, currentWindow);
            }

            previousWindowClass = currentWindowClass;
            currentWindowClass = window;
            addChild(currentWindow);
            currentWindow.init(params);
        }

        public function ShowPrevious():void {
            ShowWindow(previousWindowClass);
        }

        public function ShowPopup(message:String):void{
            if(popupShowed) {
                popupQueue.push(message);
                return;
            }

            popup = InfoPopup(_windows.getKey(InfoPopup));
            if(!popup){
                popup = new InfoPopup();
                _windows.setKey(InfoPopup, popup);
            }
            popup.init(message);
            addChild(popup);
            popupShowed = true;
        }

        public function ClosePopup():void{
            popupShowed = false;
            removeChild(popup);
            if(popupQueue.length){
                ShowPopup(popupQueue.shift());
            }
        }
    }
}
