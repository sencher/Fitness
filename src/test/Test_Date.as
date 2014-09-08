package test {
    import flash.display.Sprite;

    public class Test_Date extends Sprite{
        public var expire_date:Date;
        public var someDate:Date;
        public function Test_Date() {
            var my_date:Date = new Date();
            expire_date = new Date(2013,12,16);
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
        }
    }
}
