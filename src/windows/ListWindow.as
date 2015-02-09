/**
 * Created by M1.SenCheR on 08.11.14.
 */
package windows {
import Events.ClientEvent;

import flash.events.MouseEvent;

import utils.Utils;

<<<<<<< HEAD
public class ListWindow extends BaseWindow {
    protected var pageSize:int = 25;
    protected var rowClass:Class;
    protected var cursor:int = 0;
    protected var rowsView:Array = [];
    protected var itemList:*;


    public function ListWindow(viewClass:Class) {
        super(viewClass);
        Utils.initButton(view.up, onUp);
        Utils.initButton(view.down, onDown);
        Utils.initButton(view.main_menu, onMenu);
        initRows();
    }

    protected function initRows():void {
        var i:int;
        var row:*;
        for (i = 1; i < pageSize + 1; i++) {
            row = new rowClass(view["r" + i]);
            rowsView.push(row);
            row.addEventListener(ClientEvent.SELECTED, onSelectedRow, false, 0, true);
            row.mouseChildren = false;
            row.buttonMode = true;
=======
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
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
        }
    }

    override public function init(params:Object = null):void {
        super.init(params);
        stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        setCursor(0);
    }

    protected function setCursor(overrideCursor:int = -1):void {
        if (overrideCursor > -1) cursor = overrideCursor;
        trace(cursor)
        var i:int;
//            var row:ClientRow;

        var counter:int;
        for (i = cursor; i < cursor + pageSize; i++) {
            rowsView[counter].clear();

<<<<<<< HEAD
            if (i < itemList.length) {
                updateRow(counter, i);
=======

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
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
            }
            counter++;
        }
    }

    protected function updateRow(counter:int, i:int):void {

    }

<<<<<<< HEAD
    protected function onSelectedRow(event:ClientEvent):void {
        if (!event.client) return;
        event.client.scanned = false;
        wm.ShowWindow(ClientWindow, event.client);
    }

    private function onUp(event:MouseEvent = null):void {
        if (cursor - pageSize > -1) {
            cursor -= pageSize;
        } else {
            return;
=======
        private function onUp(event:MouseEvent):void {
            if(cursor - PAGE_SIZE > -1) {
                cursor -= PAGE_SIZE;
            }else{
                return;
            }
            setCursor();
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
        }
        setCursor();
    }

<<<<<<< HEAD
    private function onDown(event:MouseEvent = null):void {
        if (cursor + pageSize < itemList.length) {
            cursor += pageSize;
        } else {
            return;
=======
        private function onDown(event:MouseEvent):void {
            if( cursor + PAGE_SIZE < base.length) {
                cursor += PAGE_SIZE;
            }else{
                return;
            }
            setCursor();
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
        }
        setCursor();
    }

    protected function onMouseWheel(event:MouseEvent):void {
        event.stopImmediatePropagation();
        trace(event.delta);
        if (event.delta > 0) onUp();
        else onDown();
    }

    override protected function unInit():void {
        stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

}


}
