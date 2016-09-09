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
            data[i] = TileType.Ground;
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

    public function isWater(x, y)
    {
        if(x >= 0 && x < size && y >= 0 && y < size)
        {
            return data[y * size + x] == TileType.Water;
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


    public function getRandomWaterPosition():Vector3
    {
        while(true)
        {
            var x = Std.random(size);
            var y = Std.random(size);

            if(isWater(x, y))
            {
                return new Vector3(x * Config.tileSize - offset.x, y * Config.tileSize - offset.y, 0);
            }
        }
    }
}
