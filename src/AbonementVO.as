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
            s += extract(start) + extract(start);
            return s;
        }

        private function extract(d:Date):String {
            return d.getTime() + ClientVO.FIELD_DELIMITER;
        }

    }
}
