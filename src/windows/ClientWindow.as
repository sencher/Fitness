package windows {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class ClientWindow extends Sprite {
    private var view:MovieClip = new client_view();
    private var firstName:TextField = view.firstName;
    private var secondName:TextField = view.secondName;
    private var thirdName:TextField = view.thirdName;

    private var cardId:TextField = view.cardId;
    private var birthD:TextField = view.birthD;
    private var birthM:TextField = view.birthM;
    private var birthY:TextField = view.birthY;
    private var address:TextField = view.address;
    private var phone:TextField = view.phone;
    private var emergencyPhone:TextField = view.emergencyPhone;
    private var email:TextField = view.email;
    private var referral:TextField = view.referral;

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
        fillBirthday(client);
        client.address = address.text;
        client.phone = phone.text;
        client.emergencyPhone = emergencyPhone.text;
        client.email = email.text;
        client.referral = referral.text;

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

    private function fillBirthday(client:ClientVO):Boolean {
        var d:uint = uint(birthD.text);
        var m:uint = uint(birthM.text);
        var y:uint = uint(birthY.text);

        if(y < 20)
            y += 2000;
        else if(y > 21 && y < 100)
            y += 1900;

        if ( d > 0 && d < 32 && m > 0 && m < 13 && y > 1900 && y < 2010 ){
            client.birth = new Date(y, m-1, d);
            return true;
        }else{
            new InfoWindow("Формат дня рожденья : 31 12 85");
            return false;
        }
    }
}
}
