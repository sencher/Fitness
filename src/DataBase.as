/**
 * Created by Пользователь on 17.02.14.
 */
package {
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import windows.InfoWindow;

public class DataBase {
    private static const CLIENT_DELIMITER:String = ";";

    private static var base:Vector.<ClientVO> = new Vector.<ClientVO>();

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
                new InfoWindow("Ошибка! Клиент уже есть в базе либо номер карты занят! " + oldClient.toStringFull());
                return true;
            }
        }
        return false;
    }

    public static function save():void {
        if(!base.length) {
            new InfoWindow("Нечего сохранять");
            return;
        }
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath(Config.DATABASE);
        var fileStream:FileStream = new FileStream();
        fileStream.open(file, FileMode.WRITE);
        fileStream.writeUTFBytes(generateSave(base));
        fileStream.close();
        new InfoWindow("База сохранена : " + base.length + " записей");
    }

    private static function generateSave(vector:Vector.<ClientVO>):String {
        var s:String = "";
        var client:ClientVO;
        for each (client in vector) {
            s += client.toString() + CLIENT_DELIMITER;
        }
        s = s.slice(0, s.length-1);
        return s;
    }

    public static function load():void {
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath(Config.DATABASE);
        var fileStream:FileStream = new FileStream();
        fileStream.addEventListener(Event.COMPLETE, fileStream_completeHandler, false, 0, true);
        fileStream.openAsync(file, FileMode.UPDATE);

        function fileStream_completeHandler(event:Event):void {
            var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, File.systemCharset);
            trace(str);
            base = parse(str);
            fileStream.close();
            new InfoWindow("База загружена : " + base.length + " записей");
        }
    }

    private static function parse(fileStream:String):Vector.<ClientVO> {
        var array:Array = fileStream.split(CLIENT_DELIMITER);
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
