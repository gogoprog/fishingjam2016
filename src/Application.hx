import gengine.*;
import gengine.math.*;
import gengine.components.*;
import gengine.graphics.*;

import ash.fsm.*;

import systems.*;
import components.*;
import js.jquery.*;
import js.UIPages;
import js.PagesSet;

class Application
{
    private static var engine:Engine;
    private static var esm:EngineStateMachine;
    public static var pages:PagesSet;

    public static function init()
    {
        Gengine.setWindowSize(new IntVector2(1024, 768));
        Gengine.setWindowTitle("fishingjam2016");
        Gengine.setGuiFilename("gui/gui.html");
    }

    public static function start(_engine:Engine)
    {
        var state:EngineState;
        engine = _engine;
        CollisionManager.engine = _engine;

        Gengine.getRenderer().getDefaultZone().setFogColor(new Color(0.1,0.1,0.1,1));

        Factory.init();
        MapGenerator.init(_engine);
        Session.init(_engine);

        var cameraEntity = Factory.createCamera();

        engine.addEntity(cameraEntity);

        var sceneEntity = Gengine.getScene().getAsEntity();
        sceneEntity.add(new PhysicsWorld2D());
        sceneEntity.get(PhysicsWorld2D).setGravity(new Vector2(0, 0));
        sceneEntity.get(PhysicsWorld2D).setSubStepping(false);
        sceneEntity.get(PhysicsWorld2D).setContinuousPhysics(false);

        esm = new EngineStateMachine(engine);

        state = new EngineState();
        state.addInstance(new MenuSystem());
        esm.addState("menu", state);

        state = new EngineState();
        state.addInstance(new InputSystem(cameraEntity, sceneEntity));
        state.addInstance(new HudSystem());
        state.addInstance(new ShipMoveSystem());
        state.addInstance(new TargetSystem());
        state.addInstance(new FishingSystem());
        state.addInstance(new FightingSystem());
        state.addInstance(new BulletSystem());
        state.addInstance(new IconSystem());
        esm.addState("ingame", state);

        engine.addSystem(new AudioSystem(), 1);

        esm.changeState("menu");

        var viewport:Viewport = new Viewport(Gengine.getContext());
        viewport.setScene(Gengine.getScene());
        viewport.setCamera(cameraEntity.get(Camera));
        Gengine.getRenderer().setViewport(0, viewport);
    }

    public static function onGuiLoaded()
    {
        pages = UIPages.createSet(new JQuery("#body"));

        pages.showPage(".menu");

        engine.getSystem(MenuSystem).init();
    }

    public static function changeState(stateName)
    {
        engine.updateComplete.addOnce(function() {
                esm.changeState(stateName);
            });
    }

    public static function onPhysicsBeginContact2D(entityA:Entity, entityB:Entity)
    {
        CollisionManager.onPhysicsBeginContact2D(entityA, entityB);
    }
}
