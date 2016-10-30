package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class AutoRemoveSystem extends ListIteratingSystem<AutoRemoveNode>
{
    private var engine:Engine;

    public function new()
    {
        super(AutoRemoveNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function updateNode(node:AutoRemoveNode, dt:Float):Void
    {
        node.autoRemove.time += dt;

        if(node.autoRemove.time >= node.autoRemove.duration)
        {
            engine.removeEntity(node.entity);
        }
    }

    private function onNodeAdded(node:AutoRemoveNode)
    {
    }

    private function onNodeRemoved(node:AutoRemoveNode)
    {
    }
}
