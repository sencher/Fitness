package windows {
import Events.CalendarEvent;

import components.ReportRow;

import core.DataBase;

import flash.events.MouseEvent;

import managers.VisitManager;

import utils.Utils;

import vo.VisitDayVO;

public class ReportWindow extends ListWindow {

    private var visitDay:VisitDayVO;
    protected var calendar:Calendar = new Calendar();
    private var vm:VisitManager;

    public function ReportWindow() {
        rowClass = ReportRow;

        super(report_window);

        Utils.initButton(view.left, onLeft);
        Utils.initButton(view.right, onRight);

        calendar.x = 675;
        calendar.y = 245;
        calendar.scaleX = calendar.scaleY = 1.5;
        calendar.addEventListener(CalendarEvent.SELECTED, calendarDateSelected);
        addChild(calendar);
        vm = VisitManager.instance;
    }


    override public function init(params:Object = null):void {
        visitDay = VisitDayVO(params);
        if (!visitDay) return;

        itemList = visitDay.ids;

        var current:Date = visitDay.date;
        calendar.updateColors(vm.getDates(), current);
        view.date.text = Utils.dateToString(current);
        view.clients.text = itemList.length;
        super.init(params);
    }

    override protected function updateRow(counter:int, i:int):void {
        var curRow:* = rowsView[counter];
        curRow.update(DataBase.instance.getClientById(itemList[i]));
        curRow.num.text = String(i + 1);
        curRow.visit_time.text = String(visitDay.times[i]);
    }

    private function onLeft(event:MouseEvent = null):void {
        visitDay = vm.getPrev(visitDay);
        wm.ShowWindow(ReportWindow, visitDay);
    }

    private function onRight(event:MouseEvent = null):void {
        visitDay = vm.getNext(visitDay);
        wm.ShowWindow(ReportWindow, visitDay);
    }
}
}
