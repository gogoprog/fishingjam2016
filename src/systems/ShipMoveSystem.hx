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
        //node.body.applyForceToCenter(new Vector2(10000, 10000), true);

        var currentPath = Session.level.createPath(node.entity.position, node.ship.targetPosition);

        node.move.currentPath = currentPath;

        if(currentPath != null)
        {
            var currentPos = node.entity.position;
            var nextPos = currentPath[0];

            trace(nextPos.x, nextPos.y);
            var velo = new Vector2(nextPos.x - currentPos.x, nextPos.y - currentPos.y);

            node.body.setLinearVelocity(velo);
        }
    }

    private function onNodeAdded(node:ShipMoveNode)
    {

        trace("target",node.ship.targetPosition.x, node.ship.targetPosition.y);

    }

    private function onNodeRemoved(node:ShipMoveNode)
    {
    }
}
