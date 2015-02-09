package windows {
import Events.CalendarEvent;

import core.DataBase;

import flash.display.MovieClip;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.ui.Keyboard;

import managers.VisitManager;

import utils.Utils;

import vo.ClientVO;

public class ClientWindow extends BackableWindow {
    public const fields:Array = ['firstName', 'secondName', 'thirdName', 'cardId', 'address',
        'phone', 'emergencyPhone', 'email', 'referral', 'info', 'client_stage', 'visits', 'type',
        'birth', 'ab_start', 'ab_end', 'freeze_start', 'freeze_end', 'reg_day', 'address',
        'last_visit', 'pay_day', 'pay_value'];

    private const tab:Array = ['cardId', 'secondName', 'firstName', 'thirdName','birth', 'address', 'phone',
        'emergencyPhone', 'email', 'referral', 'info', 'type', 'ab_start', 'ab_end', 'freeze_start', 'freeze_end',
        'reg_day', 'pay_day', 'pay_value', 'last_visit', 'visit_range_start', 'visit_range_end'];

    private const dateComponent:Array = ['day', 'month', 'year'];
    private var _mainFocus:int = -1;
    private var subFocus:int = -1;
    private var _selection:*;

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
    public var pay_day:MovieClip;
    public var pay_value:TextField;

    private var client:ClientVO;
    private var newClient:Boolean;
    private var calendar:Calendar = new Calendar();


    public function ClientWindow() {
        super(client_window);
        Utils.copyFields(this, view);
        Utils.initButton(view.save, onSave);
        Utils.initButton(view.main_menu, onMenu);
        Utils.initButton(view.visit_range_button, onRange);
        Utils.initButton(view.payed, onPayed);
        Utils.initButton(view.status, status_mouseUpHandler);
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

    private function status_mouseUpHandler(event:MouseEvent):void {
        updateStatusView(true);
    }

    private function calendarRedraw(event:CalendarEvent):void {
        updateVisitsThisMonth();
    }

    private function onRange(event:MouseEvent = null):void {
        var r1:Date = Utils.collectDate(view.visit_range_start);
        var r2:Date = Utils.collectDate(view.visit_range_end);
        view.visits_range.text = calculateThisMonthVisits(r1, r2);
    }

    private function onPayed(event:MouseEvent = null):void {
        Utils.clearDate(pay_day);
        pay_value.text = '';
    }

    override protected function unInit():void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseDown);
    }

    override public function init(params:Object = null):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        Utils.clearTextFields(this);
        view.visits_month.text = '';

        client = params is ClientVO ? ClientVO(params) : new ClientVO();
        newClient = true;

        if (params) {
            updateNewClientStatus(params.cardId);
        }

        updateStatusView(client.scanned);

        if (!newClient && client.scanned) {
            VisitManager.instance.addVisit(client.cardId);
        }
        Utils.updateTextFields(this, client);
        Utils.updateTextFields(this, client.abonement);
        VisitManager.instance.getClientVisits(client);
        Utils.updateTextFields(this, client.visits);
        calendar.updateColors(client.visits.visitDates);
        updateVisitsThisMonth();
        resetFocus();
    }

    private function resetFocus():void {
        _selection = null;
        subFocus = -1;
        _mainFocus = -1;
        nextFocus();
    }

    private function onMouseDown(event:MouseEvent):void {
        var t:* = event.target;
        if(t is TextField && t.type == 'input'){
            updateFocus(t);
        }
    }

    private function updateFocus(tf:TextField):void {
        if(isDateComponent(tf)){
            subFocus = dateComponent.indexOf(tf.name);
            _mainFocus = tab.indexOf(tf.parent.name);
        }else{
            subFocus = -1;
            _mainFocus = tab.indexOf(tf.name);
        }
        _selection = tf;
    }

    private function isDateComponent(obj:*):Boolean{
        return obj && dateComponent.indexOf(obj.name) > -1;
    }

    private function onKey(event:KeyboardEvent):void {
        var keyCode:uint = event.keyCode;
        if(keyCode == Keyboard.TAB){
            event.preventDefault();
            nextFocus(event.shiftKey);
        }
    }

    private function nextFocus(back:Boolean = false):void {
        if(isDateComponent(selection)){
            back ? subFocus-- : subFocus++;
            if(subFocus < 0){
                mainFocus--;
            }else if(subFocus > 2){
                mainFocus++;
            }else{
                selection = selection.parent[dateComponent[subFocus]];
            }
        }else{
            back ? mainFocus-- : mainFocus++;
        }
    }

    private function focusTF(tf:TextField):void{
        stage.focus = tf;
        tf.setSelection(0, tf.text.length);
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
            }
        }
        return counter;
    }

    private function updateStatusView(showPopup:Boolean = false):void {
        var prefix:String = String(client.cardId + ' ' + client.firstName + ' ' + client.secondName + '\n\n');
        switch (client.status) {
            case ClientVO.FROZEN:
                if(showPopup) wm.ShowPopup(prefix + 'Абонемент заморожен до ' + Utils.dateToString(client.abonement.freeze_end) + '!');
                view.status.gotoAndStop(4);
                break;
            case ClientVO.NOT_PAYED:
                if(showPopup) wm.ShowPopup(prefix + Utils.dateToString(client.abonement.pay_day) + " просрочен платеж!\nДолг : " + client.abonement.pay_value + " рублей.");
                view.status.gotoAndStop(5);
                break;
            case ClientVO.PAY_WEEK:
                if(showPopup) wm.ShowPopup(prefix + Utils.dateToString(client.abonement.pay_day) + " день оплаты рассрочки!\nДолг : " + client.abonement.pay_value + " рублей.");
                view.status.gotoAndStop(5);
                break;
            case ClientVO.OUTDATED:
                if (showPopup) wm.ShowPopup(prefix + "Абонемент просрочен!");
                view.status.gotoAndStop(3);
                break;
            case ClientVO.WEEK:
                if (showPopup) wm.ShowPopup(prefix + "Осталось менее недели!");
                view.status.gotoAndStop(2);
                break;
            case ClientVO.TWO_WEEKS:
                if (showPopup) wm.ShowPopup(prefix + "Осталось менее 2 недель!");
                view.status.gotoAndStop(2);
                break;
            case ClientVO.VALID:
            default:
                view.status.gotoAndStop(1);
                break;
        }
    }

    private function updateNewClientStatus(id:int):Boolean {
        return newClient = id < 1 || !DataBase.instance.getClientById(id);
    }

    private function onSave(event:MouseEvent):void {
        var initId:uint = client.cardId;
        var saveId:uint = uint(cardId.text);
        if(initId > 0 && initId != saveId){
            DataBase.instance.changeClientId(initId, saveId);
        }
        Utils.collectTextFields(client, this);
        Utils.collectTextFields(client.abonement, this);
        VisitManager.instance.addVisit(client.cardId, Utils.collectDate(last_visit), false);

        client.updateStatus();

        if (!client.valid()) {
            wm.ShowPopup("Не заполнены обязательные поля!");
            return;
        }

        if (newClient) {
            if (DataBase.instance.addClient(client)) {
                wm.ShowPopup("Клиент сохранен!");
            }
        } else {
            wm.ShowPopup("Клиент обновлен!");
            DataBase.instance.updateClient(client)
        }
        wm.ShowPrevious();
    }

    public function get mainFocus():int {
        return _mainFocus;
    }

    public function set mainFocus(value:int):void {
        if(value > tab.length - 1) value = 0;
        else if(value < 0) value = tab.length -1;

        _mainFocus = value;

        selection = this.view.getChildByName(tab[_mainFocus]);
    }

    public function get selection():* {
        return _selection;
    }

    public function set selection(value:*):void {
        if(value is MovieClip){
            subFocus = 0;
            _selection = value[dateComponent[subFocus]];
        }else{
            _selection = value;
        }

        focusTF(_selection);
    }
}
}
