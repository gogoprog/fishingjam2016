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
    public var life:Float = 100.0;
    public var maxLife:Float = 100.0;
    public var speed = 400.0;

    public var team(get, never):Team;

    public var icon:Entity;
    public var healthBar:Entity;
    public var bgBar:Entity;

    public function new()
    {
    }

    public function get_team():Team
    {
        return Session.teams[teamIndex];
    }
}
