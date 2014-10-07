package {
import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.OutputProgressEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

    import utils.Utils;

    import windows.InfoPopup;

public class DataBase {
    public static var base:Vector.<ClientVO> = new Vector.<ClientVO>();
    private static var wm:WindowManager = WindowManager.instance;

    public static function addClient(client:ClientVO):Boolean {
        if (!findDuplicates(client)) {
            base.push(client);
            base.sort(compare);
            save();
            return true;
        } else {
            return false;
        }
    }

    public static function updateClient(client:ClientVO):void {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.cardId == client.cardId) {
                oldClient = client;
                break;
            }
        }
        save();
    }

    private static function compare(c1:ClientVO, c2:ClientVO):int {
        return c1.cardId - c2.cardId;
    }

    private static function findDuplicates(newClient:ClientVO):ClientVO {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.firstName == newClient.firstName &&
                    oldClient.secondName == newClient.secondName ||
                    oldClient.cardId == newClient.cardId) {
                wm.ShowPopup( "Ошибка! Клиент уже есть в базе либо номер карты занят!" +
                "\n№ : " + oldClient.cardId + "\nФамилия : " + oldClient.secondName + "\nИмя : " + oldClient.firstName );
                return oldClient;
            }
        }
        return null;
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
            wm.ShowPopup("Нечего сохранять");
            return;
        }
        initFile(Config.CLIENTS);
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(generateClientsSave(base));
        fileStream.close();

        //save abonement
        initFile(Config.ABONEMENTS);
        fileStream = new FileStream();
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(generateAbonementsSave(base));
        fileStream.close();
        wm.ShowPopup("База сохранена : " + base.length + " записей");
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
        fileStream.addEventListener(ProgressEvent.PROGRESS, clientsStream_progressHandler);
        fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, outputProgressHandler);
        fileStream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
        fileStream.openAsync(file, FileMode.UPDATE);
    }

    private static function outputProgressHandler(event:OutputProgressEvent):void {
        wm.ShowPopup("output progress" + event.bytesPending + " " + event.bytesTotal);
    }

    private static function errorHandler(event:IOErrorEvent):void {
        wm.ShowPopup("IO_ERROR : " + event.errorID + " " + event.text);
    }

    private static function clientsStream_progressHandler(event:ProgressEvent):void {
        if(event.bytesLoaded < event.bytesTotal) return;
//        wm.ShowPopup(event.toString());
        var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, Config.ENCODING);
        trace(str);
        base = parse(str);
        fileStream.removeEventListener(ProgressEvent.PROGRESS, clientsStream_progressHandler);
        fileStream.close();
        wm.ShowPopup("База загружена : " + base.length + " записей");

        //load abonements
        initFile(Config.ABONEMENTS);
        fileStream.addEventListener(ProgressEvent.PROGRESS, abonementsStream_completeHandler);
        fileStream.openAsync(file, FileMode.UPDATE);
    }

    private static function initFile(path:String):void{
        file = File.applicationStorageDirectory;
        file = file.resolvePath(path);
//        wm.ShowPopup(file.nativePath);
    }

    private static function abonementsStream_completeHandler(event:ProgressEvent):void {
        if(event.bytesLoaded < event.bytesTotal) return;
        var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, Config.ENCODING);
        trace(str);
        parseAbonement(str);
        fileStream.removeEventListener(ProgressEvent.PROGRESS, abonementsStream_completeHandler);
        fileStream.close();
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