package {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

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
        private var _params:*;
        private var windowLayer:Sprite = new Sprite();
        private var popupLayer:Sprite = new Sprite();


        public function WindowManager(){
            if(_instance){
                throw new Error("WindowManager... use getInstance()");
            }
            _instance = this;
            addChild(windowLayer);
            addChild(popupLayer);
        }

        public static function get instance():WindowManager{
            if(!_instance){
                new WindowManager();
            }
            return _instance;
        }

        public function ShowWindow(window:Class, params:* = null):void {
            if(currentWindowClass == window && _params == params) return;
            _params = params;
            if (currentWindow) currentWindow.close();
            currentWindow = BaseWindow(_windows.getKey(window));
            if(!currentWindow){
                currentWindow = new window();
                _windows.setKey(window, currentWindow);
            }

            previousWindowClass = currentWindowClass;
            currentWindowClass = window;
            windowLayer.addChild(currentWindow);
            currentWindow.init(_params);
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
            popup.addEventListener(Event.CLOSE, ClosePopup, false, 0, true);
            popup.init(message);
            popupLayer.addChild(popup);
            popupShowed = true;
        }

        public function ClosePopup(event:Event = null):void{
            popupShowed = false;
            popupLayer.removeChild(popup);
            if(popupQueue.length){
                ShowPopup(popupQueue.shift());
            }
        }

        private function moveToTop( clip:DisplayObject ):void
        {
            if(!clip || !clip.parent) return;
            clip.parent.setChildIndex(clip, clip.parent.numChildren - 1);
        }
    }
}
