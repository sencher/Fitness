/**
 * Created by M1.SenCheR on 08.11.14.
 */
package windows {
import Events.ClientEvent;

import flash.events.MouseEvent;

import utils.Utils;

public class ListWindow extends BaseWindow {
    protected var pageSize:int = 30;
    protected var rowClass:Class;
    public var cursor:int = 0;
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
        }
    }

    override public function init(params:Object = null):void {
        super.init(params);
        stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        setCursor(params ? params.cursor : 0);
    }

    protected function setCursor(overrideCursor:int = -1):void {
        if (overrideCursor > -1) cursor = overrideCursor;
        var i:int;

        var counter:int;
        for (i = cursor; i < cursor + pageSize; i++) {
            rowsView[counter].clear();

            if (i < itemList.length) {
                updateRow(counter, i);
            }
            counter++;
        }
    }

    protected function updateRow(counter:int, i:int):void {
        rowsView[counter].update(itemList[i]);
    }

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
        }
        setCursor();
    }

    private function onDown(event:MouseEvent = null):void {
        if (cursor + pageSize < itemList.length) {
            cursor += pageSize;
        } else {
            return;
        }
        setCursor();
    }

    protected function onMouseWheel(event:MouseEvent):void {
        event.stopImmediatePropagation();
        if (event.delta > 0) onUp();
        else onDown();
    }

    override protected function unInit():void {
        stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    override public function saveAdditionalParamsOnExit():Object {
        return {cursor:cursor};
    }
}
}
