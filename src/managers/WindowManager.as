package managers {
import core.DataBase;

import flash.desktop.NativeApplication;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

import utils.Hash;
import utils.Utils;

import windows.BaseWindow;
import windows.InfoPopup;
import windows.StartWindow;

public class WindowManager extends Sprite {
    private static var _instance:WindowManager;

//        private var currentWindowClass:Class;
//        private var previousWindowClass:Class;
    private var previousWindows:Array = [];

    public var currentWindow:BaseWindow;
    private var popup:InfoPopup;

    private var _windows:Hash = new Hash();
    public var popupShowed:Boolean;
    private var popupQueue:Vector.<String> = new Vector.<String>();
//        private var _params:*;
    private var windowLayer:Sprite = new Sprite();
    private var popupLayer:Sprite = new Sprite();

    public function WindowManager() {
        if (_instance) {
            throw new Error("managers.WindowManager... use instance()");
        }
        _instance = this;
        addChild(windowLayer);
        addChild(popupLayer);
    }

    public static function get instance():WindowManager {
        if (!_instance) {
            new WindowManager();
        }
        return _instance;
    }

    private function getWindowShowParams(indexFromEnd:int = 0):Array {
        return previousWindows[previousWindows.length - 1 - indexFromEnd];
    }

    public function ShowWindow(window:Class, params:* = null, backWay:Boolean = false):void {
        if (!backWay) {
            var curWindowShowParams:Array = getWindowShowParams();
            if (curWindowShowParams && curWindowShowParams[0] == window && curWindowShowParams[1] == params) return;
            previousWindows.push([window, params]);
        }
        if (currentWindow) {
            if(!backWay && previousWindows.length > 1) previousWindows[previousWindows.length - 2][1] = Utils.mergeObjects(previousWindows[previousWindows.length - 2][1], currentWindow.saveAdditionalParamsOnExit());
            currentWindow.close();
        }
        currentWindow = BaseWindow(_windows.getKey(window));
        if (!currentWindow) {
            currentWindow = new window();
            _windows.setKey(window, currentWindow);
        }

//            previousWindowClass = currentWindowClass;
//            currentWindowClass = window;
        windowLayer.addChild(currentWindow);
        currentWindow.init(params);
    }

    public function ShowPrevious():void {
        var prevWindowShowParams:Array = getWindowShowParams(1);
        if (!prevWindowShowParams || prevWindowShowParams[0] == null) {
            previousWindows = [];
            ShowWindow(StartWindow);
            return;
        }
        previousWindows.pop();
        ShowWindow(prevWindowShowParams[0], prevWindowShowParams[1], true);
    }

    public function ShowPopup(message:String, append:Boolean = false):void {
        if (popupShowed) {
            if (append)
                popup.append(message);
            else
                popupQueue.push(message);
            return;
        }

        popup = InfoPopup(_windows.getKey(InfoPopup));
        if (!popup) {
            popup = new InfoPopup();
            _windows.setKey(InfoPopup, popup);
        }
        popup.addEventListener(Event.CLOSE, ClosePopup, false, 0, true);
        popup.init(message);
        popupLayer.addChild(popup);
        popupShowed = true;
    }

    public function ClosePopup(event:Event = null):void {
        popupShowed = false;
        popupLayer.removeChild(popup);
        if (popupQueue.length) {
            ShowPopup(popupQueue.shift());
        }
    }

    private function moveToTop(clip:DisplayObject):void {
        if (!clip || !clip.parent) return;
        clip.parent.setChildIndex(clip, clip.parent.numChildren - 1);
    }


    public function saveAndExit():void {
        DataBase.instance.save();
        NativeApplication.nativeApplication.exit();
    }
}
}
