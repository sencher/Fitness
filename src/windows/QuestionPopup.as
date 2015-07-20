package windows {
import Events.PopupEvent;

import flash.display.Sprite;
import flash.events.MouseEvent;

import utils.Utils;

public class QuestionPopup extends Sprite {
    private var view:question_popup = new question_popup();
        private var _ok:Function;
        private var _cancel:Function;
    private var params:Object;

    public function QuestionPopup(params:Object, okCallback:Function = null, cancelCallback:Function = null) {
        addChild(view);
        _ok = okCallback;
        this.params = params;
        _cancel = cancelCallback;
        init(params.message);
    }

    public function init(message:String):void {
        view.info.htmlText = message;
        Utils.initButton(view.ok, onClick);
        Utils.initButton(view.cancel, onCancel);
    }

    private function onClick(event:MouseEvent):void {
        dispatchEvent(new PopupEvent(PopupEvent.CLOSE, true));
        if (_ok) _ok.apply(this, [params]);
    }

    private function onCancel(event:MouseEvent):void {
        dispatchEvent(new PopupEvent(PopupEvent.CLOSE, false));
        if (_cancel) _cancel.apply(this, [params]);
    }

    public function append(message:String):void {
        view.info.text += "\n" + message;
    }
}
}
