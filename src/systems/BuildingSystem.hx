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
            b.taskStatus = b.time / t.duration;

            if(b.taskStatus >= 1.0)
            {
                onTaskCompleted(b.currentTask);
                b.currentTask = null;
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
                trace("building", t.type);
            }
        }
    }

    private function onNodeAdded(node:BuildingNode)
    {
    }

    private function onNodeRemoved(node:BuildingNode)
    {
    }

    private function onTaskCompleted(task:Task)
    {
        trace("onTaskCompleted", task.type);
        switch(task.type)
        {
            case BuildFisher:
            case BuildFighter:
        }
    }
}
