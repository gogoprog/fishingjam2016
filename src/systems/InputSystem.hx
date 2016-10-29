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
import ash.core.NodeList;

class InputSystem extends System
{
    private var engine:Engine;
    private var cameraEntity:Entity;
    private var sceneEntity:Entity;
    private var startMousePosition:Vector2;
    private var startCameraPosition:Vector3;
    private var startSelectPosition:Vector3;
    private var zoom = 1.0;
    private var selectedShips = new Array<Entity>();
    private var selectCursors = new Array<Entity>();
    private var selectQuad:Entity;
    private var allShips:NodeList<ShipNode>;

    public function new(cameraEntity_:Entity, sceneEntity_:Entity)
    {
        super();
        cameraEntity = cameraEntity_;
        sceneEntity = sceneEntity_;
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;
        selectQuad = Factory.createSelectCursor();
        engine.addEntity(selectQuad);
        allShips = engine.getNodeList(ShipNode);

        cameraEntity.position = Session.player.home.position;
    }

    override public function update(dt:Float):Void
    {
        var input = Gengine.getInput();
        var mousePosition = input.getMousePosition();

        selectQuad.position = new Vector3(-1000000, 0, 0);

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
                var previousZoom = zoom;

                deltaWheel = Std.int(deltaWheel / Math.abs(deltaWheel));

                zoom += deltaWheel * 0.1;
                zoom = Math.max(zoom, 0.1);
                zoom = Math.min(zoom, 1.7);
                cameraEntity.get(Camera).setZoom(zoom);

                var deltaPos = mouseWorldPosition - cameraEntity.position;

                deltaPos *= previousZoom / zoom;

                cameraEntity.position = mouseWorldPosition - deltaPos;
            }

            if(input.getMouseButtonPress(1))
            {
                startSelectPosition = mouseWorldPosition;
            }
            else if(input.getMouseButtonDown(1))
            {
                var centerPos = (startSelectPosition + mouseWorldPosition) * 0.5;
                var size = mouseWorldPosition - startSelectPosition;

                selectQuad.position = centerPos;
                selectQuad.scale = new Vector3(size.x / 128, size.y / 128, 1);
            }
            else if(startSelectPosition != null)
            {
                var centerPos = (startSelectPosition + mouseWorldPosition) * 0.5;
                var size = mouseWorldPosition - startSelectPosition;
                selectShipsInQuad(centerPos, size);
                startSelectPosition = null;
            }

            var i = selectedShips.length - 1;
            while(i >= 0)
            {
                if(selectedShips[i].get(Ship).life <= 0)
                {
                    unselectShip(selectedShips[i]);
                }
                --i;
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
                            AudioSystem.instance.playSound("move", selectedShip.position);
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

        if(input.getScancodePress(44))
        {
            camPos = Session.player.home.position;
        }

        cameraEntity.position = camPos;
    }

    private function selectShip(e:Entity)
    {
        if(e.get(Ship).life <= 0)
        {
            return;
        }

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
        engine.removeEntity(selectCursors[selectedShips.length]);
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

    private function selectShipsInQuad(center:Vector3, size:Vector3)
    {
        var input = Gengine.getInput();

        size.x = Math.abs(size.x * 0.5);
        size.y = Math.abs(size.y * 0.5);

        var min = center - size;
        var max = center + size;
        var otherSize = new Vector3(64, 64, 0);

        if(!input.getScancodeDown(225))
        {
            unselectAll();
        }

        for(ship in allShips)
        {
            if(!Session.teams[ship.ship.teamIndex].isBot)
            {
                var pos = ship.entity.position;
                var omin = pos - otherSize;
                var omax = pos + otherSize;

                if(!(omax.x < min.x || omin.x > max.x || omax.y < min.y || omin.y > max.y))
                {
                    if(selectedShips.indexOf(ship.entity) != -1)
                    {
                        unselectShip(ship.entity);
                    }
                    else
                    {
                        selectShip(ship.entity);
                    }
                }
            }
        }

        if(selectedShips.length > 0)
        {
            AudioSystem.instance.playSound("click");
        }
    }
}
