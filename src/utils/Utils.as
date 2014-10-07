/**
 * Created by Пользователь on 17.02.14.
 */
package utils {
    import flash.display.MovieClip;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import windows.BaseWindow;

    import windows.InfoPopup;

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
            d.setTime(ms);
//            trace(d);
            return d;
        }

        public static function collectDate(mc:MovieClip):Date {
            var d:uint = uint(mc.day.text);
            var m:uint = uint(mc.month.text);
            var y:uint = uint(mc.year.text);

            if (y < 20)
                y += 2000;
            else if (y > 21 && y < 100)
                y += 1900;

            if (d > 0 && d < 32 && m > 0 && m < 13 && y > 1900 && y < 2500) {
                return new Date(y, m - 1, d);
            } else {
//                wm.ShowPopup("Формат даты : 31 12 85");
                return null;
            }
        }

        public static function copyFields(receiver:*, source:*):void {
            for each (var field:String in receiver.fields) {
                receiver[field] = source[field];
            }
        }

        public static function collectTextFields(receiver:*, source:*):void {
            var receiverField:*;
            for each (var field:String in receiver.fields) {
                try {
                    receiverField = receiver[field];
                } catch (e:Error) {
//                receiverField = null;
                    continue;
                }
                if (source[field] is TextField)
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

        private static function clearDate(dateComponent:MovieClip):void {
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
                if (o[param]) {
                    if (o[param] is Date) {
                        s += o[param].getTime();
                    } else {
                        s += o[param];
                    }
                }
                s += Config.FIELD_DELIMITER;
            }
            s = s.slice(0, s.length - 1);
            return s;
        }

        public static function deSerialize(o:*, params:*):void {
            var array:Array;
            if (params is Array) {
                array = params;
            } else {
                array = params.split(Config.FIELD_DELIMITER);
            }

            for each (param in o.fields) {
                var nextParam:* = array.shift();

                if (nextParam) {
                    if (nextParam > DATE_SPIKE || nextParam < -DATE_SPIKE) {
                        o[param] = Utils.loadDate(nextParam);
                        continue;
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

        public static function countDays(startDate:Date, endDate:Date):int {
            if(!startDate || !endDate) return -1;
            var oneDay:int = 24*60*60*1000; // hours*minutes*seconds*milliseconds
            var diffDays:int = Math.round((startDate.getTime() - endDate.getTime())/(oneDay));
            return diffDays;
        }

        public static function initButton(view:MovieClip, callback:Function):void{
            view.addEventListener(MouseEvent.CLICK, callback, false, 0, true);
            view.buttonMode = true;
        }
    }
}
