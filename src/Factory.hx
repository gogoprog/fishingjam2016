import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import haxe.ds.Vector;

class Factory
{
    static private var WORLD = 0x0001;
    static private var TEAM1 = 0x0002;
    static private var TEAM2 = 0x0004;
    static private var BULLET1 = 0x0008;
    static private var BULLET2 = 0x0016;
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

    static public function createShip(teamIndex:Int)
    {
        var e = new Entity();
        var sm = new EntityStateMachine(e);

        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("orangeship.png", true));
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -64), new Vector2(32, 64)));
        e.get(StaticSprite2D).setLayer(20);
        e.add(new Ship());
        e.get(Ship).sm = sm;
        e.get(Ship).teamIndex = teamIndex;
        e.add(new RigidBody2D());
        e.add(new CollisionBox2D());
        e.get(CollisionBox2D).setSize(new Vector2(64, 128));
        e.get(RigidBody2D).setBodyType(2);
        e.get(RigidBody2D).setMass(1);
        e.get(RigidBody2D).setLinearDamping(0.5);
        e.get(RigidBody2D).setAngularDamping(0.5);
        e.get(CollisionBox2D).setDensity(1);
        e.get(CollisionBox2D).setFriction(0.5);
        e.get(CollisionBox2D).setRestitution(0.1);
        e.get(CollisionBox2D).setCategoryBits(TEAM1 << teamIndex);
        e.get(CollisionBox2D).setMaskBits(WORLD | TEAM1 | TEAM2 | (BULLET1 << (1-teamIndex)));

        sm.createState("idling");
        sm.changeState("idling");

        e.get(Ship).movingState = sm.createState("moving")
            .add(ShipMove).withInstance(new ShipMove());

        if(teamIndex == 1)
        {
            e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        }

        return e;
    }

    static public function createFisher(teamIndex:Int)
    {
        var e = createShip(teamIndex);
        e.add(new Fisher());
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("orangeship.png", true));

        e.get(Ship).icon = createIcon("iconFishing.png");
        e.get(Ship).icon.setParent(e);

        return e;
    }

    static public function createFighter(teamIndex:Int)
    {
        var e = createShip(teamIndex);
        e.add(new Fighter());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-48, -64), new Vector2(48, 64)));
        e.get(CollisionBox2D).setSize(new Vector2(96, 128));

        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("orangeship3.png", true));

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

        e.get(RigidBody2D).setBodyType(0);
        e.get(RigidBody2D).setMass(0);
        e.get(CollisionBox2D).setSize(new Vector2(Config.tileSize, Config.tileSize));
        e.get(CollisionBox2D).setDensity(1);
        e.get(CollisionBox2D).setFriction(0.5);
        e.get(CollisionBox2D).setRestitution(0.1);

        return e;
    }

    static public function createIcon(icon:String)
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Icon());

        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-16, -16), new Vector2(16, 16)));
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D(icon, true));
        e.get(StaticSprite2D).setLayer(32);

        e.position = new Vector3(64 - 16, 64 - 16, 0);

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

    static public function createPoint()
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -32), new Vector2(32, 32)));
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("select.png", true));
        e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        e.get(StaticSprite2D).setLayer(10);
        return e;
    }

    static public function createTarget(position:Vector3)
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Target());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -32), new Vector2(32, 32)));
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("select.png", true));
        e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        e.get(StaticSprite2D).setLayer(10);
        e.position = position;
        return e;
    }

    static public function createFishes()
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Fishes());
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -32), new Vector2(32, 32)));
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("fishes.png", true));
        e.get(StaticSprite2D).setColor(new Color(1, 1, 1, 0.5));
        e.get(StaticSprite2D).setLayer(2);
        return e;
    }

    static public function createBullet(teamIndex:Int)
    {
        var e = new Entity();

        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("bullet.png", true));
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-16, -16), new Vector2(16, 16)));
        e.get(StaticSprite2D).setLayer(21);
        e.add(new Bullet());
        e.add(new RigidBody2D());
        e.add(new CollisionCircle2D());
        e.get(CollisionCircle2D).setRadius(8);
        e.get(CollisionCircle2D).setDensity(1);
        e.get(CollisionCircle2D).setFriction(0.5);
        e.get(CollisionCircle2D).setRestitution(0.1);

        e.get(CollisionCircle2D).setCategoryBits(BULLET1 << teamIndex);
        e.get(CollisionCircle2D).setMaskBits(TEAM1 << (1-teamIndex));

        e.get(RigidBody2D).setBodyType(2);
        e.get(RigidBody2D).setMass(1);
        e.get(RigidBody2D).setLinearDamping(0);
        e.get(RigidBody2D).setAngularDamping(0);
        e.get(RigidBody2D).setBullet(true);

        if(teamIndex == 1)
        {
            e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        }

        return e;
    }

    static public function createBuilding(teamIndex:Int)
    {
        var e = new Entity();

        e.add(new StaticSprite2D());
        e.add(new Building());
        e.add(new RigidBody2D());
        e.add(new CollisionCircle2D());

        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("spacestation" + teamIndex + ".png", true));
        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-256, -256), new Vector2(256, 256)));
        e.get(StaticSprite2D).setLayer(20);
        e.get(Building).teamIndex = teamIndex;
        e.get(Building).radius = 200;
        e.get(CollisionCircle2D).setRadius(200);
        e.get(CollisionCircle2D).setCategoryBits(TEAM1 << teamIndex);
        e.get(CollisionCircle2D).setMaskBits(TEAM1 | TEAM2 | (BULLET1 << (1-teamIndex)));
        e.get(RigidBody2D).setBodyType(0);
        e.get(RigidBody2D).setMass(1);

        return e;
    }
}
