package components {
    import flash.display.MovieClip;

    public class ClientRow extends MovieClip{
        private var view:MovieClip;
        public function ClientRow(mc:MovieClip) {
            view = mc;
        }

        public function update(clientVO:ClientVO):void {
            if(!clientVO || !clientVO.cardId){
                clear();
            }
            var currentDate:Date = new Date();
//            view.id =
        }

        private function clear():void {
            view.id.text = view.client_name.text = view.days.text = view.visits.text = "Cleared";
            clearDateComponent(view.valid);
            clearDateComponent(view.last_visit);
        }

        private function clearDateComponent(dateComponent:MovieClip):void{
            dateComponent.day.text = dateComponent.month.text = dateComponent.year.text = "Cleared";
        }
    }
}
