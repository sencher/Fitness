package vo {
import utils.Utils;

public class AbonementVO {
    public const fields:Array = ['ab_start', 'ab_end', 'freeze_start', 'freeze_end', 'reg_day',
        'last_visit', 'type'];

    public var ab_start:Date;
    public var ab_end:Date;
    public var freeze_start:Date;
    public var freeze_end:Date;
    public var reg_day:Date;
    public var last_visit:Date; //TODO:Remove this

    public var type:String;

    public function AbonementVO(params:String = null) {
        if (params) {
            Utils.deSerialize(this, params);
        } else {
            reg_day = last_visit = new Date();
        }
    }

    public function toString():String {
        return Utils.serialize(this);
    }
}
}
