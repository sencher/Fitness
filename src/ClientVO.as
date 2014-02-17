/**
 * Created by Пользователь on 17.02.14.
 */
package {
public class ClientVO {
    private const PARAMS_PRIORITY:Array = ['cardId','firstName','secondName'];
    public var firstName:String;
    public var secondName:String;
    public var comments:String;
    public var birth:Date;
    public var pay:Date;
    public var height:Number;
    public var weight:Number;
    public var cardId:uint;


    public function ClientVO() {
    }

    public function toString():String {
//        return firstName + DataBase.FIELD_DELIMITER + secondName;
        var s:String = "";
        var param:String;
        for each (param in PARAMS_PRIORITY){
            s += this[param] + DataBase.FIELD_DELIMITER;
        }
        s = s.slice(0, s.length-1);
        return s;
    }

    public function valid():Boolean {
        return firstName.length > 1 &&
                secondName.length > 1 &&
                cardId > 0;
    }
}
}
