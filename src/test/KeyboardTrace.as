package test {
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.text.TextField;

public class KeyboardTrace extends Sprite {
    private var tf:TextField = new TextField();

    public function KeyboardTrace() {
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);

        addChild(tf);
        tf.height = stage.stageHeight;
        tf.width = stage.stageWidth;
        tf.border = true;
    }

    private function onKeyUp(event:KeyboardEvent):void {
        tf.appendText(String(event.keyCode) + "\n");
    }
}
}
