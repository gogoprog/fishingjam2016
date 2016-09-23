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

        
    }

    private function onNodeAdded(node:ShipMoveNode)
    {
        //node.body.applyLinearImpulse(new Vector2(Std.random(10) * 10000, Std.random(10) * 10000), new Vector2(0, 0), true);
        //node.body.setLinearVelocity(new Vector2(Std.random(100) - 50, Std.random(100) - 50));
        
        trace(node.ship.targetPosition);
        
        node.move.currentPath = Session.level.createPath(node.entity.position, node.ship.targetPosition);
    }

    private function onNodeRemoved(node:ShipMoveNode)
    {

    }
}
