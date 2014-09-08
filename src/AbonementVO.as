package {
    import utils.Utils;

    public class AbonementVO {
        public var start:Date;
        public var end:Date;
        public var freezeStart:Date;
        public var freezeEnd:Date;
        public var visits:Vector.<Date> = new <Date>[];

        public function AbonementVO(ab_start, ab_end, freeze_start, freeze_end) {
            start = Utils.CollectDate(ab_start);
            end = Utils.CollectDate(ab_end);
            freezeStart = Utils.CollectDate(freeze_start);
            freezeEnd = Utils.CollectDate(freeze_end);
        }


        public function toString():String {
            var s:String = "";
            s += ext(start) + ext(end) + ext(freezeStart) + ext(freezeEnd);
            var d:Date;
            for each (d in visits){
                s += ext(d);
            }
            return s;
        }

        private function ext(d:Date):String {
            if(!d) return "";
            return d.getTime() + ClientVO.FIELD_DELIMITER;
        }

    }
}
