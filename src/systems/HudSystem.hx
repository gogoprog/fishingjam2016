package systems;

import gengine.*;
import components.*;
import ash.systems.*;
import js.jquery.JQuery;
import Task;

class HudSystem extends System
{
    static public var instance:HudSystem;

    private var engine:Engine;

    public var fishesSpan:JQuery;

    public function new()
    {
        super();
        instance = this;
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;

        new JQuery("input").change(onChange);

        fishesSpan = new JQuery(".fishes");

        new JQuery(".buildFisher").click(function(e)
        {
            var t = Task.tasks["buildFisher"];
            Session.player.home.get(Building).tasks.push(t);
        });

        new JQuery(".buildFighter").click(function(e)
        {
            var t = Task.tasks["buildFighter"];
            Session.player.home.get(Building).tasks.push(t);
        });
    }

    override public function update(dt:Float):Void
    {
        var input = Gengine.getInput();

        if(input.getScancodePress(41))
        {
            Gengine.exit();
        }

        if(input.getScancodePress(44))
        {
            Session.start();
        }
    }

    private function onChange(event)
    {
        var freq = new JQuery(".freq").val();
        var octaves = new JQuery(".octaves").val();
        var threshold = new JQuery(".threshold").val();

        MapGenerator.frequency = freq;
        MapGenerator.octaves = octaves;
        MapGenerator.threshold = threshold;
    }
}
