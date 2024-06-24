# Bug in Mapmanager (Ghost Spawns)

When switching maps, old spawns are not removed. For example, instead of 2 spawns, there may be 4.

## Description and Reproduction of the Bug

This bug occurs only for players who connect to the server during the map change. Below is the scenario for reproducing the bug.

```lua
-- server.lua
AddEventHandler('playerJoining', function()
    -- Player connects

    -- Change the map
    exports['mapmanager']:roundEnded()
end)
```

Below is the content of the spawnPoints variable from spawnmanager/spawnmanager.lua at the moment the bug occurs.

```json
[
    {
        "heading": 0,
        "res": "redm-map-3", // previous map
        "z": 118.0871,
        "y": 793.4041,
        "x": 333.84909999999999,
        "model": 11966224,
        "idx": 1
    },
    {
        "heading": 0,
        "res": "redm-map-3", // previous map
        "z": 118.0871,
        "y": 793.4041,
        "x": 333.84909999999999,
        "model": 225514697,
        "idx": 2
    },
    {
        "heading": 0,
        "res": "redm-map-1", // current map
        "z": 118.0871,
        "y": 793.4041,
        "x": 111.8491,
        "model": 11966224,
        "idx": 3
    },
    {
        "heading": 0,
        "res": "redm-map-1", // current map
        "z": 118.0871,
        "y": 793.4041,
        "x": 111.8491,
        "model": 225514697,
        "idx": 4
    }
]
```

Note that the data includes a `res` field that contains the resource name of the map. The data shows values **"redm-map-1"** and **"redm-map-3"**. This indicates that spawns from two different resources are present simultaneously. Since the `mapmanager` logic can only run one resource of type `map` at a time, this means the logic is broken.

## Modified Files

I had to slightly modify `mapmanager` to add information about the map name in the spawn: [link](resources\[managers]\mapmanager\mapmanager_shared.lua#52)

I also modified `spawnmanager` to check spawn information and identify the bug: [link](resources\[managers]\spawnmanager\spawnmanager.lua#4)

The reproduction scenario was added to `basicgamemode`: [link](resources\[gamemodes]\basic-gamemode\basic_server.lua)

Additionally, I changed `server.cfg` to ensure `basic-gamemode` starts when the server starts: [link](server.cfg#28)

You can get more detailed information in commit 2ba801c9fb45977183cd9c6002392b48bdaf87d6

