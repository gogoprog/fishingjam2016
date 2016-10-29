package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class BuildingSystem extends ListIteratingSystem<BuildingNode>
{
    private var engine:Engine;

    public function new()
    {
        super(BuildingNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function updateNode(node:BuildingNode, dt:Float):Void
    {
        var b = node.building;
        if(b.currentTask != null)
        {
            var t = b.currentTask;
            b.time += dt;

            if(!node.building.team.isBot && Gengine.getInput().getScancodePress(58))
            {
                b.time = t.duration;
            }

            b.taskStatus = b.time / t.duration;

            if(!b.team.isBot)
            {
                HudSystem.instance.updateBuildBar(b.taskStatus);
            }

            if(b.taskStatus >= 1.0)
            {
                onTaskCompleted(b.currentTask, b.team);
                b.currentTask = null;

                if(!b.team.isBot)
                {
                    HudSystem.instance.updateCurrentBuild("/");
                    HudSystem.instance.updateBuildBar(0.0);
                    AudioSystem.instance.playSound("completed");
                }
            }
        }
        else if(b.tasks.length > 0)
        {
            var t = b.tasks[0];

            if(t.cost <= b.team.fishes)
            {
                b.currentTask = b.tasks.shift();
                b.time = 0;
                b.taskStatus = 0.0;
                b.team.fishes -= t.cost;

                if(!b.team.isBot)
                {
                    HudSystem.instance.updateCurrentBuild(b.currentTask.name);
                    HudSystem.instance.updateQueue(b.tasks);
                }
            }
        }
    }

    private function onNodeAdded(node:BuildingNode)
    {
    }

    private function onNodeRemoved(node:BuildingNode)
    {
    }

    private function onTaskCompleted(task:Task, team:Team)
    {
        var e:Entity;

        switch(task.type)
        {
            case BuildFisher:
                e = Factory.createFisher(team.index);
            case BuildFighter:
                e = Factory.createFighter(team.index);
            case BuildSlowFighter:
                e = Factory.createSlowFighter(team.index);
        }

        if(e != null)
        {
            var angle = Math.random() * 2 * Math.PI;
            e.position = team.home.position + new Vector3(- Math.sin(angle), Math.cos(angle), 0) * 200;
            engine.addEntity(e);
        }
    }
}
