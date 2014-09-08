package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;

    public class BaseWindow extends Sprite{
        protected var main:Main;
        protected var view:MovieClip;

        function BaseWindow(parent:Main, viewClass:Class){
            main = parent;
            view = new viewClass();
            addChild(view);
        }
        public function close():void{
            this.parent.removeChild(this);
        }
    }
}
