/**
 * Created by Пользователь on 16.02.14.
 */
package {
import flash.display.Sprite;
import flash.events.MouseEvent;

import utils.Utils;

import windows.ClientWindow;

public class Main extends Sprite{
    public function Main() {
        DataBase.load();
        addChild(new ClientWindow(true));
        var saveBase = Utils.createButton(0xFF0000,50,50,"Save Base");
        saveBase.y = 200;
        saveBase.addEventListener(MouseEvent.CLICK, saveBase_clickHandler);
        addChild(saveBase);
    }

    private function saveBase_clickHandler(event:MouseEvent):void {
        DataBase.save();
    }
}
}
