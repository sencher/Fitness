package windows {
import core.DataBase;

import flash.events.MouseEvent;
import flash.text.TextField;

import utils.Utils;

import vo.ClientVO;

public class SearchWindow extends BackableWindow {
    public var fields:Array = ['secondName', 'cardId'];

    public var secondName:TextField;
    public var cardId:TextField;
    private var client:ClientVO;

    public function SearchWindow() {
        super(search_window);
        Utils.copyFields(this, view);
        Utils.initButton(view.search, onSearch);
    }

    override public function init(params:Object = null):void {
        Utils.clearTextFields(this);

    }

    private function onSearch(event:MouseEvent):void {
        var id:int = int(cardId.text);
        var secName:String = secondName.text;
        var client:ClientVO;
        if (id > 0) {
            client = DataBase.instance.getClientById(id);
        } else if (secName.length > 0) {
            client = DataBase.instance.getClientBySecName(secName);
        }

        if (client) {
            client.scanned = false;
            wm.ShowWindow(ClientWindow, client);
        } else
            wm.ShowPopup("Клиент не найден.")
    }
}
}
