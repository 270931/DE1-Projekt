# LED-kový Ping-Pong

This is a project for the BPC-DE1 course at the Faculty of Electrical Engineering and Communication Technologies.

### Na projektu spolupracovali:
- Frank Patrik - Programming and overall program structure
- Hromek Matěj - 
- Križan Damián - 
- Toman Jan -

> [!NOTE]
> Dále to může dodělat někdo jiný (a lépe)

## Struktura programu
The top-level VHDL file is `LED_PingPong_top.vhd`:

![Scheme](img/Schéma.png)

The game instance **game** komponenty *GameLogic*. *GameLogic* is a finite state machine (FSM) with 5 states:
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
