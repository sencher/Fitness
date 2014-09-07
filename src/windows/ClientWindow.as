package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.Utils;

    public class ClientWindow extends Sprite {
    private var view:MovieClip = new client_view();
    private var firstName:TextField = view.firstName;
    private var secondName:TextField = view.secondName;
    private var thirdName:TextField = view.thirdName;

    private var cardId:TextField = view.cardId;
    private var address:TextField = view.address;
    private var phone:TextField = view.phone;
    private var emergencyPhone:TextField = view.emergencyPhone;
    private var email:TextField = view.email;
    private var referral:TextField = view.referral;
    private var problems:TextField = view.problems;

    private var days:TextField = view.days;
    private var visits:TextField = view.visits;
    private var type:TextField = view.type;


    public function ClientWindow(edit:Boolean = false) {
        addChild(view);
        view.save.addEventListener(MouseEvent.CLICK, onSave);
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

        if(!client.valid()) {
            new InfoWindow("Не заполнены все поля!");
            return;
        }

        if(DataBase.addClient(client)){
            new InfoWindow("Клиент сохранен!");
            return;
        }

        DataBase.save();
    }
}
}
