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

    }

    private function onNodeAdded(node:FisherNode)
    {
    }

    private function onNodeRemoved(node:FisherNode)
    {
    }
}
