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
            AudioSystem.instance.playSound("impact", bullet.position);

            if(other.has(Ship))
            {
                var ship:Ship = other.get(Ship);

                if(ship.life > 0)
                {
                    ship.life -= bullet.get(Bullet).damage;
                    ship.life = Math.max(0, ship.life);
                    var ratio = ship.life / ship.maxLife;
                    ship.healthBar.setScale(new Vector3(ratio, 1, 1));
                    ship.healthBar.get(StaticSprite2D).setColor(new Color(1 - ratio, ratio, 0, 1));

                    if(ship.life == 0)
                    {
                        ship.bgBar.get(StaticSprite2D).setAlpha(0);
                        ship.sm.changeState("dying");
                        AudioSystem.instance.playSound("explosion", bullet.position);
                    }
                }
            }
            else if(other.has(Building))
            {
                var building:Building = other.get(Building);

                if(building.life > 0)
                {
                    building.life -= bullet.get(Bullet).damage;
                    building.life = Math.max(0, building.life);
                    var ratio = building.life / building.maxLife;
                    building.healthBar.setScale(new Vector3(ratio, 1, 1));
                    building.healthBar.get(StaticSprite2D).setColor(new Color(1 - ratio, ratio, 0, 1));

                    if(building.life == 0)
                    {
                        //building.sm.changeState("dying");
                        AudioSystem.instance.playSound("explosion", bullet.position);

                        var e = Factory.createExplosion();
                        e.position = other.position;
                        engine.addEntity(e);

                        if(building.team.isBot)
                        {
                            HudSystem.instance.showResult("MISSION ACCOMPLISHED");
                        }
                        else
                        {
                            HudSystem.instance.showResult("MISSION FAILED");
                        }
                    }
                }
            }
        }
    }
}
