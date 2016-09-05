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
    static public var frequency = 0.06;
    static public var persistence = 0.5;
    static public var octaves = 1;
    static public var threshold = 0.4;

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

        var offset = new IntVector2(Std.random(10000), Std.random(10000));

        for(x in 0...Std.int(size/2))
        {
            for(y in 0...Std.int(size/2))
            {
                var c = perlin.OctavePerlin(x + offset.x, y + offset.y, 0.1, octaves, persistence, frequency);

                if(c < threshold)
                {
                    level.setTile(x*2, y*2, TileType.Water);
                    level.setTile(x*2+1, y*2, TileType.Water);
                    level.setTile(x*2+1, y*2+1, TileType.Water);
                    level.setTile(x*2, y*2+1, TileType.Water);
                }
            }
        }

        for(x in 0...size)
        {
            for(y in 0...size)
            {
                if(level.isWater(x, y))
                {
                    var part:WaterPart = WaterPart.Full;
                    var s, w, n, e, sw, se, ne, nw;

                    s = level.isWater(x, y-1);
                    w = level.isWater(x-1, y);
                    n = level.isWater(x, y+1);
                    e = level.isWater(x+1, y);
                    sw = level.isWater(x-1, y-1);
                    se = level.isWater(x+1, y-1);
                    ne = level.isWater(x+1, y+1);
                    nw = level.isWater(x-1, y+1);

                    if(!n && !ne && !nw && e && w)
                    {
                        part = WaterPart.N;
                    }
                    else if(!s && !se && !sw && e && w)
                    {
                        part = WaterPart.S;
                    }
                    else if(!e && !se && !ne && n && s)
                    {
                        part = WaterPart.E;
                    }
                    else if(!w && !sw && !nw && n && s)
                    {
                        part = WaterPart.W;
                    }
                    else if(!s && !se && !sw && e && !w)
                    {
                        part = WaterPart.SW;
                    }
                    else if(!s && !se && !sw && !e && w)
                    {
                        part = WaterPart.SE;
                    }
                    else if(!n && !ne && !nw && e && !w)
                    {
                        part = WaterPart.NW;
                    }
                    else if(!n && !ne && !nw && !e && w)
                    {
                        part = WaterPart.NE;
                    }

                    var e = Factory.createWaterTile(part);
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
