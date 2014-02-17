/**
 * Created by Пользователь on 16.02.14.
 */
package test {
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.filesystem.*;
import flash.events.Event;
import flash.ui.Keyboard;

[SWF(height="500", width="500")]
public class WithoutDialog extends Sprite {
    private var tf:TextField = new TextField();
    private var tf2:TextField = new TextField();

    public function WithoutDialog() {
        tf2.border = tf.border = true;
        tf2.type = tf.type = TextFieldType.INPUT;
        tf2.width = tf.width = 500;
        tf2.height = tf.height = 30;
        tf2.y = 50;
        addChild(tf);
        addChild(tf2);

        stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);

    }

    private function keyUp(e:KeyboardEvent):void {
        if(!e.ctrlKey) return;
        switch (e.keyCode){
            case Keyboard.R:
                read();
                break;
            case Keyboard.W:
                write(FileMode.WRITE);
                break;
            case Keyboard.A:
                write(FileMode.APPEND);
                break;
        }
    }

    public function read():void {
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath("test.txt");
        var fileStream:FileStream = new FileStream();
        fileStream.addEventListener(Event.COMPLETE, fileCompleteHandler)
        fileStream.openAsync(file, FileMode.READ);

        function fileCompleteHandler(event:Event):void {
            var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, File.systemCharset);
            tf.text = str;
            trace(str);
            fileStream.close();
        }
    }

    private function write(mode:String):void {
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath("test.txt");
        var fileStream:FileStream = new FileStream();
        fileStream.openAsync(file, mode);
        fileStream.writeUTFBytes(tf.text);
        fileStream.addEventListener(Event.CLOSE, fileClosed);
        fileStream.close();

        function fileClosed(event:Event):void {
            trace("closed");
        }
    }
}
}
