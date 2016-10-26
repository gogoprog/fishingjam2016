package components;

import gengine.math.*;
import gengine.Entity;
import pathfinder.Coordinate;
import ash.fsm.*;

class Fighter
{
    public var time = 0.0;
    public var target:Entity;
    public var damage = 10;
    public var shootInterval = 1.0;
    public var range = 312.0;
    public var shootSound = "laser";

    public function new()
    {
    }
}
