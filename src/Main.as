/**
 * Created by Пользователь on 16.02.14.
 */
package {
import flash.display.Sprite;
import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.Utils;

import windows.ClientWindow;

[SWF(backgroundColor="0x95F0BB", width="1024", height="768")]
public class Main extends Sprite{
    public function Main() {
        DataBase.load();
        addChild(new ClientWindow(true));

        addVersion();
    }

    private function addVersion():void {
        var v:TextField = new TextField();
        v.text = "Version 0.1b";
        v.x = stage.stageWidth - v.textWidth - 10;
        v.y = stage.stageHeight - v.textHeight;
        addChild(v);
    }
}
}
