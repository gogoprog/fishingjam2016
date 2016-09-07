import haxe.ds.Vector;
import pathfinder.*;

class Level implements IMap
{
    public var data:Vector<TileType>;
    public var size:Int;
    public var cols:Int;
    public var rows:Int;
    public var pathfinder:Pathfinder;

    public function new()
    {
    }

    public function init(size_:Int)
    {
        data = new Vector<TileType>(size);
        size = size_;
        cols = size;
        rows = size;

        for(i in 0...data.length)
        {
            data[i] = TileType.Ground;
        }
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

        return true;
    }
}
