package windows {
import components.ClientRow;

import core.DataBase;

import vo.ClientVO;

public class ClientListWindow extends ListWindow {

    public function ClientListWindow() {
        rowClass = ClientRow;
        super(list_window);
    }

    override public function init(params:Object = null):void {
        itemList = DataBase.instance.base;
        super.init(params);

        view.total.text = itemList.length;
        var client:ClientVO;
        var counters:Array = new Array(7);
        var id:int;
        for each (client in itemList){
            switch (client.status){
                case ClientVO.VALID:
                    id = 0;
                    break;
                case ClientVO.TWO_WEEKS:
                    id = 1
                    break;
                case ClientVO.PAY_WEEK:
                    id = 2
                    break;
                case ClientVO.WEEK:
                    id = 3
                    break;
                case ClientVO.FROZEN:
                    id = 4
                    break;
                case ClientVO.NOT_PAYED:
                    id = 5
                    break;
                case ClientVO.OUTDATED:
                    id = 6
                    break;
                default:
                    break;
            }
            counters[id] = counters[id] ? counters[id] + 1 : 1;
        }
        view.valid.text = counters[0] || '0';
        view.two_weeks.text = counters[1] || '0';
        view.pay_week.text = counters[2] || '0';
        view.week.text = counters[3] || '0';
        view.frozen.text = counters[4] || '0';
        view.not_payed.text = counters[5] || '0';
        view.outdated.text = counters[6] || '0';
    }
}
}
