package windows {
import core.DataBase;

import flash.desktop.NativeApplication;
import flash.events.MouseEvent;

import managers.VisitManager;

import utils.Utils;

public class StartWindow extends BaseWindow {

    public function StartWindow() {
        super(start_window);

        addChild(view);
        Utils.initButton(view.new_button, onNew);
        Utils.initButton(view.search, onSearch);
        Utils.initButton(view.list_button, onList);
        Utils.initButton(view.report_button, onReport);
        Utils.initButton(view.exit_button, onExit);
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
