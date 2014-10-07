package windows {
    import Events.ClentEvent;

    import components.ClientRow;

    import flash.events.MouseEvent;

    import utils.Utils;

    public class ListWindow extends CancellableWindow {
        private const PAGE_SIZE:int = 25;
        private var cursor:int = 0;
        private var rowsView:Vector.<ClientRow> = new <ClientRow>[];
        private var base:Vector.<ClientVO>;

        public function ListWindow() {
            super(list_window);

            Utils.initButton(view.up, onUp);
            Utils.initButton(view.down, onDown);
            initRows();
        }

        private function initRows():void {
            var i:int;
            var row:ClientRow;
            for (i = 1; i < PAGE_SIZE + 1; i++){
                row = new ClientRow(view["r"+i]);
                rowsView.push(row);
                row.addEventListener(ClentEvent.SELECTED, onSelected, false, 0, true);
                row.mouseChildren = false;
                row.buttonMode = true;
            }
        }


        override public function init(params:Object = null):void {
            base = DataBase.base;
            setCursor();
        }

        private function setCursor():void {
            trace(cursor)
            var i:int;
//            var row:ClientRow;
            var counter:int;
            for (i = cursor; i < cursor + PAGE_SIZE; i++) {
                rowsView[counter].clear();
                if (i < base.length) {
                    rowsView[counter].update(base[i]);
                }
                counter++;
            }
        }

        private function onSelected(event:ClentEvent):void {
            trace(event.target.name, event.currentTarget.name);
            wm.ShowWindow(ClientWindow, event.client);
        }

        private function onUp(event:MouseEvent):void {
            if(cursor - PAGE_SIZE > -1) {
                cursor -= PAGE_SIZE;
            }else{
                return;
            }
            setCursor();
        }

        private function onDown(event:MouseEvent):void {
            if( cursor + PAGE_SIZE < base.length) {
                cursor += PAGE_SIZE;
            }else{
                return;
            }
            setCursor();
        }
    }
}
