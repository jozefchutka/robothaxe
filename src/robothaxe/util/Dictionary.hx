package robothaxe.util;

class Dictionary<K, V>
{
	var keys:Array<K>;
	var values:Array<V>;

	public function new()
	{
		keys = [];
		values = [];
	}

	public function add(key:K, value:V):V
	{
		for (i in 0...keys.length)
		{
			if (keys[i] == key)
			{
				keys[i] = key;
				values[i] = value;

				return value;
			}
		}

		keys.push(key);
		values.push(value);

		return value;
	}

	public function get(key:K)
	{
		for (i in 0...keys.length)
		{
			if (keys[i] == key)
			{
				return values[i];
			}
		}

		return null;
	}

	public function remove(key:K)
	{
		for (i in 0...keys.length)
		{
			if (keys[i] == key)
			{
				keys.splice(i, 1);
				values.splice(i, 1);

				return;
			}
		}
	}

	public function empty()
	{
		keys = [];
		values = [];
	}

	public function iterator()
    {
        return keys.iterator();
    }
}