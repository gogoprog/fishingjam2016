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
            /*if(other.has(Ship) && )
            {
                engine.updateComplete.addOnce(function() {
                    engine.removeEntity(other);
                    });
            }*/
        }
    }
}
