import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import haxe.ds.Vector;
import hxnoise.DiamondSquare;
import hxnoise.Perlin;
import nodes.*;

class MapGenerator
{
    static private var engine:Engine;
    static public var frequency = 0.25;
    static public var persistence = 0.5;
    static public var octaves = 1;

    static public function init(_engine:Engine)
    {
        engine = _engine;
    }

    static public function generate()
    {
        engine.removeAllEntities();

        var size = 32;
        var background = Factory.createBackground(new Vector2(size * 64, size * 64));
        var halfSize = new Vector2(size * 64 * 0.5, size * 64 * 0.5);
        engine.addEntity(background);

        var data = new Vector<Int>(size);
        var perlin = new Perlin();

        var min = 1000.0;
        var max = -1000.0;

        for(x in 0...size)
        {
            for(y in 0...size)
            {
                var c = perlin.OctavePerlin(x, y, 0.1, octaves, persistence, frequency);

                if(c < min) min = c;
                if(c > max) max = c;

                if(c < 0.5)
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
