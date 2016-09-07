import haxe.ds.Vector;

class Level
{
    public var data:Vector<TileType>;
    public var size:Int;

    public function new()
    {
    }

    public function init(size_:Int)
    {
        data = new Vector<TileType>(size);
        size = size_;

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

    public function isWater(x, y)
    {
        if(x >= 0 && x < size && y >= 0 && y < size)
        {
            return data[y * size + x] == TileType.Water;
        }

        return true;
    }
}
