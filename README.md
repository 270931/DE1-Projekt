# LED Ping-Pong

This project is part of the BPC-DE1 course at the Faculty of Electrical Engineering and Communication Technologies. It implements a simple LED Ping-Pong game on an FPGA board. Players control left and right paddles using buttons, and the game keeps track of scores. The goal is to reach the defined winning score first.

### Team:
- Frank Patrik - Programming & Overall program structure
- Hromek Matěj - Timing module & Higher difficulty settings 
- Križan Damián - Implementation & Documentation
- Toman Jan - Score display on 7-segment 

## Inputs and outputs of the program
### Inputs:
- `btnl`: button for the left player to strike the ball,
- `btnr`: button for the right player to strike the ball,
- `btnc`: button for reseting the game/program.
### Outputs:
- `7-segment display`: segmented display to show the score of player and to start or announce the winner,
- `led1-16`: leds making up the playing field,
- `led16_b`: this led will flash if the player in the direction of the ball movement, misses.

## Program structure
The top-level VHDL file is `LED_PingPong_top.vhd`:

![Scheme](img/Schéma.png)

The game instance uses the GameLogic component. GameLogic is a finite state machine (FSM) with 5 states:
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
### States:
- IDLE – Waiting for the game to start
- START – Initialize round, wait for timer
- PLAYING – Active gameplay
- END_OF_ROUND – Round ends, check if someone missed
- END_OF_GAME – Player reached winning score, wait for reset

## Resource Utilization
👉 [View Resource utilization](img/Tab_of_use.png)

The following table shows FPGA resource usage after synthesis (Nexys A7-50T):

| Resource | Utilization | Available | Utilization %|
|----------|-------------|-----------|--------------|
| LUT      | 208         | 32600     | 0.64         |
| FF       | 240         | 65200     | 0.37         |
| IO       | 37          | 210       | 17.62        |
| BUFG     | 1           | 32        | 3.13         |


## Simulations                             
Detailed simulations and waveform results for all components are documented here:

👉 [View Simulations](Simulations.md)

## Weekly status report:
- WEEK 1: role assignment, basic program structure and top level design
- WEEK 2: simulations and their description, states IDLE and START, PLAYING in progress, testing higher difficulty options
- WEEK 3: decided not to implement harder difficulties, hardware tested positively
- WEEK 4: 

## License
This project is licensed under the [MIT License](LICENSE).
