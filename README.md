# ardupilot-rover-l298n
How to setup Ardupilot based Rover with L298N motor driver to control with reverse simple DC brushed motors

Components:
A rover with this kind of DC motors:

![image](https://user-images.githubusercontent.com/2444175/170966916-abe3ba37-18f0-479a-9504-baa9a021d870.png)
 
My rover has two of them: for driving and for steering
An Ardupilot hardware (Pixhack 2.8.4 in my case):

![image](https://user-images.githubusercontent.com/2444175/170966979-af1e83ab-a498-4c4c-8723-ddc673e0214c.png)

L298N motor driver board (MRL298 V2 in my case):

![image](https://user-images.githubusercontent.com/2444175/170967002-5c574de1-d9d3-4cf4-9925-072c3d76ed5e.png)

Power module:

![image](https://user-images.githubusercontent.com/2444175/170967025-559b2b0c-4ebc-4339-bfda-592d5c3d9b45.png)


Wiring:
| L298N pin  |  Pixhawk pin/device   |
|------------|-----------------------|
|     IN1    |  AUX3                 |
|     IN2    |  AUX4                 |
|     IN3    |  AUX5                 |
|     IN4    |  AUX6                 |
|     GND    |  any output rail GND  |
|     ENA    |  PWM1                 |
|     ENB    |  PWM2                 |
|   motorA   |  Driving motor        |
|   motorB   |  Steering motor       |
|   Vcc+GND  |  Power module output  |

Ardupilot setup:
Assuming calibration and other things are already completed. RC stick mode is set to 1 (right stick controls steering and throttle, left stick is not used).
|     Key/Value    |     Comments    |
|---|---|
| BRD_PWM_COUNT,2 | Allocate more AUX pins for relays (reduce amount of PWM pins) |
| BRD_SAFETYENABLE,0 | Don’t require safety switch |
| MOT_PWM_TYPE,3 | Set motor’s type to BrushedWithRelay |
| RELAY_PIN,50 | AUX1 (reserved) |
| RELAY_PIN,51 | AUX2 (reserved) |
| RELAY_PIN3,52 | AUX3 |
| RELAY_PIN4,53 | AUX4 |
| RELAY_PIN5,54 | AUX5 |
| RELAY_PIN6,55 | AUX6 |
| SCR_ENABLE,1 | Enable LUA scripting |
| SERVO1_FUNCTION,26 | Steering |
| SERVO1_MAX,1928 |  |
| SERVO1_MIN,1061 |  |
| SERVO1_REVERSED,1 |  |
| SERVO1_TRIM,1494 | Required for reverse |
| SERVO2_FUNCTION,70 | Throttle |
| SERVO2_MAX,1923 |  |
| SERVO2_MIN,1100 |  |
| SERVO2_REVERSED,0 |  |
| SERVO2_TRIM,1100 | Required for reverse |
| SERVO9_FUNCTION,-1 | AUX1 GPIO mode (reserved) |
| SERVO10_FUNCTION,-1 | AUX2 (reserved) |
| SERVO11_FUNCTION,-1 | AUX3 |
| SERVO12_FUNCTION,-1 | AUX4 |
| SERVO13_FUNCTION,-1 | AUX5 |
| SERVO14_FUNCTION,-1 | AUX6 |

BrushedWithRelay motor mode reserves the first relays (AUX1 and AUX2 in our case), so we must use other relay outputs for our purposes. In this case AUX3-AUX6 outputs will be used.

In Mission Planner upload the set_rotation_dir.lua script to the scripts folder and reboot the Pixhawk.
