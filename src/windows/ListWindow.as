package windows {
    import components.ClientRow;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class ListWindow extends CancellableWindow {
        private var cursor:int = 0;
        private var rows:Vector.<ClientRow> = new <ClientRow>[];

        public function ListWindow(parent:Main) {
            super(parent, list_window);
            view.up.addEventListener(MouseEvent.CLICK, onUp);
            view.down.addEventListener(MouseEvent.CLICK, onDown);
            initRows();
        }

        private function initRows():void {
            var i:int;
            var row:MovieClip;
            for (i = 1; i < 26; i++){
                row = view["r"+i];
                rows.push(new ClientRow(row));
                row.addEventListener(MouseEvent.CLICK, onClick, false, 0, true)
            }
        }

        override public function init(param:Object = null):void {
            var base:Vector.<ClientVO> = DataBase.base;
            var i:int;
            var row:ClientRow;
            var counter:int;
            for (i=0; i<25;i++){
                if(i<base.length) {
                    rows[i].update(base[i]);
                }else{
                    rows[i].clear();
                }
            }
        }

        private function onClick(event:MouseEvent):void {
            trace(event.target.name, event.currentTarget.name);
        }

        private function onUp(event:MouseEvent):void {

        }

        private function onDown(event:MouseEvent):void {

        }
    }
}
