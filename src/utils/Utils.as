/**
 * Created by Пользователь on 17.02.14.
 */
package utils {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

public class Utils {
    public static function createButton(color:uint, h:uint, w:uint, text:String = "Button"):Sprite {
        var mc:MovieClip = new MovieClip();
        with (mc) {
            graphics.beginFill(color, 0.7);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();

            var label:TextField = new TextField();
            label.text = text;
            label.selectable = false;
            addChild(label);

            buttonMode = true;
            mouseChildren = false;
        }
        return mc;
    }
}
}
