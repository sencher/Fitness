package core {
public class Config {
    public static const CLIENTS:String = "clients.txt";
    public static const ABONEMENTS:String = "abonements.txt";
    public static const VISITS:String = "visits.txt";
    public static const ENCODING:String = "utf-8";
    public static const FIELD_DELIMITER:String = "●";
    public static const LINE_DELIMITER:String = "█";
    public static const DATE_SPECIAL:String = "½";
    public static const VERSION:String = "11.2.15";
    public static const DEBUG:Boolean = false;

    public static var saveVersion:String = "";

    public static function getSaveHeader():String
    {
        var date:Date = new Date();
        return VERSION + FIELD_DELIMITER + date.date + "/" + date.month+1 + "/" + date.fullYear + LINE_DELIMITER;
    }
}
}
