import systems.HudSystem;

import gengine.*;

class Team
{
    public var isBot:Bool;
    public var fishes(get, set):Int;
    private var _fishes = 100;

    public var home:Entity;

    public function new()
    {

    }

    public function set_fishes(amount:Int):Int
    {
        _fishes = amount;

        if(!isBot)
        {
            if(HudSystem.instance.fishesSpan != null)
            {
                HudSystem.instance.fishesSpan.html("" + amount);
            }
        }

        return amount;
    }

    public function get_fishes():Int
    {
        return _fishes;
    }
}
