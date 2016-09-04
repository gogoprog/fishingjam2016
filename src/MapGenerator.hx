import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import haxe.ds.Vector;
import hxnoise.DiamondSquare;

class MapGenerator
{
    static private var engine:Engine;

    static public function init(_engine:Engine)
    {
        engine = _engine;
    }

    static public function generate()
    {
        var size = 32;
        var background = Factory.createBackground(new Vector2(size * 64, size * 64));
        var halfSize = new Vector2(size * 64 * 0.5, size * 64 * 0.5);
        engine.addEntity(background);

        var data = new Vector<Int>(size);
        var featureSize = Std.int(size / 8);
        var scale = 1.0;
        var diamondSquare = new DiamondSquare(size, size, featureSize, scale, randFunc);
        diamondSquare.diamondSquare();

        var min = 1000.0;
        var max = -1000.0;

        for(x in 0...size)
        {
            for(y in 0...size)
            {
                var c = diamondSquare.getValue(x,y);

                if(c < min) min = c;
                if(c > max) max = c;

                if(c < 0.0)
                {
                    var e = Factory.createTileSprite();
                    e.position = new Vector3(x * 64 - halfSize.x + 32, y * 64 - halfSize.y + 32, 0);
                    engine.addEntity(e);
                }
            }
        }

        trace("min " + min);
        trace("max " + max);
    }

    static private function randFunc():Float
    {
        return Math.random() - 0.5;
    }
}
