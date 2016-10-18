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
            if(Std.random(2) == 0)
            {
                var e = Factory.createBullet(node.ship.teamIndex);

                e.position = node.entity.position;
                e.get(Bullet).direction = Maths.getNormalizedVector2(new Vector2(Math.random() * 2 - 1, Math.random() * 2 - 1));

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
