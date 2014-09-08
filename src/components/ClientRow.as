package components {
    import flash.display.MovieClip;
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

        public function ClientRow(mc:MovieClip) {
            view = mc;

            Utils.copyFields(this, mc);
        }

        public function update(client:ClientVO):void {
            if(!client || !client.cardId){
                clear();
            }
            var currentDate:Date = new Date();

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
