import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import haxe.ds.Vector;

class MapGenerator
{
    static private var engine:Engine;

    static public function init(_engine:Engine)
    {
        engine = _engine;
    }

    static public function generate()
    {
        var size = 128;
        var background = Factory.createBackground(new Vector2(2048, 2048));
        engine.addEntity(background);

        var data = new Vector<Int>(size);
        var lakesCount = 3;

        while(lakesCount > 0)
        {
            var x = Std.random(size);
            var y = Std.random(size);

            lakesCount--;
        }
    }
}
