package components {
import Events.ClientEvent;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

import utils.Utils;

import vo.ClientVO;

public class ReportRow extends BaseRow {
    public var fields:Array = ['num', 'id', 'client_name', 'visit_time'];

    public var num:TextField;
    public var visit_time:TextField;

    public function ReportRow(mc:MovieClip) {
        super(mc);
    }
}
}
