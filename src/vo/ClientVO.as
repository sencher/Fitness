/**
 * Created by Пользователь on 17.02.14.
 */
package vo {
import core.Config;

import flash.display.Bitmap;

import utils.Utils;

public class ClientVO {
    public const fields:Array = ['cardId', 'firstName', 'secondName', 'thirdName', "birth", 'address',
        'phone', 'emergencyPhone', 'email', 'referral', 'info', 'dummy1', 'dummy2', 'dummy3', 'dummy4'];

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
    public var info:String;
    public var dummy1:String; //TODO:Remove this
    public var dummy2:String; //TODO:Remove this
    public var dummy3:String; //TODO:Remove this
    public var dummy4:String; //TODO:Remove this

    private var _abonement:AbonementVO = new AbonementVO();
    public var visits:ClientVisitsVO;

    public var comments:String;
    public var height:Number;
    public var weight:Number;

    private var param:String;

    public var status:String;
    public var scanned:Boolean;

    public static const VALID:String = "valid";
    public static const TWO_WEEKS:String = "two_weeks";
    public static const WEEK:String = "week";
    public static const OUTDATED:String = "outdated";
    public static const NOT_PAYED:String = 'not_payed';
    public static const PAY_WEEK:String = 'pay_week';
    public static const FROZEN:String = 'frozen';


    public function ClientVO(params:String = null) {
        if (params) {
            Utils.deSerialize(this, params);
        }
    }

    public function toString():String {
        return Utils.serialize(this);
    }

//        public function toStringFull():String{
//            var s:String = "";
//
//            for each (param in fields) {
//                s += param + ":" + this[param] + Config.FIELD_OLD + " ";
//            }
//            s = s.slice(0, s.length - 1);
//            return s;
//        }

    public function valid():Boolean {
        return firstName.length > 1 &&
                secondName.length > 1 &&
                cardId > 0;
    }

    public function abonementString():String {
        return cardId + Config.FIELD_DELIMITER + _abonement;
    }

    public function get abonement():AbonementVO {
        return _abonement;
    }

    public function set abonement(value:AbonementVO):void {
        _abonement = value;
        updateStatus();
    }

    public function updateStatus():void {
        if(_abonement.pay_day){
            var payLeft:int = Utils.countDays(_abonement.pay_day);
            if(payLeft < 0){
                status = NOT_PAYED;
                return;
            }else if(payLeft < 10){
                status = PAY_WEEK;
                return;
            }
        }

        var daysLeft:int = Utils.countDays(_abonement.ab_end);
        if (daysLeft < 0) {
            status = OUTDATED;
            return;
        } else if (daysLeft < 7) {
            status = WEEK;
        } else if (daysLeft < 15) {
            status = TWO_WEEKS;
        } else {
            status = VALID;
        }

        if(Utils.isDateBetween(new Date(), _abonement.freeze_start, _abonement.freeze_end)){
            status = FROZEN;
        }
    }
}
}
