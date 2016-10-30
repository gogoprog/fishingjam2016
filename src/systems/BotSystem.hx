package systems;

import ash.core.NodeList;
import gengine.*;
import ash.systems.*;
import components.*;
import nodes.*;
import gengine.math.*;

class BotSystem extends System
{
    private var engine:Engine;
    private var time = 0.0;
    private var team:Team;
    private var fishesList:NodeList<FishesNode>;
    private var allShips:NodeList<ShipNode>;
    private var allFishers:NodeList<FisherNode>;
    private var sortedFishes = new Array<FishesNode>();

    public function new()
    {
        super();
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;
        team = Session.teams[1];

        fishesList = engine.getNodeList(FishesNode);
        allShips = engine.getNodeList(ShipNode);
        allFishers = engine.getNodeList(FisherNode);

        sortedFishes = [];

        for(node in fishesList)
        {
            sortedFishes.push(node);
        }

        var homePosition = team.home.position;

        sortedFishes.sort(
            function(a:FishesNode, b:FishesNode)
            {
                var aDistance = Maths.getVector3DistanceSquared(homePosition, a.entity.position);
                var bDistance = Maths.getVector3DistanceSquared(homePosition, b.entity.position);

                return Std.int(aDistance - bDistance);
            }
        );

        var tasks:Array<Task> = team.home.get(Building).tasks;

        var t = Task.tasks["buildFisher"];
        tasks.push(t);
        tasks.push(t);
        var t = Task.tasks["buildFighter"];
        tasks.push(t);
        tasks.push(t);
        var t = Task.tasks["buildFisher"];
        tasks.push(t);
    }

    override public function update(dt:Float):Void
    {
        time += dt;

        if(time > 3)
        {
            var n = 0;
            var money = team.fishes;

            for(node in allFishers)
            {
                if(node.ship.team.isBot && node.ship.life > 0)
                {
                    node.ship.sm.changeState("idling");

                    node.ship.targetPosition = sortedFishes[n].entity.position;
                    node.ship.sm.changeState("moving");
                    n++;
                }
            }

            time = 0.0;
            var tasks:Array<Task> = team.home.get(Building).tasks;

            if(tasks.length == 0)
            {
                if(money > 1000)
                {
                    var t = Task.tasks["buildSlowFighter"];
                    tasks.push(t);
                }
                else
                {
                    var t = Task.tasks["buildFighter"];
                    tasks.push(t);
                }
            }
        }
    }
}
