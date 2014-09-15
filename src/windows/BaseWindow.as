package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class BaseWindow extends Sprite{
        protected var view:MovieClip;
        protected var wm:WindowManager;

        function BaseWindow(viewClass:Class){
            view = new viewClass();
            addChild(view);
            wm = WindowManager.instance;
        }

        public function init(params:Object = null):void{

        }

        public function close():void{
            this.parent.removeChild(this);
        }
    }
}
