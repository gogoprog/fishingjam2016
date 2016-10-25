package systems;

import gengine.*;
import ash.systems.*;
import components.*;

class BotSystem extends System
{
    private var engine:Engine;
    private var time = 0.0;
    private var team:Team;

    public function new()
    {
        super();
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;
        team = Session.teams[1];
    }

    override public function update(dt:Float):Void
    {
        time += dt;

        if(time > 3)
        {
            var t = Task.tasks["buildFighter"];
            var tasks:Array<Task> = team.home.get(Building).tasks;
            tasks.push(t);

            time = 0.0;
        }
    }
}
