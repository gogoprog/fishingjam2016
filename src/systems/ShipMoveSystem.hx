package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;

class ShipMoveSystem extends ListIteratingSystem<ShipMoveNode>
{
    public function new()
    {
        super(ShipMoveNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    private function updateNode(node:ShipMoveNode, dt:Float):Void
    {

    }

    private function onNodeAdded(node:ShipMoveNode)
    {

    }

    private function onNodeRemoved(node:ShipMoveNode)
    {

    }
}
