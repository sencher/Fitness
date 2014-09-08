package windows {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.Utils;

    public class ClientWindow extends CancellableWindow {
        public var fields:Array = ['firstName','secondName','thirdName','cardId','address',
        'phone','emergencyPhone','email','referral','problems','days','visits','type','lastVisit'];

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

        private var client:ClientVO;


        public function ClientWindow(parent:Main, edit:Boolean = false) {
            super(parent, client_window);
            Utils.copyFields(this, view);
            view.save.addEventListener(MouseEvent.CLICK, onSave);

            cardId.text = String(int(Math.random() * 100));
        }

        override public function init(param:Object = null):void {
            client = param is ClientVO ? ClientVO(param) : new ClientVO();

            if(client.cardId){

            }
        }

        private function onSave(event:MouseEvent):void {
            client.firstName = firstName.text;
            client.secondName = secondName.text;
            client.thirdName = thirdName.text;

            client.cardId = uint(cardId.text);
            client.birth = Utils.collectDate(view.birth);
            client.address = address.text;
            client.phone = phone.text;
            client.emergencyPhone = emergencyPhone.text;
            client.email = email.text;
            client.referral = referral.text;
            client.problems = problems.text;

            client.abonement = new AbonementVO(view.ab_start, view.ab_end, view.freeze_start, view.freeze_end);

            if (!client.valid()) {
                new InfoPopup("Не заполнены все поля!");
                return;
            }

            if (DataBase.addClient(client)) {
                new InfoPopup("Клиент сохранен!");
                return;
            }

            DataBase.save();
        }
    }
}
