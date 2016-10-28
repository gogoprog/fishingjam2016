package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class SinkingSystem extends ListIteratingSystem<SinkNode>
{
    private var engine:Engine;

    public function new()
    {
        super(SinkNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function updateNode(node:SinkNode, dt:Float):Void
    {
        node.sink.time += dt;

        var alpha = 1 - node.sink.time / 2.0;

        node.sprite.setAlpha(alpha);

        if(alpha < 0)
        {
            engine.removeEntity(node.entity);
        }
    }

    private function onNodeAdded(node:SinkNode)
    {
    }

    private function onNodeRemoved(node:SinkNode)
    {
    }
}
