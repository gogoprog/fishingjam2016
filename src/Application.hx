import gengine.*;
import gengine.math.*;
import gengine.components.*;
import gengine.graphics.*;

import ash.fsm.*;

import systems.*;
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

        Gengine.getRenderer().getDefaultZone().setFogColor(new Color(0.8,0.9,0.8,1));

        Factory.init();
        MapGenerator.init(_engine);

        var cameraEntity = Factory.createCamera();

        engine.addEntity(cameraEntity);

        esm = new EngineStateMachine(engine);

        state = new EngineState();
        state.addInstance(new MenuSystem());
        esm.addState("menu", state);

        state = new EngineState();
        state.addInstance(new InputSystem(cameraEntity));
        state.addInstance(new HudSystem());
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
}
