
enum TaskType
{
    Build(what:Class<Dynamic>);
}

class Task
{
    public var cost:Float;
    public var duration:Float;
    public var type:TaskType;

    public function new(taskType:TaskType)
    {
        type = taskType;
    }
}
