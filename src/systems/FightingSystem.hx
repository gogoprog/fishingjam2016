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
    private var allBuildings:NodeList<BuildingNode>;
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
        allBuildings = engine.getNodeList(BuildingNode);
    }

    private function updateNode(node:FighterNode, dt:Float):Void
    {
        if(node.ship.life <= 0)
        {
            return;
        }

        var targetDistance = Math.POSITIVE_INFINITY;

        if(node.fighter.target != null)
        {
            if((node.fighter.target.has(Ship) && node.fighter.target.get(Ship).life > 0) || (node.fighter.target.has(Building) && node.fighter.target.get(Building).life > 0))
            {
                targetDistance =  Maths.getVector3Distance(node.fighter.target.position, node.entity.position);

                if(targetDistance > node.fighter.range)
                {
                    node.ship.sm.changeState("idling");

                    node.ship.targetPosition = node.fighter.target.position;
                    node.ship.sm.changeState("moving");
                }
            }
        }

        node.fighter.time += dt;

        if(node.fighter.time > node.fighter.shootInterval)
        {
            var closest:Entity = null;
            var closestDistance = Math.POSITIVE_INFINITY;
            var teamIndex = node.ship.teamIndex;

            for(ship in allShips)
            {
                if(ship.ship.teamIndex != teamIndex && ship.ship.life > 0)
                {
                    var distance = Maths.getVector3Distance(ship.entity.position, node.entity.position);
                    if(distance < closestDistance)
                    {
                        closestDistance = distance;
                        closest = ship.entity;
                    }
                }
            }

            for(building in allBuildings)
            {
                if(building.building.teamIndex != teamIndex  && building.building.life > 0)
                {
                    var distance = Maths.getVector3Distance(building.entity.position, node.entity.position);
                    if(distance - building.building.radius < closestDistance)
                    {
                        closestDistance = distance - building.building.radius;
                        closest = building.entity;
                    }
                }
            }

            if(node.fighter.target != null)
            {
                if(targetDistance < node.fighter.range)
                {
                    closest = node.fighter.target;
                    closestDistance = targetDistance;
                    node.ship.targetPosition = null;
                    node.ship.sm.changeState("idling");
                }
            }

            if(closest != null)
            {
                if(closestDistance < node.fighter.range)
                {
                    var e = Factory.createBullet(node.ship.teamIndex);
                    e.position = node.entity.position;
                    var delta = closest.position - e.position;
                    var bullet = e.get(Bullet);
                    bullet.direction = Maths.getNormalizedVector2(new Vector2(delta.x, delta.y));
                    bullet.damage = node.fighter.damage;
                    bullet.duration = node.fighter.range / bullet.speed + 0.1;
                    engine.addEntity(e);

                    AudioSystem.instance.playSound(node.fighter.shootSound, e.position);
                }
                else if(closestDistance < 640 || (node.ship.team.isBot && closestDistance < 1500))
                {
                    if(node.ship.targetPosition == null || node.ship.team.isBot)
                    {
                        node.ship.sm.changeState("idling");
                        node.ship.targetPosition = (closest.position + node.entity.position) * 0.5;
                        node.ship.sm.changeState("moving");
                    }
                }
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
