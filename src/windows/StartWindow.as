package windows {
<<<<<<< HEAD
import core.DataBase;

import flash.desktop.NativeApplication;
import flash.events.MouseEvent;
=======
    import flash.desktop.NativeApplication;
    import flash.events.MouseEvent;

    import utils.Utils;

    public class StartWindow extends BaseWindow {
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8

import managers.VisitManager;

<<<<<<< HEAD
import utils.Utils;

public class StartWindow extends BaseWindow {
=======
            addChild(view);
            Utils.initButton(view.new_button, onNew);
            Utils.initButton(view.list_button, onList);
            Utils.initButton(view.exit_button, onExit);
        }
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8

    public function StartWindow() {
        super(start_window);

<<<<<<< HEAD
        addChild(view);
        Utils.initButton(view.new_button, onNew);
        Utils.initButton(view.search, onSearch);
        Utils.initButton(view.list_button, onList);
        Utils.initButton(view.report_button, onReport);
        Utils.initButton(view.exit_button, onExit);
=======
        private function onList(event:MouseEvent):void {
            wm.ShowWindow(ListWindow);
        }

        private function onExit(event:MouseEvent):void {
            NativeApplication.nativeApplication.exit();
        }
>>>>>>> a895a889f8264d94d4a99ed7d7c750b120e0bdb8
    }

    private function onNew(event:MouseEvent):void {
        wm.ShowWindow(ClientWindow);
    }

    private function onSearch(event:MouseEvent):void {
        wm.ShowWindow(SearchWindow);
    }

    private function onList(event:MouseEvent):void {
        wm.ShowWindow(ClientListWindow);
    }

    private function onReport(event:MouseEvent):void {
        wm.ShowWindow(ReportWindow, VisitManager.instance.getDay(new Date(), true));
    }

    private function onExit(event:MouseEvent):void {
        DataBase.instance.save();
        NativeApplication.nativeApplication.exit();
    }
}
}
