/**
 * Created by Пользователь on 17.02.14.
 */
package utils {
import core.Config;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import managers.WindowManager;

public class Utils {
    private static var wm:WindowManager = WindowManager.instance;

    public static function createButton(color:uint, h:uint, w:uint, text:String = "Button"):Sprite {
        var mc:MovieClip = new MovieClip();
        with (mc) {
            graphics.beginFill(color, 0.7);
            graphics.drawRect(0, 0, w, h);
            graphics.endFill();

            var label:TextField = new TextField();
            label.text = text;
            label.selectable = false;
            addChild(label);

            buttonMode = true;
            mouseChildren = false;
        }
        return mc;
    }

    public static function loadDate(ms:Number):Date {
        var d:Date = new Date();

        //compatible
//        d.setTime(ms + 4*60*60*1000);
        d.setTime(ms);

        return d;
    }

    public static function collectDate(mc:MovieClip):Date {
        var d:uint = uint(mc.day.text);
        var m:uint = uint(mc.month.text);
        var y:uint = uint(mc.year.text);

        if (y < 1){
            var date:Date = new Date();
            y = date.fullYear;
        }
        if (y < 20)
            y += 2000;
        else if (y > 21 && y < 100)
            y += 1900;

        if (d > 0 && d < 32 && m > 0 && m < 13 && y > 1900 && y < 2500) {
            return new Date(y, m - 1, d, 4);
        } else {
//                wm.ShowPopup("Формат даты : 31 12 85");
            return null;
        }
    }

    /**
     * Reflexive setting of DisplayObjects from FLA to Class. "fields" array is used
     * @param receiver
     * @param source
     */
    public static function copyFields(receiver:*, source:*):void {
        for each (var field:String in receiver.fields) {
            receiver[field] = source[field];
        }
    }

    public static function collectTextFields(receiver:*, source:*):void {
        var receiverField:*;
        var sourceField:*;
        for each (var field:String in receiver.fields) {
            try {
                receiverField = receiver[field];
                sourceField = source[field];
            } catch (e:Error) {
                continue;
            }

            if (!source[field])
                continue;
            else if (source[field] is TextField)
                receiver[field] = source[field].text;
            else if (source[field] is MovieClip)
                receiver[field] = collectDate(source[field]);
        }
    }

    public static function updateTextFields(receiver:*, source:*):void {
        var sourceField:*;
        for each (var field:String in receiver.fields) {
            try {
                sourceField = source[field];
                if (sourceField == null) continue;
            } catch (e:Error) {
                continue;
            }
            if (receiver[field] is TextField)
                receiver[field].text = sourceField;
            else if (receiver[field] is MovieClip) {
                divideDate(receiver[field], sourceField);
            }
        }
    }

    public static function divideDate(dateComponent:MovieClip, date:Date):void {
        if (!dateComponent || !date) return
        dateComponent.day.text = date.date || "";
        dateComponent.month.text = date.month + 1 || "";
        dateComponent.year.text = date.getFullYear() || "";
    }

    public static function clearDate(dateComponent:MovieClip):void {
        if (!dateComponent) return
        dateComponent.day.text = "";
        dateComponent.month.text = "";
        dateComponent.year.text = "";
    }

    private static var param:String;
    private static const DATE_SPIKE:int = 50000;


    public static function serialize(o:*):String {
        var s:String = "";

        for each (param in o.fields) {
            if (o[param] && param.indexOf("dummy") < 0) {
                if (o[param] is Date) {
                    s += packDate(o[param]);
                } else {
                    s += o[param];
                }
            }
            s += Config.FIELD_DELIMITER;
        }
        s = s.slice(0, s.length - 1);
        return s;
    }

    public static function packDate(date:Date):String {
        return Config.DATE_SPECIAL + date.getTime();
    }

    public static function unPackDate(s:String):Date {
        if (s.length > 0 && s.substr(0, 1) == Config.DATE_SPECIAL) {
            return Utils.loadDate(Number(s.substr(1)));
        }
        return null;
    }

    public static function deSerialize(o:*, params:*):void {
        var array:Array;
        var tryMakeDate:Date;

        if (params is Array) {
            array = params;
        } else {
            array = params.split(Config.FIELD_DELIMITER);

            //compatible
//            var array2:Array = params.split(Config.FIELD_OLD);
//            if (array2.length > array.length)array = array2;
        }

        for each (param in o.fields) {
            var nextParam:String = array.shift();

            if (nextParam) {
                //compatible
                /*if (Config.saveVersion == "0.2" && (nextParam > DATE_SPIKE || nextParam < -DATE_SPIKE)) {
                    o[param] = Utils.loadDate(Number(nextParam));
                    continue;
                }

                else */
                if (nextParam.indexOf("GMT")>-1) {
                    nextParam = "Ошибка, внесите заново из анкеты";
                }else{
                    tryMakeDate = unPackDate(nextParam);
                    if (tryMakeDate) {
                        o[param] = tryMakeDate;
                        continue;
                    }
                    o[param] = nextParam;
                }
                o[param] = nextParam;
            }
        }
    }

    public static function clearTextFields(window:*):void {
        var receiverField:*;
        for each (var field:String in window.fields) {
            try {
                receiverField = window[field];
            } catch (e:Error) {
                receiverField = null;
            }
            if (receiverField is TextField)
                receiverField.text = "";
            else if (receiverField is MovieClip) {
                clearDate(receiverField);
            }
        }
    }

    public static function countDays(startDate:Date, endDate:Date = null):int {
        if (!startDate) return -1;
        if (!endDate) endDate = new Date();
        var oneDay:int = 86400000;
        var diffDays:int = Math.round((startDate.getTime() - endDate.getTime()) / (oneDay));
        return diffDays;
    }

    public static function initButton(view:MovieClip, callback:Function):void {
        view.addEventListener(MouseEvent.CLICK, callback, false, 0, true);
        view.buttonMode = true;
    }

    public static function toInt(array:Array):Array {
        var i:int;
        for (i = 0; i < array.length; i++) {
            array[i] = int(array[i]);
        }
        return array;
    }

    public static function packTime(time:String):String {
        if (time.length == 5)
            return time.substr(0, 2) + time.substr(3, 2);
        else if (time.length == 4)
            return time.substr(0, 1) + time.substr(2, 2);
        else
            return time.substr(0, 1) + time.substr(2, 1);
    }

    public static function unPackTime(time:String):String {
        if (time.length == 4)
            return time.substr(0, 2) + ":" + time.substr(2, 2);
        else if (time.length == 3)
            return time.substr(0, 1) + ":" + time.substr(1, 2);
        else
            return time.substr(0, 1) + ":" + time.substr(1, 1);
    }

    public static function areDatesEqual(d1:Date, d2:Date):Boolean {
        return d1.month == d2.month && d1.date == d2.date && d1.fullYear == d2.fullYear;
    }

    public static function isDateBetween(s:Date, d1:Date, d2:Date):Boolean {
        return s >= d1 && s <= d2;
    }

    public static function dateToString(current:Date):String {
        return current.date + " / " + (current.month + 1) + " / " + current.fullYear;
    }

    public static function mergeObjects(main:Object, additional:Object):Object {
        if(!main) return additional;
        var param:*;
        for (param in additional){
            try{
                main[param] = additional[param];
            }catch (e:Error){}
        }
        return main;
    }

    public static function swapTextValues(message:String, params:Array):String {
        var value:String;
        var pattern:RegExp;
        var i:int;
        for (i = 0; i < params.length; i++) {
            value = params[i];
            pattern = /\{\d{1}\}/;
            message = message.replace(pattern, value);
        }

        return message;
    }
}
}
