package windows {
import flash.events.MouseEvent;

import utils.Utils;

public class BackableWindow extends BaseWindow {
    public function BackableWindow(viewClass:Class) {
        super(viewClass);
        Utils.initButton(view.back, onBack);
    }


    private function onBack(event:MouseEvent = null):void {
        wm.ShowPrevious();
    }
}
}
