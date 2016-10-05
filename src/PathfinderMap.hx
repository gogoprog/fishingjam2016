import haxe.ds.Vector;
import pathfinder.*;
import gengine.math.*;

class PathfinderMap implements IMap
{
    public var cols:Int;
    public var rows:Int;
    private var factor:Int;
    private var level:Dynamic;

    public function new(level_:Level, _factor:Int)
    {
        level = level_;
        factor = _factor;
        rows = cols = Std.int(level.size / factor);
    }

    public function isWalkable(x:Int, y:Int):Bool
    {
        x *= factor;
        y *= factor;

        if(x >= 0 && x < level.size && y >= 0 && y < level.size)
        {
            return level.data[Std.int(y * level.size + x)] == TileType.Water;
        }

        return false;
    }

    public function convertCoord(c:Coordinate):Vector3
    {
        return new Vector3(c.x * factor * Config.tileSize - level.halfSize.x + Config.tileSize * 0.5 * factor, c.y * factor * Config.tileSize - level.halfSize.y + Config.tileSize * 0.5 * factor, 0);
    }

    public function getCoordinate(x:Float, y:Float)
    {
        return new Coordinate(Math.floor((x + level.halfSize.x) / (Config.tileSize * factor)), Math.floor((y + level.halfSize.y) / (Config.tileSize * factor)));
    }
}
