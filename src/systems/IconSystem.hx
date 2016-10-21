package systems;

import ash.tools.ListIteratingSystem;

import components.*;
import nodes.*;
import gengine.math.*;
import gengine.*;

class IconSystem extends ListIteratingSystem<IconNode>
{
    private var engine:Engine;

    public function new()
    {
        super(IconNode, updateNode, onNodeAdded, onNodeRemoved);
    }

    public override function addToEngine(engine_:Engine)
    {
        engine = engine_;

        super.addToEngine(engine);
    }

    private function updateNode(node:IconNode, dt:Float):Void
    {
        var ppos = node.entity.parent.position;
        var offset = node.icon.offset;

        node.entity.setWorldPosition(new Vector3(ppos.x + offset.x, ppos.y + offset.y, 0));

        node.entity.setWorldRotation2D(0);
    }

    private function onNodeAdded(node:IconNode)
    {
    }

    private function onNodeRemoved(node:IconNode)
    {
    }
}
