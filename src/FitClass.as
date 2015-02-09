package {
import core.Config;
import core.DataBase;

import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.ui.Keyboard;

import managers.VisitManager;
import managers.WindowManager;

import vo.ClientVO;

import windows.ClientWindow;
import windows.StartWindow;

[SWF(backgroundColor="0xFAA719", width="1024", height="768")]
public class FitClass extends Sprite {

    private var wm:WindowManager = WindowManager.instance;
    private var stringId:String = "";
    private var debug:TextField = new TextField();

    public function FitClass() {
//            this.width = Capabilities.screenResolutionX;
//            this.height = Capabilities.screenResolutionY;
//            this.stage.align = StageAlign.TOP_LEFT;
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        if (!Config.DEBUG) this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

        DataBase.instance.load();
        addChild(new bg());
        addChild(wm);
        wm.ShowWindow(StartWindow);
        addVersion();
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        stage.addEventListener(Event.REMOVED_FROM_STAGE, restoreFocus);
        stage.addEventListener(Event.REMOVED, restoreFocus);

        if (Config.DEBUG) {
            addChild(debug);
        }
    }

    private function restoreFocus(event:Event):void {
        stage.focus = stage;
    }

    private function addVersion():void {
        var v:TextField = new TextField();
        v.text = "Version " + Config.VERSION;
        v.x = stage.stageWidth - v.textWidth - 10;
        v.y = stage.stageHeight - v.textHeight;
        addChild(v);
    }

    private function onKey(event:KeyboardEvent):void {
        var keyCode:uint = event.keyCode;
        if (Config.DEBUG) {
            debug.text = String(keyCode);
        }

        if (keyCode == Keyboard.ESCAPE) {
            event.preventDefault();
            wm.ShowPrevious();
        } else if (keyCode > 47 && keyCode < 58) {
            stringId += keyCode - 48;
        } else if (keyCode == Keyboard.ENTER) {
            recognize(stringId);
            stringId = "";
        }

        if(Config.DEBUG){
            if (keyCode == Keyboard.F12) {
                recognize(String(2410000000000 + int(stringId) * 10));
                stringId = "";
            } else if (keyCode == Keyboard.F11) {
                recognize("2410000003273");
            } else if (keyCode == Keyboard.F10) {
                VisitManager.instance.addVisit(115, new Date(2014, 10, int(Math.random() * 30)));
            }
    //            trace(stringId);
        }
    }

    private function recognize(string:String):void {
        if (string.length >= 13) {
            var id:String = string.substr(string.length - 4, 3);
            var clientVO:ClientVO = DataBase.instance.getClientById(int(id)) || new ClientVO(id);
            clientVO.scanned = true;
            wm.ShowWindow(ClientWindow, clientVO);
        }
    }
}
}
