package {
    import flash.text.TextField;

    import utils.Utils;

    public class AbonementVO {
        public const fields:Array = ['ab_start', 'ab_end', 'freeze_start', 'freeze_end', 'reg_day',
            'last_visit'];

        public var ab_start:Date;
        public var ab_end:Date;
        public var freeze_start:Date;
        public var freeze_end:Date;
        public var reg_day:Date;
        public var last_visit:Date;

//        public var days:String;
//        public var visits:String;
//        public var type:String;

//        public var visits:Vector.<Date> = new <Date>[];

        public function AbonementVO(params:String = null) {
            if (params) {
                Utils.deSerialize(this, params);
            }else{
                reg_day = last_visit = new Date();
            }
        }


        public function toString():String {
            return Utils.serialize(this);
        }

        private function ext(d:Date):String {
            if(!d) return "";
            return d.getTime() + Config.FIELD_DELIMITER;
        }

    }
}
