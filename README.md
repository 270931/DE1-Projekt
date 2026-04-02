# LED-kový Ping-Pong

Toto je projekt do předmětu BPC-DE1 na fakultě elektrotechniky a komunikačních technologií.

### Na projektu spolupracovali:
- Frank Patrik - programování a struktura programu
- Hromek Matěj
- Križan Damián
- Toman Jan

> [!NOTE]
> Dále to může dodělat někdo jiný (a lépe)

## Struktura programu
Toto je struktura souboru `LED_PingPong_top.vhd`:

![Schema](img/Schéma.png)

Struktura instance **game** komponenty *GameLogic*. *GameLogic* je stavový automat s 5 stavy:
```mermaid
  stateDiagram-v2
    [*] --> IDLE
    IDLE --> START : btnl OR btnr pressed
    START --> PLAYING  :  timer
    PLAYING --> END_OF_ROUND  :  player miss
    END_OF_ROUND --> START  : playerX_score < WIN_SCORE
    END_OF_ROUND --> END_OF_GAME : playerX_score = WIN_SCORE
    END_OF_GAME  --> IDLE : rst ='1'

```
