package windows {
import Events.CalendarEvent;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

import managers.VisitManager;
import managers.WindowManager;

import vo.VisitDayVO;

public class BaseWindow extends Sprite {
    protected var view:MovieClip;
    protected var wm:WindowManager;

    function BaseWindow(viewClass:Class) {
        view = new viewClass();
        addChild(view);
        wm = WindowManager.instance;
    }

    public function init(params:Object = null):void {

    }

    public function close():void {
        unInit();
        this.parent.removeChild(this);
    }

    protected function unInit():void {

    }

    protected function onMenu(event:MouseEvent):void {
        wm.ShowWindow(StartWindow);
    }

    protected function calendarDateSelected(event:CalendarEvent):void {
        var visitDay:VisitDayVO = VisitManager.instance.getDay(event.date);
        if (!visitDay) {
            wm.ShowPopup("За " + event.date.date + " число отчет отсутствует.");
            return;
        }
        wm.ShowWindow(ReportWindow, visitDay);
    }

    public function saveAdditionalParamsOnExit():Object {
        return {};
    }
}
}
