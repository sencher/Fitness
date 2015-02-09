package windows {
import components.ClientRow;

import core.DataBase;

public class ClientListWindow extends ListWindow {

    public function ClientListWindow() {
        pageSize = 25;
        rowClass = ClientRow;
        super(list_window);
    }

    override public function init(params:Object = null):void {
        itemList = DataBase.instance.base;
        super.init(params);
    }

    override protected function updateRow(counter:int, i:int):void {
        rowsView[counter].update(itemList[i]);
    }
}
}
