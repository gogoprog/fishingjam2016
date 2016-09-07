import gengine.math.*;
import gengine.Engine;
import components.*;

class Session
{
    static public var level:Level;
    static private var engine:Engine;

    static public function init(_engine:Engine)
    {
        engine = _engine;
    }

    static public function start()
    {
        MapGenerator.generate();

        for(i in 0...10)
        {
            var e = Factory.createShip();
            e.position = level.getRandomWaterPosition();
            e.setRotation2D(Std.random(360));
            engine.addEntity(e);

            e.get(Ship).sm.changeState("moving");
        }
    }
}
