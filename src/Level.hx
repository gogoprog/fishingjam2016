

class Level
{
    public var data:Vector<Int>;
    public var size:Int;

    public function init(size_:Int)
    {
        data = new Vector<Int>(size);
        size = size_;
    }


    public function setDataValue(x, y, value)
    {
        if(x < 0 || x >= size || y < 0 || y >= size)
        {
            return;
        }

        data[y * size + x] = value;
    }
}
