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
    static public var threshold = 0.5;

    static public function init(_engine:Engine)
    {
        engine = _engine;
    }

    static public function generate()
    {
        engine.removeAllEntities();

        var size = Config.mapSize;
        var background = Factory.createBackground(new Vector2(size * Config.tileSize, size * Config.tileSize));
        var halfSize = new Vector2(size * Config.tileSize * 0.5, size * Config.tileSize * 0.5);
        engine.addEntity(background);

        var level = new Level();
        level.init(size);

        var perlin = new Perlin();

        var offset = new IntVector2(Std.random(100), Std.random(100));

        for(x in 0...size)
        {
            for(y in 0...size)
            {
                var c = perlin.OctavePerlin(x + offset.x, y + offset.y, 0.1, octaves, persistence, frequency);

                if(c < threshold)
                {
                    level.setTile(x, y, TileType.Water);
                }
            }
        }

        for(x in 0...size)
        {
            for(y in 0...size)
            {
                if(level.getTile(x, y) == TileType.Water)
                {
                    var e = Factory.createWaterTile(WaterPart.Full);
                    e.position = new Vector3(x * Config.tileSize - halfSize.x + Config.tileSize / 2, y * Config.tileSize - halfSize.y + Config.tileSize / 2, 0);
                    engine.addEntity(e);
                }
            }
        }
    }

    static private function randFunc():Float
    {
        return Math.random() - 0.5;
    }
}
