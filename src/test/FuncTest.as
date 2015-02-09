/**
 * Created by M1.SenCheR on 08.11.14.
 */
package test {
import flash.display.Sprite;

public class FuncTest extends Sprite {
    public function FuncTest() {
        var array = [func];
        array[0]("YO!");
    }

    private function func(s:String):void {
        trace("Bla " + s);
    }
}
}
