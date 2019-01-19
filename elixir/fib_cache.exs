defmodule Cache do
  def init() do
    Agent.start_link(fn -> %{ 0 => 0, 1 => 1 } end)
  end

  def contains(agent, key) do
    Agent.get(agent, fn state -> IO.inspect(state);Map.has_key?(state, key) end)
  end

  def get(agent, key) do
    Agent.get(agent, fn state -> Map.get(state, key) end)
  end

  def insert(agent, key, value) do
    Agent.update(agent, fn state -> Map.put(state, key, value) end)
  end

  def print(agent) do
    Agent.get(agent, fn (cache) -> IO.inspect cache; cache end)
  end
end


defmodule Fib do
  def init() do
    { :ok, cache } = Cache.init()
    cache
  end

  def print(cache) do
    Cache.print(cache)
  end

  def calc(cache, n) do
    case Cache.contains(cache, n) do
      false ->
        result = calc(cache, n-1) + calc(cache, n-2)
        Cache.insert(cache, n, result)
        result
      true ->
        Cache.get(cache, n)
    end
  end
end
