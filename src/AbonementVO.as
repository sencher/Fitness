package {
    import flash.text.TextField;

    import utils.Utils;

    public class AbonementVO {
        public const fields:Array = ['ab_start', 'ab_end', 'freeze_start', 'freeze_end', 'reg_day', 'address',
            'last_visit'];

        public var ab_start:Date;
        public var ab_end:Date;
        public var freeze_start:Date;
        public var freeze_end:Date;
        public var reg_day:Date;
        public var last_visit:Date;

        public var days:String;
//        public var visits:String;
        public var type:String;

        public var visits:Vector.<Date> = new <Date>[];

        public function AbonementVO() {

        }


        public function toString():String {
            var s:String = "";
//            s += ext(start) + ext(end) + ext(freezeStart) + ext(freezeEnd);
//            var d:Date;
//            for each (d in visits){
//                s += ext(d);
//            }
            return s;
        }

        private function ext(d:Date):String {
            if(!d) return "";
            return d.getTime() + ClientVO.FIELD_DELIMITER;
        }

    }
}
