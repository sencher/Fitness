/**
 * Created by M1.SenCheR on 04.11.14.
 */
package test {
import flash.display.Sprite;

public class DateToNumber extends Sprite {
    public function DateToNumber() {
        var num:String = "12345678912345";
        var date:Date = new Date("Wed Jul 12 15:05:30 GMT+0400 1972");
        date.setTime(num);
        trace(date.getTime());
        var ds:String = date.toString();
        trace(ds);
        date = new Date(ds);


//        var date:Date = new Date();
//        date.setTime(40);
        trace(date.getTime());
    }
}
}
