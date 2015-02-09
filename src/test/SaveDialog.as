/**
 * Created by Пользователь on 16.02.14.
 */
package test {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.text.TextField;
import flash.text.TextFieldType;

public class SaveDialog extends Sprite {
    public function SaveDialog() {
        var MyTextField:TextField = new TextField();
        var MyButtonField:TextField = new TextField();
        var MyFile:FileReference = new FileReference();

        MyTextField.border = true;
        MyTextField.type = TextFieldType.INPUT;

        MyButtonField.background = true;
        MyButtonField.backgroundColor = 0x339933;
        MyButtonField.x = 150;
        MyButtonField.height = 20;
        MyButtonField.text = "Click here to save";

        addChild(MyTextField);
        addChild(MyButtonField);
        MyButtonField.addEventListener(MouseEvent.CLICK, clickhandler);

        function clickhandler(e:MouseEvent):void {
            MyFile.save(MyTextField.text);
        }

    }
}
}
