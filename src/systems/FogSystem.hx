package systems;

import ash.tools.ListIteratingSystem;
import ash.core.NodeList;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class FogSystem extends ListIteratingSystem<FogNode>
{
    private var engine:Engine;
    private var allShips:NodeList<ShipNode>;

    public function new()
    {
        super(FogNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);

        allShips = engine.getNodeList(ShipNode);
    }

    private function updateNode(node:FogNode, dt:Float):Void
    {
        var fog = node.fog;
        fog.time += dt;

        if(fog.time > 1)
        {
            var highest = Math.NEGATIVE_INFINITY;

            fog.time = 0;

            for(ship in allShips)
            {
                if(!ship.ship.team.isBot)
                {
                    var  p = ship.entity.position;

                    if(p.y > highest)
                    {
                        highest = p.y;
                    }
                }
            }

            var homeY = Session.player.home.position.y;
            if(homeY> highest)
            {
                highest = homeY;
            }

            fog.fromValue = fog.currentValue;
            fog.targetValue = highest;
            fog.currentFactor = 0;
        }

        if(fog.currentFactor < 1)
        {
            fog.currentFactor += dt;
            fog.currentFactor = Math.min(fog.currentFactor, 1);

            fog.currentValue = fog.fromValue + (fog.targetValue - fog.fromValue) * fog.currentFactor;
            node.entity.position = new Vector3(0, fog.currentValue + Session.level.size * Config.tileSize * 0.5 + 800, 0);
        }
    }

    private function onNodeAdded(node:FogNode)
    {
        node.entity.scale = new Vector3(Session.level.size * Config.tileSize / 512, Session.level.size * Config.tileSize / 512, 1);

        node.fog.fromValue = node.fog.targetValue = node.fog.currentValue = Session.player.home.position.y;

        node.entity.position = new Vector3(0, node.fog.currentValue + Session.level.size * Config.tileSize * 0.5 + 800, 0);
    }

    private function onNodeRemoved(node:FogNode)
    {
    }
}
