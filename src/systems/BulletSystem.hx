package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class BulletSystem extends ListIteratingSystem<BulletNode>
{
    private var engine:Engine;

    public function new()
    {
        super(BulletNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function updateNode(node:BulletNode, dt:Float):Void
    {
        node.bullet.time += dt;

        if(node.bullet.time >= node.bullet.duration)
        {
            engine.removeEntity(node.entity);
        }
    }

    private function onNodeAdded(node:BulletNode)
    {
        node.body.setLinearVelocity(node.bullet.direction * node.bullet.speed);
    }

    private function onNodeRemoved(node:BulletNode)
    {
    }
}
