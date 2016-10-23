package components;

import gengine.*;

class Building
{
    public var teamIndex = 0;
    public var radius = 0.0;
    public var life = 100.0;
    public var maxLife = 100.0;

    public var healthBar:Entity;

    public var taskStatus = 0.0;
    public var time = 0.0;
    public var tasks = new Array<Task>();
    public var currentTask:Task;

    public function new()
    {
    }
}
