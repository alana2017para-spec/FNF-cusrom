package render;

import flixel.FlxG;
import flixel.FlxState;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import sys.io.File;
import sys.FileSystem;
import openfl.utils.ByteArray;

class VideoRenderState extends FlxState
{
    public static var enabled:Bool = false;
    public static var fps:Int = 60;
    public static var frameCount:Int = 0;

    override public function create()
    {
        super.create();

        if (enabled)
        {
            FlxG.updateFramerate = fps;
            FlxG.drawFramerate = fps;

            if (!FileSystem.exists("gameRenders"))
                FileSystem.createDirectory("gameRenders");
        }
    }

    override public function draw()
    {
        super.draw();

        if (enabled)
        {
            saveFrame();
        }
    }

    static function saveFrame()
    {
        var bmp:BitmapData = new BitmapData(
            FlxG.width,
            FlxG.height,
            false,
            0xFF000000
        );

        bmp.draw(FlxG.stage);

        var bytes:ByteArray = bmp.encode(
            bmp.rect,
            new PNGEncoderOptions()
        );

        var name:String = StringTools.lpad(
            Std.string(frameCount),
            "0",
            6
        );

        File.saveBytes("gameRenders/frame_" + name + ".png", bytes);
        frameCount++;
        bmp.dispose();
    }
}
