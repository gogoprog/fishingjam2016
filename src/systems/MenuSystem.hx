package systems;

import gengine.*;
import ash.systems.*;
import js.jquery.JQuery;

@:expose('Menu')
class MenuSystem extends System
{
    private var engine:Engine;
    private var mustStart = false;

    public function new()
    {
        super();
    }

    public function init()
    {
        new JQuery(".startButton").click(onStartClick);
        new JQuery(".quitButton").click(onQuitClick);
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;
        AudioSystem.instance.playMenuMusic();
    }

    override public function update(dt:Float):Void
    {
        var input = Gengine.getInput();

        if(input.getScancodePress(41))
        {
            Gengine.exit();
        }

        if(mustStart)
        {
            Application.changeState("ingame");
            Application.pages.showPage(".hud");
            Session.start();
        }
    }

    private function onStartClick(event)
    {
        var that = this;
        Application.pages.showPage(".loading");
        untyped __js__("setTimeout(function() { that.mustStart = true; }, 100);");
    }

    private function onQuitClick(event)
    {
        Gengine.exit();
    }
}
