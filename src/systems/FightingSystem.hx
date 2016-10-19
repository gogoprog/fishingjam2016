package systems;

import ash.tools.ListIteratingSystem;
import ash.core.NodeList;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;
import gengine.components.*;

class FightingSystem extends ListIteratingSystem<FighterNode>
{
    private var points = new Array<Entity>();
    private var allShips:NodeList<ShipNode>;
    private var engine:Engine;

    public function new()
    {
        super(FighterNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;
        super.addToEngine(engine);
        allShips = engine.getNodeList(ShipNode);
    }

    private function updateNode(node:FighterNode, dt:Float):Void
    {
        node.fighter.time += dt;

        if(node.fighter.time > 1)
        {
            var closest:ShipNode = null;
            var closestDistance = Math.POSITIVE_INFINITY;
            var teamIndex = node.ship.teamIndex;

            for(ship in allShips)
            {
                if(ship.ship.teamIndex != teamIndex)
                {
                    var distance = Maths.getVector3DistanceSquared(ship.entity.position, node.entity.position);
                    if(distance < closestDistance)
                    {
                        closestDistance = distance;
                        closest = ship;
                    }
                }
            }

            if(closest != null && closestDistance < 312 * 312)
            {
                var e = Factory.createBullet(node.ship.teamIndex);
                e.position = node.entity.position;
                var delta = closest.entity.position - e.position;

                e.get(Bullet).direction = Maths.getNormalizedVector2(new Vector2(delta.x, delta.y));
                engine.addEntity(e);
            }

            node.fighter.time = 0;
        }
    }

    private function onNodeAdded(node:FighterNode)
    {
    }

    private function onNodeRemoved(node:FighterNode)
    {
    }
}
