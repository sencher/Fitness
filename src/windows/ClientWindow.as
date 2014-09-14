package windows {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
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


        public function ClientWindow(parent:Main, edit:Boolean = false) {
            super(parent, client_window);
            Utils.copyFields(this, view);
            view.save.addEventListener(MouseEvent.CLICK, onSave);

            cardId.text = String(int(Math.random() * 100));
        }

        override public function init(params:Object = null):void {
            client = params is ClientVO ? ClientVO(params) : new ClientVO();

//            if(client.cardId){
                trace(client.cardId)
                Utils.updateTextFields(this, client);
//            }
        }

        private function onSave(event:MouseEvent):void {
            Utils.collectTextFields(client,this);
            var abonement:AbonementVO = new AbonementVO();
            Utils.collectTextFields(abonement,this);
            client.abonement = abonement;
//            client.abonement = new AbonementVO(view.ab_start, view.ab_end, view.freeze_start, view.freeze_end);

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
