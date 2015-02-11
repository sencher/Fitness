package vo {
import core.Config;
    import core.DataBase;

    import managers.WindowManager;

    import utils.Utils;

/**
 * Dynamic to add "cursor" param for ListWindow compatability to ReportWindow
 */
public dynamic class VisitDayVO {
    public var date:Date;
    public var ids:Array = [];
    public var times:Array = [];

    public function VisitDayVO(date:Date = null) {
        this.date = date || new Date();
    }

    public function newVisit(id:int, time:Time):void {
        if(!DataBase.instance.getClientById(id)){
            WindowManager.instance.ShowPopup("Есть визит для несуществующего клиента № " + id + "\n" + date + "\n" + time);
            return;
        }
        ids.push(id);
        times.push(time);
    }

    public function toString():String {
        var s:String = Utils.packDate(date) + Config.FIELD_DELIMITER;
        var i:int;
        for (i = 0; i < ids.length; i++) {
            s += ids[i] + Config.FIELD_DELIMITER + times[i] + Config.FIELD_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }
}
}
