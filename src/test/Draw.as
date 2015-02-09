/**
 * Created by Пользователь on 17.02.14.
 */
package test {
import flash.display.Sprite;

public class Draw extends Sprite {
    public function Draw() {
        function drawCrossBox($sprite:Sprite, $width:int = 100, $height:int = 100, $x:int = 0, $y:int = 0, $bgColor:uint = 0xFFFFFF, $bgAlpha:Number = 1, $lineThickness:Number = 1, $lineColor:uint = 0x000000, $lineAlpha:Number = 1):void {
            $sprite.graphics.beginFill($bgColor, $bgAlpha);
            $sprite.graphics.drawRect($x, $y, $width, $height);
            $sprite.graphics.endFill();

            $sprite.graphics.lineStyle($lineThickness, $lineColor, $lineAlpha);
            $sprite.graphics.moveTo($x, $y);
            $sprite.graphics.lineTo($x + $width, $y);
            $sprite.graphics.lineTo($x + $width, $y + $height);
            $sprite.graphics.lineTo($x, $y + $height);
            $sprite.graphics.lineTo($x, $y);
            $sprite.graphics.lineTo($x + $width, $y + $height);
            $sprite.graphics.moveTo($x + $width, $y);
            $sprite.graphics.lineTo($x, $y + $height);
        }

        var _mySprite:Sprite = new Sprite();
        drawCrossBox(_mySprite, 240, 320, 0, 0, 0xCCCCCC, 1, 1, 0x000000, 1);
        addChild(_mySprite);
    }
}
}
