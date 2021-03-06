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
    public var currentBuild:JQuery;

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
        currentBuild = new JQuery(".currentBuild");

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

        new JQuery(".buildSlowFighter").click(function(e)
        {
            var t = Task.tasks["buildSlowFighter"];
            var tasks:Array<Task> = Session.player.home.get(Building).tasks;
            tasks.push(t);
            updateQueue(tasks);
            AudioSystem.instance.playSound("smooth_click");
        });

        new JQuery(".removeTask").click(function(e)
        {
            var tasks:Array<Task> = Session.player.home.get(Building).tasks;

            if(tasks.length > 0)
            {
                tasks.shift();
                updateQueue(tasks);
            }

            AudioSystem.instance.playSound("smooth_click");
        });

        updateBuildBar(0.0);
        updateQueue([]);
        fishesSpan.text(Session.player.fishes);

        new JQuery(".result").hide();
    }

    override public function update(dt:Float):Void
    {
        var input = Gengine.getInput();

        if(input.getScancodePress(41))
        {
            Gengine.exit();
        }

        if(input.getScancodePress(62))
        {
            Session.start();
        }

        if(input.getScancodePress(59))
        {
            Session.player.fishes += 10000;
        }

        if(input.getScancodePress(60))
        {
            engine.removeEntity(engine.getEntityByName("fog"));
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

    public function updateCurrentBuild(name:String)
    {
        currentBuild.text(name);
    }

    public function updateQueue(list:Array<Task>)
    {
        var content = "";
        var previous = "";
        var mult = 1;
        for(i in 0...list.length)
        {
            var name = list[i].name;

            if(previous == name)
            {
                ++mult;
            }
            else
            {
                if(mult > 1)
                {
                    content += " x" + mult;
                }

                mult = 1;
            }

            if(previous != name)
            {
                if(i>0)
                {
                    content += ", ";
                }

                content += list[i].name;
            }

            previous = name;
        }

        if(mult > 1)
        {
            content += " x" + mult;
        }

        queue.text(content);
    }

    public function showResult(result)
    {
        var div = new JQuery(".result");
        div.text(result);
        div.show();
    }
}
