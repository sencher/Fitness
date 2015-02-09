package test {
import flash.display.Sprite;

import vo.ClientVO;

public class Test_Date extends Sprite {
    public var expire_date:Date;
    public var someDate:Date;

    public function Test_Date() {
        var my_date:Date;
        expire_date = new Date(2013, 12, 16);
//            trace(expire_date.time - my_date.time);
//            trace(my_date);
//            trace(expire_date);
//            trace("***********")
//            trace(expire_date.valueOf());
//
//            var value:Number = expire_date.valueOf();
//
//            var new_date:Date = new Date();
//            new_date.millisecondsUTC = value;
//            trace(new_date)
//            var t:* = expire_date.getTime()
//            trace(t);
//            new_date.setTime(t);
//            trace(new_date)
//            var z:Date = new Date(null,null,null,null,null,null,t);
//            trace(z);
//            var s:String = expire_date.toString();
//            var ss:Date = new Date(s);
//            trace(ss);

        var a:* = someDate is Date;
        trace(a);
        a = this['expire_date'] is Date;
        trace(a);
        var cl:ClientVO = new ClientVO();
        a = cl.birth is Date;
        trace(a);

//            a = my_date is Date;
//            trace(my_date.isPrototypeOf(new Date));
        trace(typeof my_date);

//            trace(my_date.getTime());
//            var date1:Date
        my_date = new Date(2015, 0, 1);
        trace(countDays(my_date, new Date()))
        my_date = new Date(2014, 0, 1);
        trace(countDays(my_date, new Date()))
        trace(countDays(new Date(), new Date()))
        trace(24 * 60 * 60 * 1000);

    }

    function countDays(startDate:Date, endDate:Date):int {
//            var oneDay:int = 24*60*60*1000; // hours*minutes*seconds*milliseconds
        var oneDay:int = 86400000;
        var diffDays:int = Math.round((startDate.getTime() - endDate.getTime()) / (oneDay));
        return diffDays;
    }
}
}
