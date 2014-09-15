package windows {
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.Utils;

    public class ClientWindow extends CancellableWindow {
        public var fields:Array = ['firstName','secondName','thirdName','cardId','address',
        'phone','emergencyPhone','email','referral','problems','days','visits','type','lastVisit',
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
        public var problems:TextField;

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


        public function ClientWindow() {
            super(client_window);
            Utils.copyFields(this, view);
            view.save.addEventListener(MouseEvent.CLICK, onSave);

            cardId.text = String(int(Math.random() * 100));
        }

        override public function init(params:Object = null):void {
            Utils.clearTextFields(this);
            view.status.gotoAndStop(1);
            client = params is ClientVO ? ClientVO(params) : new ClientVO();


            if(params){
                Utils.updateTextFields(this, client.abonement);

                switch(client.status){
                    case ClientVO.OUTDATED:
                        wm.ShowPopup("Абонемент просрочен!");
                        view.status.gotoAndStop(3);
                        break;
                    case ClientVO.WEEK:
                        wm.ShowPopup("Осталось менее недели!");
                        view.status.gotoAndStop(2);
                        break;
                    case ClientVO.TWO_WEEKS:
                        wm.ShowPopup("Осталось менее 2 недель!");
                        view.status.gotoAndStop(2);
                        break;
                    case ClientVO.VALID:
                        break;
                    default:
                        break;
                }
            }
            trace(client.cardId);
            Utils.updateTextFields(this, client);
            Utils.updateTextFields(this, client.abonement);
        }

        private function onSave(event:MouseEvent):void {
            Utils.collectTextFields(client,this);
            Utils.collectTextFields(client.abonement,this);

            if (!client.valid()) {
                wm.ShowPopup("Не заполнены все поля!");
                return;
            }

            if (DataBase.addClient(client)) {
                wm.ShowPopup("Клиент сохранен!");
                return;
            }

            DataBase.save();
        }
    }
}
