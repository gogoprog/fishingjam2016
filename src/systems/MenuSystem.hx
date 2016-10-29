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
        var that = this;

        new JQuery(".startButton1").click(function(e){
            Application.pages.showPage(".loading");
            Config.mapSize = 128;
            untyped __js__("setTimeout(function() { that.mustStart = true; }, 100);");
        });

        new JQuery(".startButton2").click(function(e){
            Application.pages.showPage(".loading");
            Config.mapSize = 96;
            untyped __js__("setTimeout(function() { that.mustStart = true; }, 100);");
        });

        new JQuery(".startButton3").click(function(e){
            Application.pages.showPage(".loading");
            Config.mapSize = 64;
            untyped __js__("setTimeout(function() { that.mustStart = true; }, 100);");
        });


        new JQuery(".quitButton").click(function(e){
            Gengine.exit();
        });
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
            mustStart = false;
        }
    }
}
