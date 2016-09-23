package nodes;

import gengine.components.*;
import gengine.*;
import components.*;

class ShipMoveNode extends Node<ShipMoveNode>
{
    public var ship:Ship;
    public var move:ShipMove;
    public var body:RigidBody2D;
}
