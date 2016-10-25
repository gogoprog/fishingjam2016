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
    public var buildBar:JQuery;
    public var queue:JQuery;

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
        buildBar = new JQuery(".bar");
        queue = new JQuery(".queue");

        new JQuery(".buildFisher").click(function(e)
        {
            var t = Task.tasks["buildFisher"];
            var tasks:Array<Task> = Session.player.home.get(Building).tasks;
            tasks.push(t);
            updateQueue(tasks);
            AudioSystem.instance.playSound("smooth_click");
        });

        new JQuery(".buildFighter").click(function(e)
        {
            var t = Task.tasks["buildFighter"];
            var tasks:Array<Task> = Session.player.home.get(Building).tasks;
            tasks.push(t);
            updateQueue(tasks);
            AudioSystem.instance.playSound("smooth_click");
        });

        updateBuildBar(0.0);
        updateQueue([]);
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

    public function updateBuildBar(f:Float)
    {
        buildBar.css("width", (f * 100) + "%");
    }

    public function updateQueue(list:Array<Task>)
    {
        var content = "";
        for(i in 0...list.length)
        {
            if(i>0)
            {
                content += ", ";
            }

            content += list[i].name;
        }

        queue.text(content);
    }
}
