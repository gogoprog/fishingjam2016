package systems;

import gengine.*;
import ash.systems.*;
import js.jquery.JQuery;

class HudSystem extends System
{
    private var engine:Engine;

    public function new()
    {
        super();
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;

        new JQuery("input").change(onChange);
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
            MapGenerator.generate();
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
