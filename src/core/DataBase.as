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
        var i:int;
        for (i = 0; i< base.length; i++) {
            if (base[i].cardId == client.cardId) {
                base[i] = client;
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
        if(id == -100){
            return base[int(Math.random() * base.length)];
        }
        var oldClient:ClientVO;
        for each (oldClient in base) {
            if (oldClient.cardId == id) {
                return oldClient;
            }
        }
//        wm.ShowPopup("Кто-то пытался взять несуществующего клиента : " + id);
        return null;
    }

    public function getClientBySecName(secName:String):ClientVO {
        var oldClient:ClientVO;
        var curIndex:uint;
        var minIndex:uint = uint.MAX_VALUE;
        var minId:int;
        for each (oldClient in base) {
            curIndex = oldClient.secondName.toLowerCase().indexOf(secName.toLowerCase());
            if (curIndex < minIndex) {
                if(curIndex == 0) return oldClient;
                minIndex = curIndex;
                minId = oldClient.cardId;
            }
        }
        return getClientById(minId);
    }

    public function save(mode:String = 'all'):void {
        try{
            saveStream.position;
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
            saveStream = new FileStream();
            saveStream.open(file, FileMode.WRITE);
            saveStream.writeUTFBytes(generateClientsSave(base));
            saveStream.close();
            wm.ShowPopup("База сохранена : " + base.length + " клиентов", true);
        }

        //save abonement
        if (mode == 'all' || mode == Config.ABONEMENTS) {
            initFile(Config.ABONEMENTS);
            saveStream = new FileStream();
            saveStream.open(file, FileMode.WRITE);
            saveStream.writeUTFBytes(generateAbonementsSave(base));
            saveStream.close();
        }

        //save visits
        if (mode == 'all' || mode == Config.VISITS) {
            initFile(Config.VISITS);
            saveStream = new FileStream();
            saveStream.open(file, FileMode.WRITE);
            saveStream.writeUTFBytes(VisitManager.instance.generateSave());
            saveStream.close();
            //wm.ShowPopup("Сохранено " + VisitManager.instance.base.length + " дневных отчетов", true);
        }
    }

    private function generateClientsSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.getSaveHeader();
        var client:ClientVO;
        for each (client in vector) {
            s += client + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    private function generateAbonementsSave(vector:Vector.<ClientVO>):String {
        var s:String = Config.getSaveHeader();
        var client:ClientVO;
        for each (client in vector) {
            s += client.abonementString() + Config.LINE_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    private var file:File;
    private var loadStream:FileStream;
    private var saveStream:FileStream;
    private var currentQueueId:int = -1;
    private var loadQueue:Array = [
        [Config.CLIENTS, parseClients],
        [Config.VISITS, parseVisits],
        [Config.ABONEMENTS, parseAbonement]
    ];

    public function load():void {
        loadStream = new FileStream();
        loadStream.addEventListener(ProgressEvent.PROGRESS, stream_progressHandler);
//        fileStream.addEventListener(Event.CLOSE, stream_closeHandler);
        loadStream.addEventListener(Event.COMPLETE, stream_completeHandler);
        loadNextFile();
    }

    private function loadNextFile():void {
        currentQueueId++;
        initFile(loadQueue[currentQueueId][0]);
        loadStream.openAsync(file, FileMode.UPDATE);
    }

    private function stream_completeHandler(event:Event):void {
        loadStream.close();
        if (currentQueueId < loadQueue.length - 1) loadNextFile();
    }

//    private function stream_closeHandler(event:Event):void {
//        trace("CLOSE");
//    }

    private function stream_progressHandler(event:ProgressEvent):void {
//        trace("PROGRESS client " + event.bytesLoaded + " / " + event.bytesTotal);
        if (event.bytesLoaded < event.bytesTotal) return;
        var str:String = loadStream.readMultiByte(loadStream.bytesAvailable, Config.ENCODING);
        loadQueue[currentQueueId][1](str);
    }

    private function initFile(path:String):void {
        file = File.applicationStorageDirectory;
        file = file.resolvePath(path);
    }

    private function parseClients(fileStream:String):void {
        var array:Array = fileStream.split(Config.LINE_DELIMITER);
        array.shift();// ignore save header

        var vector:Vector.<ClientVO> = new <ClientVO>[];
        var s:String;
        for each(s in array) {
            if (s.length) {
                var client:ClientVO = new ClientVO(s);
                if(client.cardId < 1){
                    wm.ShowPopup("Неправильный формат клиента! : " + s);
                    continue;
                }
                vector.push(client);
            }
        }

        base = vector;
        wm.ShowPopup("База загружена : " + base.length + " клиентов");
    }

    private function parseVisits(str:String):void {
        var array:Array = str.split(Config.LINE_DELIMITER);
        array.shift();// ignore save header

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

        VisitManager.instance.base = visitDays;
        wm.ShowPopup("Дневных отчетов : " + visitDays.length, true);
    }

    private function parseAbonement(str:String):void {
        var arrayAb:Array = str.split(Config.LINE_DELIMITER);
        arrayAb.shift();// ignore save header

        var s:String;
        var id:int;
        for each(s in arrayAb) {
            if (s.length) {
                var array:Array = s.split(Config.FIELD_DELIMITER);
                id = array.shift();
                var client:ClientVO = getClientById(id);
                if(!client){
                    wm.ShowPopup("Ошибка! Есть абонемент, но нет клиетна № " + id);
                    continue;
                }
                var ab:AbonementVO = new AbonementVO();
                Utils.deSerialize(ab, array);
                client.abonement = ab;

                //compatible
                if(ab.last_visit)
                    VisitManager.instance.addVisit(client.cardId, ab.last_visit, false);
            }
        }
        wm.ShowPopup("Абонементов : " + arrayAb.length, true);
    }

    public function changeClientId(oldId:uint, newId:uint):void {
        var client:ClientVO = getClientById(oldId);
        client.cardId = newId;
        VisitManager.instance.changeClientId(oldId, newId);
    }

        public static function deleteClient(id:uint):void {

        }
    }
}
