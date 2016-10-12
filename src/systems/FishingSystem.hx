package systems;

import ash.tools.ListIteratingSystem;
import ash.core.NodeList;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class FishingSystem extends ListIteratingSystem<FisherNode>
{
    private var points = new Array<Entity>();
    private var fishesList:NodeList<FishesNode>;

    public function new()
    {
        super(FisherNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine:Engine)
    {
        super.addToEngine(engine);
        fishesList = engine.getNodeList(FishesNode);
    }

    private function updateNode(node:FisherNode, dt:Float):Void
    {
        var closest:FishesNode = null;
        var closestDistance = Math.POSITIVE_INFINITY;

        if(node.ship.targetPosition == null)
        {
            for(fishes in fishesList)
            {
                var distance = Maths.getVector3DistanceSquared(fishes.entity.position, node.entity.position);
                if(distance < closestDistance)
                {
                    closestDistance = distance;
                    closest = fishes;
                }
            }

            if(closest != null && closestDistance < 128 * 128)
            {
                node.ship.sm.changeState("idling");
                node.ship.targetPosition = closest.entity.position;
                node.ship.sm.changeState("moving");
            }
        }
    }

    private function onNodeAdded(node:FisherNode)
    {
    }

    private function onNodeRemoved(node:FisherNode)
    {
    }
}
