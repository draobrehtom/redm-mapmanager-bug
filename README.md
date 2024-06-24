# Bug in mapmanager (ghost spawns)

При смене карты не удаляются старые спауны. Например, вместо 2-х спаунов может присутствовать 4-ре. 

## Описание и воспроизведение ошибки

Ошибка происходит только у тех игроков, которые подключаются к серверу во время смены карты. Ниже представлен сценарий воспроизводства бага.

```lua
-- server.lua
AddEventHandler('playerJoining', function()
    -- Игрок подключается

    -- Меняем карту
    exports['mapmanager']:roundEnded()
end)
```

Ниже представлены содержимое переменной `spawnPoints` из `spawnmanager/spawnmanager.lua` в момент установки факта ошибки.

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

Обратите внимание, что в данных есть поле `res` которое содержит имя карты (resource name). В данных указаны значения **"redm-map-1"** и **"redm-map-3"**. Это говорит о том, что одновременно содержатся спауны из двух различных ресурсов, а т.к. в логике `mapmanager` может быть запущен только один ресурс типа `map`, то значит логика нарушена.

## Модифицированные файлы

Мне пришлось немного модифицировать `mapmanager`, чтобы добавить информацию о названии карты в спаун: [link](resources\[managers]\mapmanager\mapmanager_shared.lua#52)

Так-же модифицирован `spawnmanager`, чтобы проверять информацию о спаунах и идентифицировать ошибку:
[link](resources\[managers]\spawnmanager\spawnmanager.lua#4)

Сценарий воспроизводства был добавлен в `basicgamemode`:
[link](resources\[gamemodes]\basic-gamemode\basic_server.lua)

А так-же изменён `server.cfg`, чтобы `basic-gamemode` запускался при старте сервере:
[link](server.cfg#28)

Более подробную информацию вы можете получить в коммите 2ba801c9fb45977183cd9c6002392b48bdaf87d6
