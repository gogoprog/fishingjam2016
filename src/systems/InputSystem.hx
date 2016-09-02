package systems;

import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import nodes.*;
import gengine.math.*;
import haxe.ds.Vector;

class InputSystem extends System
{
    private var engine:Engine;
    private var cameraEntity:Entity;

    public function new(cameraEntity_:Entity)
    {
        super();
        cameraEntity = cameraEntity_;
    }

    override public function addToEngine(_engine:Engine)
    {

    }

    override public function update(dt:Float):Void
    {
        var input = Gengine.getInput();
        var mousePosition = input.getMousePosition();
        var mouseScreenPosition = new Vector2(mousePosition.x / 1024, mousePosition.y / 768);
        var mouseWorldPosition = cameraEntity.get(Camera).screenToWorldPoint(new Vector3(mouseScreenPosition.x, mouseScreenPosition.y, 0));

        if(input.getScancodePress(41))
        {
            Gengine.exit();
        }
    }
}
