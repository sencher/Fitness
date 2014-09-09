package components {
    import Events.ClentEvent;

    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    import utils.Utils;

    public class ClientRow extends MovieClip{
        public var fields:Array = ['id','client_name','days','visits','valid','last_visit'];
        public var view:MovieClip;
        public var id:TextField;
        public var client_name:TextField;
        public var days:TextField;
        public var visits:TextField;
        public var valid:MovieClip;
        public var last_visit:MovieClip;

        public var client:ClientVO;

        public function ClientRow(mc:MovieClip) {
            view = mc;
            view.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
            Utils.copyFields(this, mc);
        }

        private function onClick(event:MouseEvent):void {
            dispatchEvent(new ClentEvent(ClentEvent.SELECTED, client));
        }

        public function update(client:ClientVO):void {
            if(!client || !client.cardId){
                clear();
            }
            var currentDate:Date = new Date();
            this.client = client;

            id.text = String(client.cardId);
            client_name.text = client.secondName + " " + client.firstName + " " + client.thirdName;
//            days.text = client.
//            visits.text
//            valid.text
//            last_visit.text
        }

        public function clear():void {
            id.text = client_name.text = days.text = visits.text = "Cleared";
            clearDateComponent(valid);
            clearDateComponent(last_visit);
        }

        private function clearDateComponent(dateComponent:MovieClip):void{
            dateComponent.day.text = dateComponent.month.text = dateComponent.year.text = "Cleared";
        }
    }
}
