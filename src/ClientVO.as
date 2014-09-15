/**
 * Created by Пользователь on 17.02.14.
 */
package {
    import flash.display.Bitmap;

    import utils.Utils;

    import windows.InfoPopup;

    public class ClientVO {
        public const fields:Array = ['cardId', 'firstName', 'secondName', 'thirdName', "birth", 'address',
            'phone', 'emergencyPhone', 'email', 'referral', 'problems','days','visits','type','lastVisit'];



        public var cardId:uint;
        public var photo:Bitmap;

        public var firstName:String;
        public var secondName:String;
        public var thirdName:String;

        public var birth:Date;
        public var address:String;
        public var phone:String;
        public var emergencyPhone:String;
        public var email:String;
        public var referral:String;
        public var problems:String;
        public var days:String;
        public var visits:String;
        public var type:String;
        public var lastVisit:String;

        private var _abonement:AbonementVO = new AbonementVO();

        public var comments:String;
        public var height:Number;
        public var weight:Number;

        private var param:String;

        public var status:String;
        public static const VALID:String = "valid";
        public static const TWO_WEEKS:String = "two_weeks";
        public static const WEEK:String = "week";
        public static const OUTDATED:String = "outdated";


        public function ClientVO(params:String = null) {
            if (params) {
                Utils.deSerialize(this, params);
            }
        }

        public function toString():String {
            return Utils.serialize(this);
        }

        public function toStringFull():String{
            var s:String = "";

            for each (param in fields) {
                s += param + ":" + this[param] + Config.FIELD_DELIMITER + " ";
            }
            s = s.slice(0, s.length - 1);
            return s;
        }

        public function valid():Boolean {
            return true;
//            return firstName.length > 1 &&
//                    secondName.length > 1 &&
//                    cardId > 0;
        }

        public function abonementString():String {
            return cardId + Config.FIELD_DELIMITER + _abonement;
        }

        public function get abonement():AbonementVO {
            return _abonement;
        }

        public function set abonement(value:AbonementVO):void {
            _abonement = value;
            var daysLeft:int = Utils.countDays(_abonement.ab_end, new Date());
            if( daysLeft < 0){
                status = OUTDATED;
            }else if( daysLeft < 7 ){
                status = WEEK;
            }else if( daysLeft < 15 ){
                status = TWO_WEEKS;
            }else{
                status = VALID;
            }
        }
    }
}
