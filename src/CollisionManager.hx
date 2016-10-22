import gengine.*;
import gengine.math.*;
import gengine.components.*;
import gengine.graphics.*;

import ash.fsm.*;

import systems.*;
import components.*;

class CollisionManager
{
    public static var engine:Engine;

    public inline static function onPhysicsBeginContact2D(entityA:Entity, entityB:Entity)
    {
        if(entityA != null && entityA.has(Bullet))
        {
            onBulletHit(entityA, entityB);
        }

        if(entityB != null && entityB.has(Bullet))
        {
            onBulletHit(entityB, entityA);
        }
    }

    public inline static function onBulletHit(bullet:Entity, other:Entity)
    {
        engine.updateComplete.addOnce(function() {
            engine.removeEntity(bullet);
        });

        if(other != null)
        {
            if(other.has(Ship))
            {
                var ship = other.get(Ship);
                ship.life -= bullet.get(Bullet).damage;
                var ratio = ship.life / ship.maxLife;
                ship.healthBar.scale = new Vector3(ratio, 1, 1);
                ship.healthBar.get(StaticSprite2D).setColor(new Color(1 - ratio, ratio, 0, 1));
            }
        }
    }
}
