import gengine.math.*;
import gengine.Engine;
import components.*;
import haxe.ds.Vector;
import systems.AudioSystem;
import Task;

class Session
{
    static public var level:Level;
    static private var engine:Engine;
    static public var teams = new Vector<Team>(2);
    static public var player:Team;

    static public function init(_engine:Engine)
    {
        engine = _engine;

        teams[0] = new Team();
        teams[1] = new Team();
        teams[0].isBot = false;
        teams[1].isBot = true;
        player = teams[0];

        var t;
        var taskMap = Task.tasks;

        t = new Task(TaskType.BuildFisher);
        t.duration = 2;
        t.cost = 20;
        taskMap["buildFisher"] = t;

        t = new Task(TaskType.BuildFighter);
        t.duration = 2;
        t.cost = 20;
        taskMap["buildFighter"] = t;
    }

    static public function start()
    {
        MapGenerator.generate();

        /*for(p in 0...2)
        {
            for(i in 0...5)
            {
                var e = Factory.createFighter(p);
                e.position = level.getRandomWaterPosition();
                e.setRotation2D(Std.random(360));
                engine.addEntity(e);
            }

            for(i in 0...5)
            {
                var e = Factory.createFisher(p);
                e.position = level.getRandomWaterPosition();
                e.setRotation2D(Std.random(360));
                engine.addEntity(e);
            }
        }*/

        teams[0].home = Factory.createBuilding(0);
        teams[0].home.position = level.getRandomWaterPositionWith(5, Config.mapSize - 5, 3, 10);
        teams[0].home.setRotation2D(Std.random(360));
        engine.addEntity(teams[0].home);

        teams[1].home = Factory.createBuilding(1);
        teams[1].home.position = level.getRandomWaterPositionWith(5, Config.mapSize - 5, Config.mapSize - 10, Config.mapSize - 3);
        teams[1].home.setRotation2D(Std.random(360));
        engine.addEntity(teams[1].home);

        for(i in 0...10)
        {
            var e = Factory.createFishes();
            e.position = level.getRandomWaterPosition();
            engine.addEntity(e);
        }

        teams[0].fishes = 100;
        teams[1].fishes = 100;

        AudioSystem.instance.playGameMusic();
    }
}
