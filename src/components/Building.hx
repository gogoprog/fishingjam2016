package components;

import gengine.*;

class Building
{
    public var teamIndex = 0;
    public var team(get, never):Team;
    public var radius = 0.0;
    public var life = 1000.0;
    public var maxLife = 1000.0;

    public var healthBar:Entity;

    public var taskStatus = 0.0;
    public var time = 0.0;
    public var tasks = new Array<Task>();
    public var currentTask:Task;

    public function new()
    {
    }

    public function get_team():Team
    {
        return Session.teams[teamIndex];
    }
}
