package {
    import flash.display.Sprite;

    public class Test_Date extends Sprite{
        public function Test_Date() {
            var my_date:Date = new Date();
            var expire_date:Date = new Date(2013,12,16);
            trace(expire_date.time - my_date.time);
            trace(my_date);
            trace(expire_date);

//            trace(expire_date.toDateString());
//            trace(expire_date.toLocaleDateString());
//            trace(expire_date.toLocaleString());
//            trace(expire_date.toLocaleTimeString());
//            trace(expire_date.toString());
//            trace(expire_date.toTimeString());
//            trace(expire_date.toUTCString());
            trace("***********")
            trace(expire_date.valueOf());

            var value:Number = expire_date.valueOf();

            var new_date:Date = new Date();
//            new_date.setMilliseconds(value);
            new_date.millisecondsUTC = value;
            trace(new_date)
            var t:* = expire_date.getTime()
            trace(t);
            new_date.setTime(t);
            trace(new_date)
            var z:Date = new Date(null,null,null,null,null,null,t);
            trace(z);
            var s:String = expire_date.toString();
            var ss:Date = new Date(s);
            trace(ss);

        }
    }
}
