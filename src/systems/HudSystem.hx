package systems;

import gengine.*;
import ash.systems.*;
import js.jquery.JQuery;

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
