import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import components.Tile.TileType;

class Factory
{
    static private var pool:Array<Entity> = new Array<Entity>();

    static public function init()
    {

    }

    static public function createBackground(size:Vector2)
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-size.x/2, -size.y/2), new Vector2(size.x/2, size.y/2)));
        e.get(StaticSprite2D).setTextureRect(new Rect(new Vector2(0, 0), new Vector2(size.x/64, size.y/64)));
        var sprite = Gengine.getResourceCache().getSprite2D("mapTile_188.png", true);
        sprite.getTexture().setAddressMode(0, 1);
        sprite.getTexture().setAddressMode(1, 1);
        e.get(StaticSprite2D).setSprite(sprite);
        e.get(StaticSprite2D).setLayer(0);
        return e;
    }

    static public function createCamera()
    {
        var cameraEntity = new Entity();
        cameraEntity.add(new Camera());
        cameraEntity.get(Camera).setOrthoSize(new Vector2(1024, 768));
        cameraEntity.get(Camera).setOrthographic(true);

        return cameraEntity;
    }

    static public function createTileSprite()
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -32), new Vector2(32, 32)));
        var sprite = Gengine.getResourceCache().getSprite2D("mapTile_005.png", true);
        e.get(StaticSprite2D).setSprite(sprite);
        e.get(StaticSprite2D).setLayer(1);
        return e;
    }
}
