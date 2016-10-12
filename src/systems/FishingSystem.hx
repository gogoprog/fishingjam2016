package systems;

import ash.tools.ListIteratingSystem;
import ash.core.NodeList;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;
import gengine.components.*;

class FishingSystem extends ListIteratingSystem<FisherNode>
{
    private var points = new Array<Entity>();
    private var fishesList:NodeList<FishesNode>;
    private var engine:Engine;

    public function new()
    {
        super(FisherNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;
        super.addToEngine(engine);
        fishesList = engine.getNodeList(FishesNode);
    }

    private function updateNode(node:FisherNode, dt:Float):Void
    {
        var closest:FishesNode = null;
        var closestDistance = Math.POSITIVE_INFINITY;

        node.ship.icon.get(StaticSprite2D).setAlpha(0);

        for(fishes in fishesList)
        {
            var distance = Maths.getVector3DistanceSquared(fishes.entity.position, node.entity.position);
            if(distance < closestDistance)
            {
                closestDistance = distance;
                closest = fishes;
            }
        }

        if(closest != null && closestDistance < 256 * 256)
        {
            if(closestDistance > 96 * 96)
            {
                if(node.ship.targetPosition == null)
                {
                    node.ship.sm.changeState("idling");
                    node.ship.targetPosition = closest.entity.position;
                    node.ship.sm.changeState("moving");
                }
            }
            else
            {
                var e = node.ship.icon;
                var icon:Icon = e.get(Icon);
                var sprite:StaticSprite2D = e.get(StaticSprite2D);

                icon.time += dt;

                sprite.setAlpha(Math.cos(icon.time * 6) * 0.25 + 0.75);
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
