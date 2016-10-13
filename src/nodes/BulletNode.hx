package nodes;

import gengine.components.*;
import gengine.*;
import components.*;

class BulletNode extends Node<BulletNode>
{
    public var bullet:Bullet;
    public var sprite:StaticSprite2D;
    public var body:RigidBody2D;
}
