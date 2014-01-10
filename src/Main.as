package {
    import flash.display.Sprite;

    import windows.ClientWindow;

    [SWF(backgroundColor="0x95F0BB", height="768")]
    public class Main extends Sprite{
        public function Main() {
            addChild(new ClientWindow());
        }
    }
}
