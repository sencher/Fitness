/**
 * Created by Пользователь on 17.02.14.
 */
package {
    import flash.display.Bitmap;

    import utils.Utils;

    public class ClientVO {
        private const BIRTH:String = "birth";
        private const PARAMS_PRIORITY:Array = ['cardId', 'firstName', 'secondName', 'thirdName', BIRTH, 'address',
            'phone', 'emergencyPhone', 'email', 'referral'];

        public static const FIELD_DELIMITER:String = ",";

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

        public var abonement:AbonementVO;

        public var comments:String;
        public var height:Number;
        public var weight:Number;

        private var param:String;


        public function ClientVO(params:String = null) {
            if (params) {
                var counter:int = 0;
                var array:Array = params.split(FIELD_DELIMITER);

                for each (param in PARAMS_PRIORITY) {
                    var nextParam:* = array.shift();

                    if(nextParam) {
                        if(param == BIRTH) {
                            this[param] = Utils.loadDate(nextParam);
                            continue;
                        }
                        this[param] = nextParam;
                    }
                }
            }
        }

        public function toString():String {
            var s:String = "";

            for each (param in PARAMS_PRIORITY) {
                if(param == BIRTH){
                    s += birth.getTime();
                    continue;
                }

                if(this[param]) s += this[param];
                s += FIELD_DELIMITER;
            }
            s = s.slice(0, s.length - 1);
            return s;
        }

        public function toStringFull():String{
            var s:String = "";

            for each (param in PARAMS_PRIORITY) {
                s += param + ":" + this[param] + FIELD_DELIMITER + " ";
            }
            s = s.slice(0, s.length - 1);
            return s;
        }

        public function valid():Boolean {
            return firstName.length > 1 &&
                    secondName.length > 1 &&
                    cardId > 0;
        }
    }
}
