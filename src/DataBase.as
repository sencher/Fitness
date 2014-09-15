/**
 * Created by Пользователь on 17.02.14.
 */
package {
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

    import utils.Utils;

    import windows.InfoPopup;

public class DataBase {
    public static var base:Vector.<ClientVO> = new Vector.<ClientVO>();

    public static function addClient(client:ClientVO):Boolean {
        if (!findDuplicates(client)) {
            base.push(client);
            save();
            return true;
        } else {
            return false;
        }
    }

    private static function findDuplicates(newClient:ClientVO):Boolean {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.firstName == newClient.firstName &&
                    oldClient.secondName == newClient.secondName ||
                    oldClient.cardId == newClient.cardId) {
                new InfoPopup("Ошибка! Клиент уже есть в базе либо номер карты занят! " + oldClient.toStringFull());
                return true;
            }
        }
        return false;
    }


    public static function getClientById(id:int):ClientVO{
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.cardId == id) {
                return oldClient;
            }
        }
        return null;
    }

    public static function save():void {
        if(!base.length) {
            new InfoPopup("Нечего сохранять");
            return;
        }
        initFile(Config.CLIENTS);
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(generateClientsSave(base));
        fileStream.close();
        new InfoPopup("База сохранена : " + base.length + " записей");

        //save abonement
        initFile(Config.ABONEMENTS);
        fileStream = new FileStream();
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(generateAbonementsSave(base));
        fileStream.close();
//        new InfoWindow("База сохранена : " + base.length + " записей");
    }

    private static function generateClientsSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.VERSION + Config.CLIENT_DELIMITER;
        var client:ClientVO;
        for each (client in vector) {
            s += client + Config.CLIENT_DELIMITER;
        }
        s = s.slice(0, s.length-1);
        return s;
    }

    private static function generateAbonementsSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.VERSION + Config.CLIENT_DELIMITER;
        var client:ClientVO;
        for each (client in vector) {
            s += client.abonementString() + Config.CLIENT_DELIMITER;
        }
        s = s.slice(0, s.length-1);
        return s;
    }

    private static var file:File;
    private static var fileStream:FileStream;

    public static function load():void {

        initFile(Config.CLIENTS);
        fileStream = new FileStream();
        fileStream.addEventListener(Event.COMPLETE, clientsStream_completeHandler, false, 0, true);
        fileStream.openAsync(file, FileMode.UPDATE);
    }

    private static function clientsStream_completeHandler(event:Event):void {
        var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, Config.ENCODING);
        trace(str);
        base = parse(str);
        fileStream.removeEventListener(Event.COMPLETE, clientsStream_completeHandler);
        fileStream.close();
        new InfoPopup("База загружена : " + base.length + " записей");

        //load abonements
        initFile(Config.ABONEMENTS);
        fileStream.addEventListener(Event.COMPLETE, abonementsStream_completeHandler, false, 0, true);
        fileStream.openAsync(file, FileMode.UPDATE);
    }

    private static function initFile(path:String):void{
        file = File.applicationStorageDirectory;
        file = file.resolvePath(path);
    }

    private static function abonementsStream_completeHandler(event:Event):void {
        var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, Config.ENCODING);
        trace(str);
        parseAbonement(str);
//                base = parse(str);
        fileStream.removeEventListener(Event.COMPLETE, abonementsStream_completeHandler);
        fileStream.close();
//                new InfoWindow("База загружена : " + base.length + " записей");
    }

    private static function parseAbonement(str:String):void {
        var arrayAb:Array = str.split(Config.CLIENT_DELIMITER);
        arrayAb.shift();// ignore version tag
        var s:String;
        for each(s in arrayAb) {
            if (s.length) {
                var array:Array = s.split(Config.FIELD_DELIMITER);
                var client:ClientVO = getClientById(array.shift());
                var ab:AbonementVO = new AbonementVO();
                Utils.deSerialize(ab, array);
                client.abonement = ab;
            }
        }
    }

    private static function parse(fileStream:String):Vector.<ClientVO> {
        var array:Array = fileStream.split(Config.CLIENT_DELIMITER);
        array.shift();// ignore version tag
        var vector:Vector.<ClientVO> = new <ClientVO>[];
        var s:String;
        for each(s in array) {
            if (s.length) {
                var client:ClientVO = new ClientVO(s);
                vector.push(client);
            }
        }

        return vector;
    }
}
}
