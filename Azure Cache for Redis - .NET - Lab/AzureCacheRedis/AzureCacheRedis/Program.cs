using StackExchange.Redis;

string connectionString = "appcache1000.redis.cache.windows.net:6380,password=FGy8SbBmvXE4jRy0LwMzVAbSrSDKSSA6bAzCaDBRUFo=,ssl=True,abortConnect=False";

ConnectionMultiplexer redis = ConnectionMultiplexer.Connect(connectionString);

//SetCacheData();
GetCacheData();

void SetCacheData()
{
    IDatabase database=redis.GetDatabase();

    database.StringSet("top:3:courses", "AZ-104,AZ-305,AZ-204");

    Console.WriteLine("Cache data set");
}

void GetCacheData()
{
    IDatabase database = redis.GetDatabase();
    if (database.KeyExists("top:3:courses"))
        Console.WriteLine(database.StringGet("top:3:courses"));
    else
        Console.WriteLine("key does not exist");

}