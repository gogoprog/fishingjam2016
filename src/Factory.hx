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
    static private var poolMap:Map<String, Array<Entity>> = new Map<String, Array<Entity>>();
    static private var waterSprites = new Map<WaterPart, Dynamic>();
    static private var explosionEffect;
    static private var explosionEffect2;

    static public function init()
    {
        poolMap["bullet"] = new Array<Entity>();
        poolMap["target"] = new Array<Entity>();
        poolMap["explosion"] = new Array<Entity>();
        poolMap["fighter"] = new Array<Entity>();
        poolMap["fisher"] = new Array<Entity>();
        poolMap["slowFighter"] = new Array<Entity>();

        explosionEffect = Gengine.getResourceCache().getParticleEffect2D("sun.pex", true);
        explosionEffect2 = Gengine.getResourceCache().getParticleEffect2D("sun2.pex", true);

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

    static public function addToPool(name:String, e:Entity)
    {
        poolMap[name].push(e);
        e.position = new Vector3(-1000000, 0, 0);
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
        var e:Entity;
        var sm:EntityStateMachine;

        e = new Entity();
        sm = new EntityStateMachine(e);

        e.add(new StaticSprite2D());
        e.get(StaticSprite2D).setLayer(20);
        e.add(new Ship());
        e.get(Ship).sm = sm;
        e.add(new RigidBody2D());
        e.add(new CollisionBox2D());
        e.get(RigidBody2D).setBodyType(2);
        e.get(RigidBody2D).setMass(1);
        e.get(RigidBody2D).setLinearDamping(0.5);
        e.get(RigidBody2D).setAngularDamping(0.5);
        e.get(CollisionBox2D).setDensity(1);
        e.get(CollisionBox2D).setFriction(0.5);
        e.get(CollisionBox2D).setRestitution(0.1);

        sm.createState("idling");

        e.get(Ship).movingState = sm.createState("moving")
            .add(ShipMove).withInstance(new ShipMove());

        e.get(Ship).bgBar = createBar(33);
        e.get(Ship).bgBar.setParent(e);

        e.get(Ship).healthBar = createBar(34);
        e.get(Ship).healthBar.setParent(e);

        e.get(Ship).movingState = sm.createState("dying")
            .add(Sink).withInstance(new Sink());

        sm.changeState("idling");

        return e;
    }

    static public function createFisher(teamIndex:Int)
    {
        var pool = poolMap["fisher"];
        var e:Entity;

        if(pool.length > 0)
        {
            e = pool.shift();
        }
        else
        {
            e = createShip();
            e.add(new Pool("fisher"));
            e.add(new Fisher());
            e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("orangeship.png", true));
            e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -64), new Vector2(32, 64)));
            e.get(CollisionBox2D).setSize(new Vector2(64, 128));
            e.get(Ship).icon = createIcon("iconFishing.png");
            e.get(Ship).icon.setParent(e);
        }

        e.get(Ship).teamIndex = teamIndex;
        e.get(CollisionBox2D).setCategoryBits(TEAM1 << teamIndex);
        e.get(CollisionBox2D).setMaskBits(WORLD | TEAM1 | TEAM2 | (BULLET1 << (1-teamIndex)));

        if(teamIndex == 1)
        {
            e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        }
        else
        {
            e.get(StaticSprite2D).setColor(new Color(1, 1, 1, 1));
        }

        e.get(Ship).speed = 100;
        e.get(Ship).life = 150;
        e.get(Ship).maxLife = 150;
        e.get(Ship).bgBar.get(StaticSprite2D).setAlpha(1);
        e.get(Ship).sm.changeState("idling");
        e.get(Ship).healthBar.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        e.get(Ship).healthBar.setScale(new Vector3(1, 1, 1));

        return e;
    }

    static public function createFighter(teamIndex:Int)
    {
        var pool = poolMap["fighter"];
        var e:Entity;

        if(pool.length > 0)
        {
            e = pool.shift();
        }
        else
        {
            e = createShip();
            e.add(new Pool("fighter"));
            e.add(new Fighter());
            e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("smallorange.png", true));
            e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-32, -48), new Vector2(32, 48)));
            e.get(CollisionBox2D).setSize(new Vector2(64, 96));
            e.get(Fighter).shootInterval = 0.5;
            e.get(Fighter).damage = 3;
        }

        e.get(Ship).teamIndex = teamIndex;
        e.get(CollisionBox2D).setCategoryBits(TEAM1 << teamIndex);
        e.get(CollisionBox2D).setMaskBits(WORLD | TEAM1 | TEAM2 | (BULLET1 << (1-teamIndex)));

        if(teamIndex == 1)
        {
            e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        }
        else
        {
            e.get(StaticSprite2D).setColor(new Color(1, 1, 1, 1));
        }

        e.get(Ship).speed = 300;
        e.get(Ship).life = 50;
        e.get(Ship).maxLife = 50;
        e.get(Ship).sm.changeState("idling");
        e.get(Ship).bgBar.get(StaticSprite2D).setAlpha(1);
        e.get(Ship).healthBar.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        e.get(Ship).healthBar.setScale(new Vector3(1, 1, 1));

        e.get(Fighter).target = null;

        return e;
    }

    static public function createSlowFighter(teamIndex:Int)
    {
        var pool = poolMap["slowFighter"];
        var e:Entity;

        if(pool.length > 0)
        {
            e = pool.shift();
        }
        else
        {
            e = createShip();
            e.add(new Pool("slowFighter"));
            e.add(new Fighter());
            e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("orangeship3.png", true));
            e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-60, -80), new Vector2(60, 80)));
            e.get(CollisionBox2D).setSize(new Vector2(120, 160));
            e.get(Ship).speed = 50;
            e.get(Fighter).damage = 30;
            e.get(Fighter).shootInterval = 2;
            e.get(Fighter).range = 640;
        }

        e.get(Ship).teamIndex = teamIndex;
        e.get(CollisionBox2D).setCategoryBits(TEAM1 << teamIndex);
        e.get(CollisionBox2D).setMaskBits(WORLD | TEAM1 | TEAM2 | (BULLET1 << (1-teamIndex)));

        if(teamIndex == 1)
        {
            e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        }
        else
        {
            e.get(StaticSprite2D).setColor(new Color(1, 1, 1, 1));
        }

        e.get(Ship).life = 500;
        e.get(Ship).maxLife = 500;
        e.get(Ship).bgBar.get(StaticSprite2D).setAlpha(1);

        e.get(Fighter).shootSound = "canon";

        e.get(Ship).sm.changeState("idling");
        e.get(Ship).healthBar.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        e.get(Ship).healthBar.setScale(new Vector3(1, 1, 1));

        e.get(Fighter).target = null;

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

        return e;
    }

    static public function createBar(layer:Int, ?halfWidth = 32, ?offsetY = 56)
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Icon());

        e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-halfWidth, -4), new Vector2(halfWidth, 4)));
        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("white.png", true));
        e.get(StaticSprite2D).setLayer(layer);
        e.get(StaticSprite2D).setColor(new Color(0, 0, 0, 1));

        e.get(Icon).offset = new Vector2(0, offsetY);

        return e;
    }

    static public function createFog()
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Fog());

        e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("fog.png", true));
        e.get(StaticSprite2D).setLayer(60);
        e.get(StaticSprite2D).setColor(new Color(0.1, 0.1, 0.1, 1));

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

    static public function createTarget(position:Vector3, color:Color)
    {
        var pool = poolMap["target"];
        var e:Entity;

        if(pool.length > 0)
        {
            e = pool.shift();
        }
        else
        {
            e = new Entity();
            e.add(new Pool("target"));
            e.add(new StaticSprite2D());
            e.add(new Target());
            e.get(StaticSprite2D).setDrawRect(new Rect(new Vector2(-64, -64), new Vector2(64, 64)));
            e.get(StaticSprite2D).setSprite(Gengine.getResourceCache().getSprite2D("select.png", true));
            e.get(StaticSprite2D).setLayer(10);
        }

        e.get(StaticSprite2D).setColor(color);
        e.get(StaticSprite2D).setAlpha(1);

        e.scale = new Vector3(1, 1, 1);
        e.position = position;
        return e;
    }

    static public function createFishes()
    {
        var e = new Entity();
        e.add(new StaticSprite2D());
        e.add(new Fishes());

        e.add(new AnimatedSprite2D(Gengine.getResourceCache().getAnimationSet2D('fishes.scml', true), "move"));
        e.get(AnimatedSprite2D).setLayer(2);
        e.get(AnimatedSprite2D).setColor(new Color(1, 1, 1, 0.5));
        e.get(AnimatedSprite2D).setSpeed(0.5);

        e.scale = new Vector3(1.2, 1.2, 1);

        return e;
    }

    static public function createBullet(teamIndex:Int)
    {
        var pool = poolMap["bullet"];
        var e:Entity;

        if(pool.length > 0)
        {
            e = pool.shift();
        }
        else
        {
            e = new Entity();
            e.add(new Pool("bullet"));
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
            e.get(RigidBody2D).setBodyType(2);
            e.get(RigidBody2D).setMass(1);
            e.get(RigidBody2D).setLinearDamping(0);
            e.get(RigidBody2D).setAngularDamping(0);
            e.get(RigidBody2D).setBullet(true);
        }

        e.get(CollisionCircle2D).setCategoryBits(BULLET1 << teamIndex);
        e.get(CollisionCircle2D).setMaskBits(TEAM1 << (1-teamIndex));
        e.get(Bullet).time = 0;

        if(teamIndex == 1)
        {
            e.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));
        }
        else
        {
            e.get(StaticSprite2D).setColor(new Color(1, 1, 1, 1));

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
        e.get(CollisionCircle2D).setRadius(160);
        e.get(CollisionCircle2D).setCategoryBits(TEAM1 << teamIndex);
        e.get(CollisionCircle2D).setMaskBits(TEAM1 | TEAM2 | (BULLET1 << (1-teamIndex)));
        e.get(RigidBody2D).setBodyType(0);
        e.get(RigidBody2D).setMass(1);

        var bgBar = createBar(33, 170, 200);
        bgBar.setParent(e);

        e.get(Building).healthBar = createBar(34, 170, 200);
        e.get(Building).healthBar.setParent(e);
        e.get(Building).healthBar.get(StaticSprite2D).setColor(new Color(0, 1, 0, 1));

        return e;
    }

    static public function createExplosion()
    {
        var pool = poolMap["explosion"];
        var e:Entity;

        if(pool.length > 0)
        {
            e = pool.shift();
        }
        else
        {
            e = new Entity();
            e.add(new Pool("explosion"));
            e.add(new ParticleEmitter2D());
            e.add(new AutoRemove());
            var particleEmitter2D:ParticleEmitter2D = e.get(ParticleEmitter2D);
            particleEmitter2D.setLayer(22);
        }

        e.get(ParticleEmitter2D).setEffect(explosionEffect2);
        e.get(ParticleEmitter2D).setEffect(explosionEffect);

        return e;
    }
}
