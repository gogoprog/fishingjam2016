import haxe.ds.Vector;
import pathfinder.*;
import gengine.math.*;

class Level
{
    public var data:Vector<TileType>;
    public var size:Int;
    public var pathfinder:Pathfinder;
    public var pathfinderMap:PathfinderMap;
    public var offset:Vector2;
    public var halfSize:Vector2;

    public function new()
    {
    }

    public function init(size_:Int)
    {
        size = size_;

        data = new Vector<TileType>(size * size);

        for(i in 0...data.length)
        {
            data[i] = TileType.Water;
        }

        halfSize = new Vector2(size * Config.tileSize * 0.5, size * Config.tileSize * 0.5);
        offset = new Vector2(halfSize.x - Config.tileSize / 2, halfSize.y - Config.tileSize / 2);

        pathfinderMap = new PathfinderMap(this, 2);
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
        pathfinder = new Pathfinder(pathfinderMap);
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
        return isWaterTile(Math.floor((x + halfSize.x) / Config.tileSize), Math.floor((y + halfSize.y) / Config.tileSize));
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
            pathfinderMap.getCoordinate(from.x, from.y),
            pathfinderMap.getCoordinate(to.x, to.y),
            EHeuristic.PRODUCT,
            false,
            false
        );

        if(path != null && path.length > 1)
        {
            var result = new Array<Vector3>();

            for(i in 1...path.length - 1)
            {
                result.push(pathfinderMap.convertCoord(path[i]));
            }

            result.push(to);

            return result;
        }

        return null;
    }
}
