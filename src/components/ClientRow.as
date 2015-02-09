package components {
import Events.ClientEvent;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

import managers.VisitManager;

import utils.Utils;

import vo.ClientVO;
import vo.ClientVisitsVO;

public class ClientRow extends BaseRow {
    public var fields:Array = ['id', 'client_name', 'days', 'visits', 'valid', 'last_visit'];

    public var days:TextField;
    public var visits:TextField;
    public var valid:MovieClip;
    public var last_visit:MovieClip;

    public function ClientRow(mc:MovieClip) {
        super(mc);
    }

    override public function update(client:ClientVO):void {
        if (!client || !client.cardId) {
            clear();
            return;
        }
        super.update(client);
        var clientVisits:ClientVisitsVO = VisitManager.instance.getClientVisits(client);

        days.text = String(clientVisits.client_stage);
        visits.text = String(clientVisits.visits);
        Utils.divideDate(valid, client.abonement.ab_end);
        Utils.divideDate(last_visit, clientVisits.last_visit);
    }
}
}
