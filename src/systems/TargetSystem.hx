package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class TargetSystem extends ListIteratingSystem<TargetNode>
{
    private var engine:Engine;

    public function new()
    {
        super(TargetNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function updateNode(node:TargetNode, dt:Float):Void
    {
        var e = node.entity;
        var s = e.scale.x - dt * 2;

        e.scale = new Vector3(s, s, s);

        if(s < 0)
        {
            engine.removeEntity(e);
        }
    }

    private function onNodeAdded(node:TargetNode)
    {
    }

    private function onNodeRemoved(node:TargetNode)
    {
    }
}
