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
    public var startPositions = new Vector<Vector3>(2);

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

    public function setTiles(x, y, value:TileType, _size:Int)
    {
        var hsize = Std.int(_size / 2);

        for(i in x - hsize ... x + hsize + 1)
        {
            for(j in y - hsize ... y + hsize + 1)
            {
                data[j * size + i] = value;
            }
        }
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

    public function getTilePosition(pos:Vector3):Coordinate
    {
        var i = (pos.x + offset.x) / Config.tileSize;
        var j = (pos.y + offset.y) / Config.tileSize;

        return new Coordinate(Math.floor(i), Math.floor(j));
    }

    public function getRandomWaterPositionWith(minX:Int, maxX:Int, minY:Int, maxY:Int, _size:Int):Vector3
    {
        for(n in 0...1000)
        {
            var x = minX + Std.random(maxX - minX);
            var y = minY + Std.random(maxY - minY);

            var hsize = Std.int(_size / 2);

            var good = true;

            for(i in x - hsize ... x + hsize + 1)
            {
                for(j in y - hsize ... y + hsize + 1)
                {
                    if(!isWaterTile(i, j))
                    {
                        good = false;
                        break;
                    }
                }
            }

            if(good)
            {
                return new Vector3(x * Config.tileSize - offset.x, y * Config.tileSize - offset.y, 0);
            }
        }

        return null;
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

        var result = new Array<Vector3>();

        if(path != null)
        {
            for(i in 1...path.length - 1)
            {
                result.push(pathfinderMap.convertCoord(path[i]));
            }
        }

        result.push(to);

        return result;
    }

    public function isReachable(from:Vector3, to:Vector3):Bool
    {
        var path = pathfinder.createPath(
            pathfinderMap.getCoordinate(from.x, from.y),
            pathfinderMap.getCoordinate(to.x, to.y),
            EHeuristic.PRODUCT,
            false,
            false
        );

        return path != null;
    }
}
