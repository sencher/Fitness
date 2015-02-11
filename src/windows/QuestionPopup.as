package windows {
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    import managers.WindowManager;

    import utils.Utils;

    public class QuestionPopup extends Sprite {
    private var view:question_popup = new question_popup();
        private var _ok:Function;
        private var _cancel:Function;

    public function QuestionPopup(message:String, okCallback:Function, cancelCallback:Function = null) {
        addChild(view);
        _ok = okCallback;
        _cancel = cancelCallback;
        init(message);
    }

    public function init(message:String):void {
        view.info.text = message;
        Utils.initButton(view.ok, onClick);
        Utils.initButton(view.cancel, onCancel);
    }

    private function onClick(event:MouseEvent):void {
        WindowManager.instance.CloseQuestionPopup();
        _ok.call();
    }

    private function onCancel(event:MouseEvent):void {
        WindowManager.instance.CloseQuestionPopup();
        if(_cancel) _cancel.call();
    }

    public function append(message:String):void {
        view.info.text += "\n" + message;
    }
}
}
