import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import haxe.ds.Vector;

class Factory
{
    static private var pool:Array<Entity> = new Array<Entity>();
    static private var waterSprites = new Map<WaterPart, Dynamic>();

    static public function init()
    {
        waterSprites[WaterPart.Full] = Gengine.getResourceCache().getSprite2D("mapTile_017.png", true);
        waterSprites[WaterPart.S] = Gengine.getResourceCache().getSprite2D("mapTile_032.png", true);
        waterSprites[WaterPart.SW] = Gengine.getResourceCache().getSprite2D("mapTile_031.png", true);
        waterSprites[WaterPart.W] = Gengine.getResourceCache().getSprite2D("mapTile_016.png", true);
        waterSprites[WaterPart.NW] = Gengine.getResourceCache().getSprite2D("mapTile_001.png", true);
        waterSprites[WaterPart.N] = Gengine.getResourceCache().getSprite2D("mapTile_002.png", true);
        waterSprites[WaterPart.NE] = Gengine.getResourceCache().getSprite2D("mapTile_003.png", true);
        waterSprites[WaterPart.E] = Gengine.getResourceCache().getSprite2D("mapTile_018.png", true);
        waterSprites[WaterPart.SE] = Gengine.getResourceCache().getSprite2D("mapTile_033.png", true);
        waterSprites[WaterPart.HoleSE] = Gengine.getResourceCache().getSprite2D("mapTile_004.png", true);
        waterSprites[WaterPart.HoleSW] = Gengine.getResourceCache().getSprite2D("mapTile_005.png", true);
        waterSprites[WaterPart.HoleNE] = Gengine.getResourceCache().getSprite2D("mapTile_019.png", true);
        waterSprites[WaterPart.HoleNW] = Gengine.getResourceCache().getSprite2D("mapTile_020.png", true);
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

    static public function createWaterTile(type:WaterPart)
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Tile());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -32), new Vector2(32, 32)));
        e.get(StaticSprite2D).setSprite(waterSprites[type]);
        e.get(StaticSprite2D).setLayer(1);
        return e;
    }

    static public function createShip()
    {
        var e = new Entity();
        var sm = new EntityStateMachine(e);

        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("ship.png", true));
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-64, -32), new Vector2(64, 32)));
        e.get(StaticSprite2D).setLayer(2);
        e.add(new Ship());
        e.get(Ship).sm = sm;
        e.add(new RigidBody2D());
        e.add(new CollisionBox2D());
        e.get(CollisionBox2D).setSize(new Vector2(128, 64));
        e.get(RigidBody2D).setBodyType(2);
        e.get(RigidBody2D).setMass(1);
        e.get(CollisionBox2D).setDensity(1);
        e.get(CollisionBox2D).setFriction(0.5);
        e.get(CollisionBox2D).setRestitution(0.1);

        sm.createState("idling");
        sm.changeState("idling");

        e.get(Ship).movingState = sm.createState("moving")
            .add(ShipMove).withInstance(new ShipMove());

        return e;
    }

    static public function createInvisibleObstacle()
    {
        var e = new Entity();

        /*e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("red.png", true));
        e.get(StaticSprite2D).setLayer(2);
        e.get(StaticSprite2D).setAlpha(0.5);*/

        e.add(new RigidBody2D());
        e.add(new CollisionBox2D());

        e.get(RigidBody2D).setBodyType(1);
        e.get(RigidBody2D).setMass(0);
        e.get(CollisionBox2D).setSize(new Vector2(Config.tileSize, Config.tileSize));
        e.get(CollisionBox2D).setDensity(1);
        e.get(CollisionBox2D).setFriction(0.5);
        e.get(CollisionBox2D).setRestitution(0.1);

        return e;
    }
    
    static public function createSelectCursor()
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-64, -64), new Vector2(64, 64)));
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("select.png", true));
        e.get(StaticSprite2D).setLayer(10);
        return e;
    }
}
