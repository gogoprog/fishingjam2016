package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class ShipMoveSystem extends ListIteratingSystem<ShipMoveNode>
{
    private var points = new Array<Entity>();

    public function new()
    {
        super(ShipMoveNode, updateNode, onNodeAdded, onNodeRemoved);

        for(i in 0...100)
        {
            points.push(Factory.createPoint());
        }
    }
    
    public override function addToEngine(engine:Engine)
    {
        super.addToEngine(engine);
        
        for(i in 0...100)
        {
            engine.addEntity(points[i]);
        }
    }

    private function updateNode(node:ShipMoveNode, dt:Float):Void
    {
        var currentPath = Session.level.createPath(node.entity.position, node.ship.targetPosition);

        node.move.currentPath = currentPath;

        if(currentPath != null)
        {
            var currentPos = node.entity.position;
            var nextPos:Vector3 = null;
            
            for(i in 0...currentPath.length)
            {
                nextPos = currentPath[i];
                break;
            }

            if(nextPos != null)
            {
                var velo = new Vector2(nextPos.x - currentPos.x, nextPos.y - currentPos.y);

                node.body.setLinearVelocity(velo);
                
                for(i in 0...currentPath.length)
                {
                    if(i>=100) break;
                    points[i].position = currentPath[i];
                }
            }
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
