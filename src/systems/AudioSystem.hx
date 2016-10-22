package systems;

import gengine.*;
import gengine.components.*;
import ash.systems.*;
import ash.fsm.*;
import components.*;
import gengine.math.*;
import haxe.ds.Vector;

class AudioSystem extends System
{
    static public var instance:AudioSystem;

    private var engine:Engine;
    private var sounds = new Map<String, Dynamic>();
    private var soundSources:Vector<SoundSource>;
    private var nextSoundSourceIndex = 0;

    private function add(name)
    {
        sounds[name] = Gengine.getResourceCache().getSound(name + ".wav", true);
    }

    public function new()
    {
        super();

        add("click");
        add("move");
        add("laser");
        add("impact");

        instance = this;
    }

    override public function addToEngine(_engine:Engine)
    {
        engine = _engine;

        soundSources = new Vector<SoundSource>(8);

        for(i in 0...soundSources.length)
        {
            var e = new Entity();
            soundSources[i] = new SoundSource();
            e.add(soundSources[i]);
            engine.addEntity(e);
        }
    }

    public function playSound(sound:String, ?gain = 1.0)
    {
        var ss = soundSources[nextSoundSourceIndex++];
        ss.setGain(gain);
        ss.play(sounds[sound]);
        nextSoundSourceIndex %= soundSources.length;
    }
}
