/**
 * Created by M1.SenCheR on 09.11.14.
 */
package vo {
public class Time {

    private static const DELIMITER:String = ":";

    public var hours:int;
    public var minutes:int;

    public function Time(h:int = 0, m:int = 0) {
        hours = h;
        minutes = m;
    }


    public function parse(s:String):void{
        var array:Array = s.split(DELIMITER);
        hours = array[0];
        minutes = array[1];
    }

    public function toString():String{
        var s:String = "";
        s += hours < 10 ? "0" + hours : String(hours);
        s += DELIMITER;
        s += minutes < 10 ? "0" + minutes : String(minutes);
        return s;
    }
}
}
