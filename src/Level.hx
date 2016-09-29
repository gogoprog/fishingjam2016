import haxe.ds.Vector;
import pathfinder.*;
import gengine.math.*;

class Level implements IMap
{
    public var data:Vector<TileType>;
    public var size:Int;
    public var cols:Int;
    public var rows:Int;
    public var pathfinder:Pathfinder;
    public var offset:Vector2;

    public function new()
    {
    }

    public function init(size_:Int)
    {
        size = size_;

        data = new Vector<TileType>(size * size);
        cols = size;
        rows = size;

        for(i in 0...data.length)
        {
            data[i] = TileType.Water;
        }

        var halfSize = new Vector2(size * Config.tileSize * 0.5, size * Config.tileSize * 0.5);
        offset = new Vector2(halfSize.x + Config.tileSize / 2, halfSize.y + Config.tileSize / 2);
    }

    public function setTile(x, y, value:TileType)
    {
        data[y * size + x] = value;
    }

    public function getTile(x, y)
    {
        return data[y * size + x];
    }

    public function init2()
    {
        pathfinder = new Pathfinder(this);
    }

    public function isWalkable(x:Int, y:Int):Bool
    {
        if(x >= 0 && x < size && y >= 0 && y < size)
        {
            return data[y * size + x] == TileType.Water;
        }

        return false;
    }

    public function isWaterTile(x, y)
    {
        if(x >= 0 && x < size && y >= 0 && y < size)
        {
            return data[y * size + x] == TileType.Water;
        }

        return false;
    }

    public function isWaterPosition(x:Float, y:Float)
    {
        return isWaterTile(Std.int((x + offset.x - Config.tileSize * 0.5) / Config.tileSize), Std.int((y + offset.y - Config.tileSize * 0.5) / Config.tileSize));
    }

    public function isGroundTile(x, y)
    {
        if(x >= 0 && x < size && y >= 0 && y < size)
        {
            return data[y * size + x] == TileType.Ground;
        }

        return false;
    }

    public function getTileType(x:Int, y:Int):TileType
    {
        if(x >= 0 && x < size && y >= 0 && y < size)
        {
            return data[y * size + x];
        }

        return TileType.None;
    }

    public function getCoordinate(x:Float, y:Float)
    {
        return new Coordinate(Std.int((x + offset.x - Config.tileSize * 0.5) / Config.tileSize), Std.int((y + offset.y - Config.tileSize * 0.5) / Config.tileSize));
    }

    public function getRandomWaterPosition():Vector3
    {
        while(true)
        {
            var x = Std.random(size);
            var y = Std.random(size);

            if(isWaterTile(x, y))
            {
                return new Vector3(x * Config.tileSize - offset.x, y * Config.tileSize - offset.y, 0);
            }
        }
    }

    public function createPath(from:Vector3, to:Vector3):Array<Vector3>
    {
        var path = pathfinder.createPath(
            getCoordinate(from.x, from.y),
            getCoordinate(to.x, to.y),
            EHeuristic.PRODUCT,
            false,
            false
        );

        if(path != null && path.length > 1)
        {
            var result = new Array<Vector3>();

            for(i in 1...path.length - 1)
            {
                var c = path[i];
                result.push(new Vector3(c.x * Config.tileSize - offset.x + Config.tileSize * 0.5, c.y * Config.tileSize - offset.y + Config.tileSize * 0.5, 0));
            }

            return result;
        }

        return null;
    }
}
