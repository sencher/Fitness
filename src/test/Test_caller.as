package test {
import flash.display.Sprite;

public class Test_caller extends Sprite {


    public function Test_caller():void {

        init();

    }


    private function init():void {

        trace(DebugUtil.getCallerInfo("here", true));

        trace(DebugUtil.getCallingInfo("here", true));

    }


}
}
