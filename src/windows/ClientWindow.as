package windows {
    import flash.display.Sprite;

    public class ClientWindow extends Sprite{

        public function ClientWindow() {
            addChild(new client_view());
        }
    }
}
