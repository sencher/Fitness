package windows {
import Events.CalendarEvent;

import core.DataBase;

<<<<<<< HEAD
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

import managers.VisitManager;

import utils.Utils;

import vo.ClientVO;

public class ClientWindow extends BackableWindow {
    public var fields:Array = ['firstName', 'secondName', 'thirdName', 'cardId', 'address',
        'phone', 'emergencyPhone', 'email', 'referral', 'info', 'client_stage', 'visits', 'type',
        'birth', 'ab_start', 'ab_end', 'freeze_start', 'freeze_end', 'reg_day', 'address',
        'last_visit'];

    public var firstName:TextField;
    public var secondName:TextField;
    public var thirdName:TextField;

    public var cardId:TextField;
    public var address:TextField;
    public var phone:TextField;
    public var emergencyPhone:TextField;
    public var email:TextField;
    public var referral:TextField;
    public var info:TextField;

    public var client_stage:TextField;
    public var visits:TextField;
    public var type:TextField;

    public var birth:MovieClip;
    public var ab_start:MovieClip;
    public var ab_end:MovieClip;
    public var freeze_start:MovieClip;
    public var freeze_end:MovieClip;
    public var reg_day:MovieClip;
    public var last_visit:MovieClip;

    private var client:ClientVO;
    private var newClient:Boolean;
    private var calendar:Calendar = new Calendar();


    public function ClientWindow() {
        super(client_window);
        Utils.copyFields(this, view);
        Utils.initButton(view.save, onSave);
        Utils.initButton(view.main_menu, onMenu);
        Utils.initButton(view.visit_range_button, onRange);
        calendar.x = 684;
        calendar.y = 434;
        calendar.scaleX = calendar.scaleY = 1.23;
        calendar.addEventListener(CalendarEvent.SELECTED, calendarDateSelected);
        calendar.addEventListener(CalendarEvent.REDRAW, calendarRedraw);
        addChild(calendar);

//        calendar.addEventListener(MouseEvent.MOUSE_DOWN, onD)
//        calendar.addEventListener(MouseEvent.MOUSE_UP, onU)
//        calendar.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRD)
//        calendar.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRU)
//        function onRU(event:MouseEvent):void {
//            if (event.ctrlKey)
//                calendar.scaleX = calendar.scaleY += 0.01;
//            else
//                calendar.scaleX = calendar.scaleY -= 0.01;
//        }
//
//        function onRD(event:MouseEvent):void {
//            wm.ShowPopup(String(calendar.scaleX), true);
//        }
//
//        function onU(event:MouseEvent):void {
//            calendar.stopDrag();
//            wm.ShowPopup(calendar.x + " " + calendar.y, true);
//        }
//
//        function onD(event:MouseEvent):void {
//            calendar.startDrag();
//        }
    }

    private function calendarRedraw(event:CalendarEvent):void {
        updateVisitsThisMonth();
    }

    private function onRange(event:MouseEvent = null):void {
        var r1:Date = Utils.collectDate(view.visit_range_start);
        var r2:Date = Utils.collectDate(view.visit_range_end);
        view.visits_range.text = calculateThisMonthVisits(r1, r2);
    }


    override public function init(params:Object = null):void {
        Utils.clearTextFields(this);
        client = params is ClientVO ? ClientVO(params) : new ClientVO();
        newClient = true;

        if (params) {
            updateNewClientStatus(params.cardId);
            updateStatusView(client.scanned);
        }

        if (!newClient && client.scanned) VisitManager.instance.addVisit(client.cardId);
        Utils.updateTextFields(this, client);
        Utils.updateTextFields(this, client.abonement);
        VisitManager.instance.getClientVisits(client);
        Utils.updateTextFields(this, client.visits);
        calendar.updateColors(client.visits.visitDates);
        updateVisitsThisMonth();
    }

    private function updateVisitsThisMonth():void {
        view.visits_month.text = calculateThisMonthVisits(new Date(calendar.currentYear, calendar.currentMonth), new Date(calendar.currentYear, calendar.currentMonth + 1, 0));
    }

    private function calculateThisMonthVisits(r1:Date, r2:Date):int {
        var visits:Vector.<Date> = client.visits.visitDates;

        if (visits && r1 && r2) {
            var d:Date;
            var counter:int;
            for each(d in visits) {
                if (Utils.isDateBetween(d, r1, r2)) counter++;
=======
    public class ClientWindow extends CancellableWindow {
        public var fields:Array = ['firstName','secondName','thirdName','cardId','address',
        'phone','emergencyPhone','email','referral','info','days','visits','type','lastVisit',
        'birth','ab_start', 'ab_end', 'freeze_start', 'freeze_end', 'reg_day', 'address',
        'last_visit'];

        public var firstName:TextField;
        public var secondName:TextField;
        public var thirdName:TextField;

        public var cardId:TextField;
        public var address:TextField;
        public var phone:TextField;
        public var emergencyPhone:TextField;
        public var email:TextField;
        public var referral:TextField;
        public var info:TextField;

        public var days:TextField;
        public var visits:TextField;
        public var type:TextField;
        public var lastVisit:TextField;

        public var birth:MovieClip;
        public var ab_start:MovieClip;
        public var ab_end:MovieClip;
        public var freeze_start:MovieClip;
        public var freeze_end:MovieClip;
        public var reg_day:MovieClip;
        public var last_visit:MovieClip;

        private var client:ClientVO;
        private var newClient:Boolean;


        public function ClientWindow() {
            super(client_window);
            Utils.copyFields(this, view);
            Utils.initButton(view.save, onSave);
        }

        override public function init(params:Object = null):void {
            Utils.clearTextFields(this);
            client = params is ClientVO ? ClientVO(params) : new ClientVO();
            newClient = true;

            if(params){
                updateNewClientStatus(params.cardId);
                Utils.updateTextFields(this, client.abonement);
                updateStatusView();
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
            }
        }
        return counter;
    }

<<<<<<< HEAD
    private function updateStatusView(showPopup:Boolean = false):void {
        switch (client.status) {
            case ClientVO.OUTDATED:
                if (showPopup) wm.ShowPopup("Абонемент просрочен!");
                view.status.gotoAndStop(3);
                break;
            case ClientVO.WEEK:
                if (showPopup) wm.ShowPopup("Осталось менее недели!");
                view.status.gotoAndStop(2);
                break;
            case ClientVO.TWO_WEEKS:
                if (showPopup) wm.ShowPopup("Осталось менее 2 недель!");
                view.status.gotoAndStop(2);
                break;
            case ClientVO.VALID:
                view.status.gotoAndStop(1);
                break;
            default:
                break;
=======
        private function updateStatusView(showPopup:Boolean = false):void {
            switch (client.status) {
                case ClientVO.OUTDATED:
                    if(showPopup) wm.ShowPopup("Абонемент просрочен!");
                    view.status.gotoAndStop(3);
                    break;
                case ClientVO.WEEK:
                    if(showPopup) wm.ShowPopup("Осталось менее недели!");
                    view.status.gotoAndStop(2);
                    break;
                case ClientVO.TWO_WEEKS:
                    if(showPopup) wm.ShowPopup("Осталось менее 2 недель!");
                    view.status.gotoAndStop(2);
                    break;
                case ClientVO.VALID:
                    view.status.gotoAndStop(1);
                    break;
                default:
                    break;
            }
        }

        private function updateNewClientStatus(id:int):void{
            newClient = id < 1 || !DataBase.getClientById(id);
            trace("new",newClient);
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
        }
    }

    private function updateNewClientStatus(id:int):Boolean {
        return newClient = id < 1 || !DataBase.instance.getClientById(id);
    }

    private function onSave(event:MouseEvent):void {
        Utils.collectTextFields(client, this);
        Utils.collectTextFields(client.abonement, this);

        //compatible
//        client.abonement.type = client.dummy3;

//            updateNewClientStatus(client.cardId);
<<<<<<< HEAD
        client.updateStatus();
//            updateStatusView(false);

        if (!client.valid()) {
            wm.ShowPopup("Не заполнены обязательные поля!");
            return;
        }
=======
            client.updateStatus();
//            updateStatusView(false);

            if (!client.valid()) {
                wm.ShowPopup("Не заполнены обязательные поля!");
                return;
            }
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8

        if (newClient) {
            if (DataBase.instance.addClient(client)) {
                wm.ShowPopup("Клиент сохранен!");
            }
<<<<<<< HEAD
        } else {
            wm.ShowPopup("Клиент обновлен!");
            DataBase.instance.updateClient(client)
=======
            wm.ShowPrevious();
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
        }
        wm.ShowPrevious();
    }
}
}
