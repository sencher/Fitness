package components {
import Events.ClientEvent;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

import utils.Utils;

import vo.ClientVO;

public class ReportRow extends MovieClip {
    public var fields:Array = ['num', 'id', 'client_name', 'visit_time'];
    public var view:MovieClip;
    public var num:TextField;
    public var id:TextField;
    public var client_name:TextField;
    public var visit_time:TextField;

    public var client:ClientVO;

    public function ReportRow(mc:MovieClip) {
        view = mc;
        view.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        Utils.copyFields(this, mc);
    }

    private function onClick(event:MouseEvent):void {
        dispatchEvent(new ClientEvent(ClientEvent.SELECTED, client));
    }

    public function update(num:int, client:ClientVO, visitTime:String = ""):void {
        if (!client || !client.cardId) {
            clear();
            return;
        }
        this.client = client;

        this.num.text = String(num);
        id.text = String(client.cardId);
        client_name.text = client.secondName + " " + client.firstName + " " + client.thirdName;
        visit_time.text = visitTime;
        switch (client.status) {
            case ClientVO.OUTDATED:
                view.status.gotoAndStop(3);
                break;
            case ClientVO.WEEK:
            case ClientVO.TWO_WEEKS:
                view.status.gotoAndStop(2);
                break;
            case ClientVO.VALID:
                view.status.gotoAndStop(1);
                break;
            default:
                break;
        }
    }

    public function clear():void {
        num.text = id.text = client_name.text = visit_time.text = "";
        client = null;
    }

    private function clearDateComponent(dateComponent:MovieClip):void {
        dateComponent.day.text = dateComponent.month.text = dateComponent.year.text = "";
    }
}
}
