package systems;

import gengine.*;
import gengine.components.*;
import gengine.physics.*;
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
    private var sceneEntity:Entity;
    private var startMousePosition:Vector2;
    private var startCameraPosition:Vector3;
    private var zoom = 1.0;
    private var selectedShips = new Array<Entity>();
    private var selectCursors = new Array<Entity>();

    public function new(cameraEntity_:Entity, sceneEntity_:Entity)
    {
        super();
        cameraEntity = cameraEntity_;
        sceneEntity = sceneEntity_;
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;
    }

    override public function update(dt:Float):Void
    {
        var input = Gengine.getInput();
        var mousePosition = input.getMousePosition();
        if(mousePosition.y < 570)
        {
            var mouseScreenPosition = new Vector2(mousePosition.x / 1024, mousePosition.y / 768);
            var mouseWorldPosition:Vector3 = cameraEntity.get(Camera).screenToWorldPoint(new Vector3(mouseScreenPosition.x, mouseScreenPosition.y, 0));

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
                zoom = Math.max(zoom, 0.1);
                zoom = Math.min(zoom, 1.8);
                cameraEntity.get(Camera).setZoom(zoom);
            }

            if(input.getMouseButtonPress(1))
            {
                var result:Entity = sceneEntity.get(PhysicsWorld2D).getEntity(new Vector2(mouseWorldPosition.x, mouseWorldPosition.y));

                if(result != null && result.has(Ship))
                {
                    if(!Session.teams[result.get(Ship).teamIndex].isBot)
                    {
                        if(!input.getScancodeDown(225))
                        {
                            unselectAll();
                            selectShip(result);

                        }
                        else
                        {
                            if(selectedShips.indexOf(result) != -1)
                            {
                                unselectShip(result);
                            }
                            else
                            {
                                selectShip(result);
                            }
                        }

                        AudioSystem.instance.playSound("click");
                    }
                }
                else
                {
                    unselectAll();
                }
            }

            if(selectedShips.length > 0)
            {
                if(input.getMouseButtonPress(1 << 2))
                {
                    var result:Entity = sceneEntity.get(PhysicsWorld2D).getEntity(new Vector2(mouseWorldPosition.x, mouseWorldPosition.y));

                    if(result != null && ((result.has(Ship) && Session.teams[result.get(Ship).teamIndex].isBot) || (result.has(Building) && Session.teams[result.get(Building).teamIndex].isBot)) && haveSelectedShips(Fighter))
                    {
                        for(selectedShip in selectedShips)
                        {
                            selectedShip.get(Fighter).target = result;
                        }
                        engine.addEntity(Factory.createTarget(result.position, new Color(1, 0, 0, 1)));
                    }
                    else if(Session.level.isWaterPosition(mouseWorldPosition.x, mouseWorldPosition.y))
                    {
                        for(selectedShip in selectedShips)
                        {
                            selectedShip.get(Ship).sm.changeState("idling");

                            selectedShip.get(Ship).targetPosition = mouseWorldPosition;
                            selectedShip.get(Ship).sm.changeState("moving");

                            engine.addEntity(Factory.createTarget(mouseWorldPosition, new Color(0, 1, 0, 1)));

                            AudioSystem.instance.playSound("move", selectedShip.position);

                            if(selectedShip.has(Fighter))
                            {
                                selectedShip.get(Fighter).target = null;
                            }
                        }
                    }
                }
            }
        }

        for(i in 0...selectedShips.length)
        {
            selectCursors[i].position = selectedShips[i].position;
        }

        var camPos = cameraEntity.position;
        var camZoom = cameraEntity.get(Camera).getZoom();

        if(input.getScancodeDown(26))
        {
            camPos.y += (750 * dt) / camZoom;
        }
        if(input.getScancodeDown(22))
        {
            camPos.y -= (750 * dt) / camZoom;
        }
        if(input.getScancodeDown(7))
        {
            camPos.x += (750 * dt) / camZoom;
        }
        if(input.getScancodeDown(4))
        {
            camPos.x -= (750 * dt) / camZoom;
        }

        cameraEntity.position = camPos;
    }

    private function selectShip(e:Entity)
    {
        selectedShips.push(e);

        if(selectCursors.length < selectedShips.length)
        {
            selectCursors.push(Factory.createSelectCursor());
        }

        var i = selectedShips.length - 1;
        engine.addEntity(selectCursors[i]);
    }

    private function unselectShip(e:Entity)
    {
        selectedShips.remove(e);
        engine.removeEntity(selectCursors[selectCursors.length - 1]);
    }

    private function unselectAll()
    {
        for(i in 0...selectedShips.length)
        {
            engine.removeEntity(selectCursors[i]);
        }

        selectedShips = new Array<Entity>();
    }

    private function haveSelectedShips(c:Class<Dynamic>)
    {
        for(s in selectedShips)
        {
            if(!s.has(c))
            {
                return false;
            }
        }

        return true;
    }
}
