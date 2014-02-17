/**
 * Created by Пользователь on 16.02.14.
 */
package windows {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;

import utils.Utils;

public class ClientWindow extends Sprite {
    private var cardIdTf:TextField = new TextField();
    private var firstNameTf:TextField = new TextField();
    private var secondNameTf:TextField = new TextField();
    private var _edit:Boolean;
    private var counter:int;
    private const STEP:int = 50;

    public function ClientWindow(edit:Boolean = false) {
        _edit = edit;
        initTextField(cardIdTf);
        initTextField(firstNameTf);
        initTextField(secondNameTf);
        var saveButton:Sprite = Utils.createButton(0xFF0000,50,50,"Save");
        saveButton.addEventListener(MouseEvent.CLICK, onSave);
        saveButton.x = 450;
        addChild(saveButton);
    }

    private function onSave(event:MouseEvent):void {
        var client:ClientVO = new ClientVO();
        client.firstName = firstNameTf.text;
        client.secondName = secondNameTf.text;
        client.cardId = uint(cardIdTf.text);

        if(!client.valid()) {
            new InfoWindow("Не заполнены все поля!");
            return;
        }

        if(DataBase.addClient(client))
            new InfoWindow("Клиент сохранен!");
        else
            new InfoWindow("Ошибка! Клиент уже есть в базе либо номер карты занят!");
    }

    private function initTextField(tf:TextField):void {
        tf.border = true;
        tf.text = tf.name;
        tf.width = 300;
        tf.height = 30;
        tf.y = counter++ * STEP;
        if (_edit) tf.type = TextFieldType.INPUT;
        addChild(tf);
    }
}
}
