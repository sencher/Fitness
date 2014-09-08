package windows {
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.Utils;

    public class ClientWindow extends CancellableWindow {

        private var firstName:TextField;
        private var secondName:TextField;
        private var thirdName:TextField;

        private var cardId:TextField;
        private var address:TextField;
        private var phone:TextField;
        private var emergencyPhone:TextField;
        private var email:TextField;
        private var referral:TextField;
        private var problems:TextField;

        private var days:TextField;
        private var visits:TextField;
        private var type:TextField;


        public function ClientWindow(parent:Main, edit:Boolean = false) {
            super(parent, client_window);
            Init();
            view.save.addEventListener(MouseEvent.CLICK, onSave);

            cardId.text = String(int(Math.random() * 100));
        }

        private function Init():void {
            firstName = view.firstName;
            secondName = view.secondName;
            thirdName = view.thirdName;

            cardId = view.cardId;
            address = view.address;
            phone = view.phone;
            emergencyPhone = view.emergencyPhone;
            email = view.email;
            referral = view.referral;
            problems = view.problems;

            days = view.days;
            visits = view.visits;
            type = view.type;
        }

        private function onSave(event:MouseEvent):void {
            var client:ClientVO = new ClientVO();
            client.firstName = firstName.text;
            client.secondName = secondName.text;
            client.thirdName = thirdName.text;

            client.cardId = uint(cardId.text);
            client.birth = Utils.CollectDate(view.birth);
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
