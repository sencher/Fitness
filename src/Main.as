/**
 * Created by Пользователь on 16.02.14.
 */
package {
import flash.display.Sprite;
import flash.events.MouseEvent;

import utils.Utils;

import windows.ClientWindow;

[SWF(backgroundColor="0x95F0BB", height="768")]
public class Main extends Sprite{
    public function Main() {
        DataBase.load();
        addChild(new ClientWindow(true));
    }
}
}
