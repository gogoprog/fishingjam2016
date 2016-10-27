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
        var size = Config.mapSize;
        var background = Factory.createBackground(new Vector2(size * Config.tileSize, size * Config.tileSize));
        var halfSize = new Vector2(size * Config.tileSize * 0.5, size * Config.tileSize * 0.5);
        engine.addEntity(background);

        var level = new Level();

        Session.level = level;

        while(true)
        {
            trace("Generating level...");
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
                        level.setTile(x*2, y*2, TileType.Ground);
                        level.setTile(x*2+1, y*2, TileType.Ground);
                        level.setTile(x*2+1, y*2+1, TileType.Ground);
                        level.setTile(x*2, y*2+1, TileType.Ground);
                    }
                }
            }

            level.startPositions[0] = level.getRandomWaterPositionWith(5, Config.mapSize - 5, 3, 10, 10);
            level.startPositions[1] = level.getRandomWaterPositionWith(5, Config.mapSize - 5, Config.mapSize - 10, Config.mapSize - 3, 10);

            level.init2();

            if(level.startPositions[0] != null && level.startPositions[1] != null && level.isReachable(level.startPositions[0], level.startPositions[1]))
            {
                trace("Done!");
                break;
            }
        }

        var c = level.pathfinderMap.getCoordinate(level.startPositions[0].x, level.startPositions[0].y);
        level.setTiles(c.x * 2, c.y * 2, TileType.None, 8);
        c = level.pathfinderMap.getCoordinate(level.startPositions[1].x, level.startPositions[1].y);
        level.setTiles(c.x * 2, c.y * 2, TileType.None, 8);

        for(x in -1...size+1)
        {
            for(y in -1...size+1)
            {
                var tileType = level.getTileType(x ,y);
                var s, w, n, e, sw, se, ne, nw;

                s = level.isGroundTile(x, y-1);
                w = level.isGroundTile(x-1, y);
                n = level.isGroundTile(x, y+1);
                e = level.isGroundTile(x+1, y);
                sw = level.isGroundTile(x-1, y-1);
                se = level.isGroundTile(x+1, y-1);
                ne = level.isGroundTile(x+1, y+1);
                nw = level.isGroundTile(x-1, y+1);

                switch(tileType)
                {
                    case TileType.Ground:
                    {
                        var part:WaterPart = WaterPart.Full;

                        if(!n && e && w)
                        {
                            part = WaterPart.N;
                        }
                        else if(!s && e && w)
                        {
                            part = WaterPart.S;
                        }
                        else if(!e && n && s)
                        {
                            part = WaterPart.E;
                        }
                        else if(!w && n && s)
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
                        else if(w && n && s && e && !sw)
                        {
                            part = WaterPart.HoleSW;
                        }
                        else if(w && n && s && e && !se)
                        {
                            part = WaterPart.HoleSE;
                        }
                        else if(w && n && s && e && !nw)
                        {
                            part = WaterPart.HoleNW;
                        }
                        else if(w && n && s && e && !ne)
                        {
                            part = WaterPart.HoleNE;
                        }

                        if(part != WaterPart.Full)
                        {
                            var e = Factory.createInvisibleObstacle();
                            e.position = new Vector3(x * Config.tileSize - halfSize.x + Config.tileSize / 2, y * Config.tileSize - halfSize.y + Config.tileSize / 2, 0);
                            engine.addEntity(e);
                        }

                        var e = Factory.createWaterTile(part);
                        e.position = new Vector3(x * Config.tileSize - halfSize.x + Config.tileSize / 2, y * Config.tileSize - halfSize.y + Config.tileSize / 2, 0);
                        engine.addEntity(e);
                    }

                    case TileType.Water:
                    {
                    }

                    case TileType.None:
                    {
                        var e = Factory.createInvisibleObstacle();
                        e.position = new Vector3(x * Config.tileSize - halfSize.x + Config.tileSize / 2, y * Config.tileSize - halfSize.y + Config.tileSize / 2, 0);
                        engine.addEntity(e);
                    }
                }
            }
        }
    }

    static private function randFunc():Float
    {
        return Math.random() - 0.5;
    }
}
