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
            engine.updateComplete.addOnce(function() {
                engine.removeEntity(entityA);
                });

            onBulletHit(entityB);
        }

        if(entityB != null && entityB.has(Bullet))
        {
            engine.updateComplete.addOnce(function() {
                engine.removeEntity(entityB);
                });

            onBulletHit(entityA);
        }
    }

    public inline static function onBulletHit(other:Entity)
    {
        if(other != null)
        {
            if(other.has(Bullet))
            {
                engine.updateComplete.addOnce(function() {
                    engine.removeEntity(other);
                    });
            }
        }
    }
}
