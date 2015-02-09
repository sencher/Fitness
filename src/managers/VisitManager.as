/**
 * Created by M1.SenCheR on 05.11.14.
 */
package managers {
import core.Config;
import core.DataBase;

import utils.Utils;

import vo.ClientVO;
import vo.ClientVisitsVO;
import vo.Time;
import vo.VisitDayVO;

public class VisitManager {
    private static var _instance:VisitManager;
    public var base:Vector.<VisitDayVO> = new Vector.<VisitDayVO>();

    public function VisitManager() {
        if (_instance) {
            throw new Error("managers.VisitManager... use instance()");
        }
        _instance = this;
    }

    public static function get instance():VisitManager {
        if (!_instance) {
            new VisitManager();
        }
        return _instance;
    }

    public function getDay(searchDay:Date = null, forceCreate:Boolean = false):VisitDayVO {
        if (!searchDay) searchDay = new Date();

        for each(var visitDay:VisitDayVO in base) {
            if (Utils.areDatesEqual(visitDay.date, searchDay))
                return visitDay;
        }
        return forceCreate ? new VisitDayVO(searchDay) : null;
    }

    public function addVisit(cardId:uint, customDate:Date = null, showPopup:Boolean = true):void {
        var date:Date = customDate || new Date();
        var day:VisitDayVO = getDay(date);
        if (!day) {
            day = new VisitDayVO(date);
            base.push(day);
            base.sort(function (a:VisitDayVO, b:VisitDayVO):Number {
                return Number(a.date) - Number(b.date)
            })
        }
        if (day.ids.indexOf(cardId) > -1) {
            if(showPopup) WindowManager.instance.ShowPopup("Клиент сегодня уже был!", true);
            return;
        }
        day.newVisit(cardId, new Time(date.hours, date.minutes));

        DataBase.instance.save(Config.VISITS);
    }

    public function getClientVisits(client:ClientVO):ClientVisitsVO {
//        if(client.visits) return client.visits;

        var clientVisits:ClientVisitsVO = new ClientVisitsVO(client)
        for each(var day:VisitDayVO in base) {
            if (day.ids.indexOf(client.cardId) > -1) {
                clientVisits.visitDates.push(day.date);
            }
        }
        clientVisits.updateCounters();
        client.visits = clientVisits;
//        return clientVisits.visits.length > 0 ? clientVisits : null;
        return clientVisits;
    }

    public function generateSave():String {
        var s:String = Config.VERSION + Config.LINE_DELIMITER;
        for each (var visitDay:VisitDayVO in base) {
            s += visitDay + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    public function getPrev(day:VisitDayVO):VisitDayVO {
        var id:int = base.indexOf(day) - 1;
        if (id < 0) id = base.length - 1;
        return base[id];
    }

    public function getNext(day:VisitDayVO):VisitDayVO {
        var id:int = base.indexOf(day) + 1;
        if (id > base.length - 1) id = 0;
        return base[id];
    }

    public function getDates():Vector.<Date> {
        var vd:VisitDayVO;
        var v:Vector.<Date> = new Vector.<Date>();
        for each(vd in base){
            v.push(vd.date);
        }
        return v;
    }
}
}
