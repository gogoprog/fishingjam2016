package components;

import gengine.math.*;
import pathfinder.Coordinate;
import ash.fsm.*;
import gengine.*;

class Ship
{
    public var sm:EntityStateMachine;
    public var controllable:Bool = true;
    public var movingState:EntityState;
    public var targetPosition:Vector3;
    public var teamIndex = 0;

    public var icon:Entity;

    public function new()
    {

    }
}
