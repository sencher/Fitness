/**
 * Created by M1.SenCheR on 05.11.14.
 */
package test {
import flash.display.Sprite;

public class ArrayTest extends Sprite {
    public function ArrayTest() {
        var array:Array = [0, 1, 2, 3, 4, 5, 6, 7];
        var i:* = array.pop();
        trace(i, array)
        i = array.unshift(8);
        trace(i, array)
        i = array.shift();
        trace(i, array)
        i = array.push(9);
        trace(i, array)
    }
}
}
