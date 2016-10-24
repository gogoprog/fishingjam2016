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
    }

    public override function addToEngine(engine:Engine)
    {
        super.addToEngine(engine);

        /*for(i in 0...100)
        {
            points.push(Factory.createPoint());
            engine.addEntity(points[i]);
        }*/
    }

    private function updateNode(node:ShipMoveNode, dt:Float):Void
    {
        if(node.ship.life <= 0)
        {
            return;
        }

        var currentPath = Session.level.createPath(node.entity.position, node.ship.targetPosition);

        node.move.currentPath = currentPath;

        if(currentPath != null)
        {
            var currentPos = node.entity.position;
            var nextPos:Vector3 = null;

            for(i in 0...currentPath.length)
            {
                var d = Maths.getVector3DistanceSquared(currentPos, currentPath[i]);

                if(d > 8 * 8)
                {
                    nextPos = currentPath[i];
                    break;
                }
            }

            if(nextPos != null)
            {
                var velo = new Vector2(nextPos.x - currentPos.x, nextPos.y - currentPos.y);
                var v = node.ship.speed;

                if(nextPos == currentPath[currentPath.length - 1])
                {
                    v = Math.min(node.ship.speed, Maths.getVector3Distance(nextPos, currentPos));
                }

                velo = Maths.getNormalizedVector2(velo) * v;

                var a = Math.atan2(velo.y, velo.x);
                node.entity.setRotation2D(a*180/Math.PI - 90);

                node.body.setLinearVelocity(velo);
                node.body.setFixedRotation(true);

                /*for(i in 0...currentPath.length)
                {
                    if(i>=100) break;
                    points[i].position = currentPath[i];
                }*/

                return;
            }
        }

        node.body.setLinearVelocity(new Vector2(0, 0));
        node.body.setFixedRotation(false);

        node.ship.sm.changeState("idling");
        node.ship.targetPosition = null;
    }

    private function onNodeAdded(node:ShipMoveNode)
    {
    }

    private function onNodeRemoved(node:ShipMoveNode)
    {
    }
}
