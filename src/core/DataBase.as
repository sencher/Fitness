package core {
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import managers.VisitManager;
import managers.WindowManager;

import utils.Utils;

import vo.AbonementVO;
import vo.ClientVO;
import vo.Time;
import vo.VisitDayVO;

public class DataBase {
    public var base:Vector.<ClientVO> = new Vector.<ClientVO>();
    private var wm:WindowManager = WindowManager.instance;
    private static var _instance:DataBase;

    public function DataBase() {
        if (_instance) {
            throw new Error("core.DataBase... use instance()");
        }
        _instance = this;
    }

    public static function get instance():DataBase {
        if (!_instance) {
            new DataBase();
        }
        return _instance;
    }

    public function addClient(client:ClientVO):Boolean {
        if (!findDuplicates(client)) {
            base.push(client);
            base.sort(compare);
            save();
            return true;
        } else {
            return false;
        }
    }

    public function updateClient(client:ClientVO):void {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.cardId == client.cardId) {
                oldClient = client;
                break;
            }
        }
        save();
    }

    private function compare(c1:ClientVO, c2:ClientVO):int {
        return c1.cardId - c2.cardId;
    }

    private function findDuplicates(newClient:ClientVO):ClientVO {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.firstName == newClient.firstName &&
                    oldClient.secondName == newClient.secondName ||
                    oldClient.cardId == newClient.cardId) {
                wm.ShowPopup("Ошибка! Клиент уже есть в базе либо номер карты занят!" +
                        "\n№ : " + oldClient.cardId + "\nФамилия : " + oldClient.secondName + "\nИмя : " + oldClient.firstName);
                return oldClient;
            }
        }
        return null;
    }

    public function getClientById(id:int):ClientVO {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.cardId == id) {
                return oldClient;
            }
        }
        return null;
    }

    public function getClientBySecName(secName:String):ClientVO {
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.secondName.toLowerCase().indexOf(secName.toLowerCase()) == 0) {
                return oldClient;
            }
        }
        return null;
    }

    public function save(mode:String = 'all'):void {
        try{
            fileStream.position;
            wm.ShowPopup("Ошибка сохранения! Файл занят системой.", true);
            return;
        }catch (e:Error){
        }

        if (!base.length) {
            wm.ShowPopup("Нечего сохранять");
            return;
        }

        if (mode == 'all' || mode == Config.CLIENTS) {
            initFile(Config.CLIENTS);
            fileStream.open(file, FileMode.WRITE);
            fileStream.writeUTFBytes(generateClientsSave(base));
            fileStream.close();
            wm.ShowPopup("База сохранена : " + base.length + " клиентов");
        }

        //save abonement
        if (mode == 'all' || mode == Config.ABONEMENTS) {
            initFile(Config.ABONEMENTS);
            fileStream = new FileStream();
            fileStream.open(file, FileMode.WRITE);
            fileStream.writeUTFBytes(generateAbonementsSave(base));
            fileStream.close();
        }

        //save visits
        if (mode == 'all' || mode == Config.VISITS) {
            initFile(Config.VISITS);
            fileStream = new FileStream();
            fileStream.open(file, FileMode.WRITE);
            fileStream.writeUTFBytes(VisitManager.instance.generateSave());
            fileStream.close();
        }
    }

    private function generateClientsSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.VERSION + Config.LINE_DELIMITER;
        var client:ClientVO;
        for each (client in vector) {
            s += client + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    private function generateAbonementsSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.VERSION + Config.LINE_DELIMITER;
        var client:ClientVO;
        for each (client in vector) {
            s += client.abonementString() + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    private var file:File;
    private var fileStream:FileStream;
    private var currentQueueId:int = -1;
    private var loadQueue:Array = [
        [Config.CLIENTS, parse],
        [Config.ABONEMENTS, parseAbonement],
        [Config.VISITS, parseVisits]
    ];

    public function load():void {
        fileStream = new FileStream();
        fileStream.addEventListener(ProgressEvent.PROGRESS, stream_progressHandler);
        fileStream.addEventListener(Event.CLOSE, stream_closeHandler);
        fileStream.addEventListener(Event.COMPLETE, stream_completeHandler);
        loadNextFile();
    }

    private function loadNextFile():void {
        currentQueueId++;
        initFile(loadQueue[currentQueueId][0]);
        fileStream.openAsync(file, FileMode.UPDATE);
    }

    private function stream_completeHandler(event:Event):void {
        trace("COMPLETE");
        fileStream.close();
        if (currentQueueId < loadQueue.length - 1) loadNextFile();
    }

    private function stream_closeHandler(event:Event):void {
        trace("CLOSE");
    }

    private function stream_progressHandler(event:ProgressEvent):void {
        trace("PROGRESS client " + event.bytesLoaded + " / " + event.bytesTotal);
        if (event.bytesLoaded < event.bytesTotal) return;
        var str:String = fileStream.readMultiByte(fileStream.bytesAvailable, Config.ENCODING);
        loadQueue[currentQueueId][1](str);
    }

    private function initFile(path:String):void {
        file = File.applicationStorageDirectory;
        file = file.resolvePath(path);
    }

    private function parseVisits(str:String):void {
        var array:Array = str.split(Config.LINE_DELIMITER);
        array.shift();// ignore version tag
        var visitDays:Vector.<VisitDayVO> = new <VisitDayVO>[];
        var s:String;
        for each(s in array) {
            if (s.length) {
                var array2:Array = s.split(Config.FIELD_DELIMITER);
                var visitDay:VisitDayVO = new VisitDayVO(Utils.unPackDate(array2.shift()));
                for (var i:int = 0; i < array2.length; i += 2) {
                    var t:Time = new Time();
                    t.parse(array2[i + 1]);
                    visitDay.newVisit(int(array2[i]), t);
                }
                visitDays.push(visitDay);
            }
        }

        //debug
//        var d:Date = new Date(2014,10,4);
//        var vd:VisitDayVO = new VisitDayVO(d);
//        for (var i=10;i<80;i++){
//            vd.newVisit(100+ i, "10:"+i);
//        }
//        visitDays.push(vd);

        VisitManager.instance.base = visitDays;
        wm.ShowPopup("Дневных отчетов : " + visitDays.length, true);
    }

    private function parse(fileStream:String):void {
        var array:Array = fileStream.split(Config.LINE_DELIMITER);

        //compatible
//        var array2:Array = fileStream.split(Config.CLIENT_OLD);
//        if(array2.length>array.length)array=array2;

        Config.saveVersion = array.shift();// ignore version tag
        var vector:Vector.<ClientVO> = new <ClientVO>[];
        var s:String;
        for each(s in array) {
            if (s.length) {
                var client:ClientVO = new ClientVO(s);
                vector.push(client);
            }
        }

        base = vector;
        wm.ShowPopup("База загружена : " + base.length + " клиентов");
    }

    private function parseAbonement(str:String):void {
        var arrayAb:Array = str.split(Config.LINE_DELIMITER);

        //compatible
//        var array2:Array = str.split(Config.CLIENT_OLD);
//        if(array2.length>arrayAb.length)arrayAb=array2;

        arrayAb.shift();// ignore version tag
        var s:String;
        for each(s in arrayAb) {
            if (s.length) {
                var array:Array = s.split(Config.FIELD_DELIMITER);

                //compatible
//                array2 = s.split(Config.FIELD_OLD);
//                if(array2.length>array.length)array=array2;

                var client:ClientVO = getClientById(array.shift());
                var ab:AbonementVO = new AbonementVO();
                Utils.deSerialize(ab, array);
                client.abonement = ab;

                //compatible
//                if(ab.last_visit)
//                    VisitManager.instance.addVisit(client.cardId,ab.last_visit);
            }
        }
        wm.ShowPopup("Абонементов : " + arrayAb.length, true);
    }
}
}