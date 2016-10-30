package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class PoolSystem extends ListIteratingSystem<PoolNode>
{
    private var engine:Engine;

    public function new()
    {
        super(PoolNode, null, null, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function onNodeRemoved(node:PoolNode)
    {
        Factory.addToPool(node.pool.name, node.entity);
    }
}
