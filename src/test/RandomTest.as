/**
 * Created by M1.SenCheR on 14.11.14.
 */
package test {
import flash.display.Sprite;

public class RandomTest extends Sprite{
    public function RandomTest() {
        var arr:Array = [6,7,8,9];
        for (var i:int =0; i< 100; i++){
            trace(arr[int(Math.random() * arr.length)]);
        }
    }
}
}
