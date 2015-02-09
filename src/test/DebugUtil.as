package test {

public class DebugUtil {


    public static function getCallingInfo(pInfo:String = "", pFull:Boolean = false):String {

        return getInfo(pInfo, pFull, 2);

    }


    public static function traceCallingInfo(pInfo:String = "", pFull:Boolean = false):void {

        trace(getCallingInfo(pInfo, pFull));

    }


    public static function getCallerInfo(pInfo:String = "", pFull:Boolean = false):String {

        return getInfo(pInfo, pFull, 3)

    }


    public static function traceCallerInfo(pInfo:String = "", pFull:Boolean = false):void {

        trace(getCallerInfo(pInfo, pFull));

    }


    private static function getInfo(pInfo:String = "", pFull:Boolean = false, pIndex:Number = 0):String {

        CONFIG::EXTENDED_INFO_ON {

            try {

                throw new Error();

            } catch (e:Error) {

                var lTrace:String = e.getStackTrace().split("\tat ")[pIndex + 1];

                lTrace = pFull ? lTrace : lTrace.split("[")[0];

                return (lTrace + "->" + pInfo);

            }

        }

        return pInfo;

    }

}


}