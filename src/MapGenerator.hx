import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;

class MapGenerator
{
    static private var engine:Engine;

    static public function init(_engine:Engine)
    {
        engine = _engine;
    }

    static public function generate()
    {
        var background = Factory.createBackground(new Vector2(2048, 2048));

        engine.addEntity(background);
    }
}
