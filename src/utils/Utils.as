/**
 * Created by Пользователь on 17.02.14.
 */
package utils {
    import flash.display.MovieClip;
    import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

    import windows.InfoPopup;

    public class Utils {
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
        trace(d);
        return d;
    }

    public static function collectDate(mc:MovieClip):Date {
        var d:uint = uint(mc.day.text);
        var m:uint = uint(mc.month.text);
        var y:uint = uint(mc.year.text);

        if(y < 20)
            y += 2000;
        else if(y > 21 && y < 100)
            y += 1900;

        if ( d > 0 && d < 32 && m > 0 && m < 13 && y > 1900 && y < 2500 ){
            return new Date(y, m-1, d);
        }else{
            new InfoPopup("Формат даты : 31 12 85");
            return null;
        }
    }

    public static function copyFields(receiver:*, source:*):void{
        for each (var field:String in receiver.fields){
            receiver[field] = source[field];
        }
    }

    public static function collectTextFields(receiver:*, source:*):void{
        var receiverField:*;
        for each (var field:String in receiver.fields){
            try{
                receiverField = receiver[field];
            }catch (e:Error){
//                receiverField = null;
                continue;
            }
//            trace(field, source[field]);
            if(source[field] is TextField)
                receiver[field] = source[field].text;
            else if(source[field] is MovieClip)
                receiver[field] = collectDate(source[field]);
        }
    }

    public static function updateTextFields(receiver:*, source:*):void{
        var sourceField:*;
        for each (var field:String in receiver.fields){
            try{
                sourceField = source[field];
            }catch (e:Error){
                sourceField = null;
            }
            if(receiver[field] is TextField)
                receiver[field].text = sourceField || "";
            else if(receiver[field] is MovieClip){
                if(sourceField)
                    divideDate(receiver[field], sourceField);
                else
                    clearDate(receiver[field]);
            }

        }
    }

    private static function divideDate(dateComponent:MovieClip, date:Date):void {
        if(!dateComponent || !date) return
        dateComponent.day.text = date.date || "";
        dateComponent.month.text = date.month+1 || "";
        dateComponent.year.text = date.getFullYear() || "";
    }

    private static function clearDate(dateComponent:MovieClip):void {
        if(!dateComponent) return
        dateComponent.day.text = "";
        dateComponent.month.text = "";
        dateComponent.year.text = "";
    }

}
}
