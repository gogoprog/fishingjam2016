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
    private var startMousePosition:Vector2;
    private var startCameraPosition:Vector3;
    private var zoom = 1.0;

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

        if(input.getMouseButtonPress(1 << 1))
        {
            startMousePosition = new Vector2(mousePosition.x, mousePosition.y);
            startCameraPosition = cameraEntity.position;
        }

        if(input.getMouseButtonDown(1 << 1))
        {
            var delta = new Vector2(mousePosition.x - startMousePosition.x, mousePosition.y - startMousePosition.y);

            cameraEntity.position = new Vector3(startCameraPosition.x - delta.x / zoom, startCameraPosition.y + delta.y / zoom, 0);
        }

        var deltaWheel = input.getMouseMoveWheel();

        if(deltaWheel != 0)
        {
            zoom += deltaWheel * 0.1;
            zoom = Math.max(zoom, 0.2);
            zoom = Math.min(zoom, 1.8);
            cameraEntity.get(Camera).setZoom(zoom);
        }
    }
}
