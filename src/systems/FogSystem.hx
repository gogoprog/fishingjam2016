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
        node.fog.time += dt;

        if(node.fog.time > 1)
        {
            var highest = Math.NEGATIVE_INFINITY;

            node.fog.time = 0;

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

            node.entity.position = new Vector3(0,  highest + Session.level.size * Config.tileSize * 0.5 + 800, 0);
        }
    }

    private function onNodeAdded(node:FogNode)
    {
        node.entity.scale = new Vector3(Session.level.size * Config.tileSize / 512, Session.level.size * Config.tileSize / 512, 1);
    }

    private function onNodeRemoved(node:FogNode)
    {
    }
}
