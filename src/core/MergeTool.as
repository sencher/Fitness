/**
 * Created by SenCheR on 18.07.2015.
 */
package core {
import managers.VisitManager;
import managers.WindowManager;

import utils.Utils;

import vo.AbonementVO;
import vo.ClientVO;
import vo.VisitDayVO;

public class MergeTool {
    public static function mergeClients(add:Vector.<ClientVO>):void {
        var db:DataBase = DataBase.instance;
        var mainClient:ClientVO;
        var addClient:ClientVO;
        var field:String;
        var mainValue:*;
        var addValue:*;

        for each (addClient in add) {
            mainClient = db.getClientById(addClient.cardId);
            if (!mainClient) {
                db.addClient(addClient);
            } else {
                for each (field in addClient.fields) {
                    mainValue = mainClient[field];
                    addValue = addClient[field];
                    if (addValue is Date) {
                        if ((mainValue as Date).getTime() != (addValue as Date).getTime()) {
                            askFromUser(mainClient, field, mainValue, addValue, okClientCallback);
                        }
                    } else if (mainValue != addValue) {
                        askFromUser(mainClient, field, mainValue, addValue, okClientCallback);
                    }
                }
            }
        }
    }

    private static function okClientCallback(p:Object):void {
        p.client[p.field] = p.value;
    }


    private static function okAbonementCallback(p:Object):void {
        p.client.abonement[p.field] = p.value;
    }

    public static function mergeVisits(add:Vector.<VisitDayVO>):void {
        var vm:VisitManager = VisitManager.instance;
        var mainDay:VisitDayVO;
        var addDay:VisitDayVO;
        var addValue:*;
        var mainIndex:int;
        var addIndex:int;

        for each (addDay in add) {
            mainDay = vm.getDay(addDay.date);
            if (!mainDay) {
                vm.addVisitDay(addDay);
            } else {
                for (addIndex = 0; addIndex < addDay.ids.length - 1; addIndex++) {
                    addValue = addDay.ids[addIndex];
                    mainIndex = mainDay.ids.indexOf(addValue);
                    if (mainIndex < 0) {
                        mainDay.ids.push(addValue);
                        mainDay.times.push(addDay.times[addIndex]);
                    }
                }
            }
        }
    }

    private static const DATE_DIFF_EQUAL:int = 300000;

    public static function mergeAbonements(client:ClientVO, add:AbonementVO):void {
        var field:String;
        var main:AbonementVO = client.abonement;
        var dateDiff:Number;

        if (!main) {
            main = add;
        } else {
            for each(field in add.fields) {
                if (!add[field]) {
                    continue;
                } else if (!main[field]) {
                    main[field] = add[field];
                } else if (main[field] is Date) {
//                    trace("DATE ", main[field],"\n",add[field]);
                    dateDiff = (add[field] as Date).getTime() - (main[field] as Date).getTime();
                    if (Math.abs(dateDiff) < DATE_DIFF_EQUAL) {
                        continue;
                    }
                    // just created while new ClientVO
                    if (new Date().getTime() - (main[field] as Date).getTime() < DATE_DIFF_EQUAL) {
                        main[field] = add[field];
                    } else {
                        if (field == 'reg_day') {
                            if (dateDiff < DATE_DIFF_EQUAL) {
                                main[field] = add[field];
                            }
                        } else if (field == 'last_visit') {
                            if (dateDiff > DATE_DIFF_EQUAL) {
                                main[field] = add[field];
                            }
                        } else {
                            askFromUser(client, field, main[field], add[field], okAbonementCallback);
                        }
                    }
                } else if (main[field] != add[field]) {
                    askFromUser(client, field, main[field], add[field], okAbonementCallback);
                }
            }
        }
    }

    private static function askFromUser(client:ClientVO, field:String, mainValue:*, addValue:*, callback:Function):void {
        WindowManager.instance.showQuestionPopup({
            message: Utils.swapTextValues(Texts.MERGE_MESSAGE, [client.cardId, client.secondName, field, mainValue, addValue]),
            client: client,
            field: field,
            value: addValue
        }, callback);
    }
}
}
