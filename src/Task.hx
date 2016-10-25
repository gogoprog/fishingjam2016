
enum TaskType
{
    BuildFisher;
    BuildFighter;
}

class Task
{
    static public var tasks = new Map<String, Task>();
    public var cost:Int;
    public var duration:Float;
    public var type:TaskType;
    public var name:String;

    public function new(taskType:TaskType)
    {
        type = taskType;
    }
}
