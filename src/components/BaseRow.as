/**
 * Created by M1.SenCheR on 11.11.14.
 */
package components {
import Events.ClientEvent;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

import utils.Utils;

import vo.ClientVO;

public class BaseRow extends MovieClip {
    public var view:MovieClip;
    public var client:ClientVO;

    public var id:TextField;
    public var client_name:TextField;

    public function BaseRow(mc:MovieClip) {
        view = mc;
        view.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        Utils.copyFields(this, mc);
    }

    protected function onClick(event:MouseEvent):void {
        dispatchEvent(new ClientEvent(ClientEvent.SELECTED, client));
    }

    public function update(client:ClientVO):void{
        if (!client || !client.cardId) {
            clear();
            return;
        }
        this.client = client;
        id.text = String(client.cardId);
        client_name.text = client.secondName + " " + client.firstName + " " + client.thirdName;

        switch (client.status) {
            case ClientVO.PAY_WEEK:
            case ClientVO.NOT_PAYED:
                view.status.gotoAndStop(5);
                break;
            case ClientVO.FROZEN:
                view.status.gotoAndStop(4);
                break;
            case ClientVO.OUTDATED:
                view.status.gotoAndStop(3);
                break;
            case ClientVO.WEEK:
            case ClientVO.TWO_WEEKS:
                view.status.gotoAndStop(2);
                break;
            case ClientVO.VALID:
            default:
                view.status.gotoAndStop(1);
                break;
        }
    }

    public function clear():void {
        Utils.clearTextFields(this);
        client = null;
        view.status.gotoAndStop(1);
    }
}
}
