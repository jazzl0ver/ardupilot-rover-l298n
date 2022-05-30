local K_THROTTLE = 3
local K_STEERING = 1
local RELAY_IN1 = 2
local RELAY_IN2 = 3
local RELAY_IN3 = 4
local RELAY_IN4 = 5
local RELAY_IN1_STATE = 0
local RELAY_IN2_STATE = 0
local RELAY_IN3_STATE = 0
local RELAY_IN4_STATE = 0
local SERVO1_REVERSED = Parameter()
local SERVO2_REVERSED = Parameter()

SERVO1_REVERSED:init('SERVO1_REVERSED')
SERVO2_REVERSED:init('SERVO2_REVERSED')

function update()
  if arming:is_armed() == false then
    return update, 50
  end
  
  local current_throttle = rc:get_pwm(K_THROTTLE)

  if current_throttle >= 1530 and current_throttle <= 1540 then
    if RELAY_IN3_STATE ~= 0 or RELAY_IN4_STATE ~= 0 then
	  relay:off(RELAY_IN3)
      relay:off(RELAY_IN4)
      RELAY_IN3_STATE = 0
      RELAY_IN4_STATE = 0
	  gcs:send_text(3, "Throttle: " .. current_throttle .. ", RELAY_IN3: " .. RELAY_IN3_STATE .. ", RELAY_IN4: " .. RELAY_IN4_STATE)
    end
  elseif current_throttle < 1530 then
    if RELAY_IN3_STATE == 0 then
	  relay:on(RELAY_IN4)
      relay:off(RELAY_IN3)
      RELAY_IN4_STATE = 1
	  RELAY_IN3_STATE = 0
  	  SERVO2_REVERSED:set(0)
	  gcs:send_text(3, "Throttle: " .. current_throttle .. ", RELAY_IN3: " .. RELAY_IN3_STATE .. ", RELAY_IN4: " .. RELAY_IN4_STATE)
	end
  else
    if RELAY_IN4_STATE == 0 then
	  relay:on(RELAY_IN3)
      relay:off(RELAY_IN4)
      RELAY_IN4_STATE = 0
	  RELAY_IN3_STATE = 1
  	  SERVO2_REVERSED:set(1)
	  gcs:send_text(3, "Throttle: " .. current_throttle .. ", RELAY_IN3: " .. RELAY_IN3_STATE .. ", RELAY_IN4: " .. RELAY_IN4_STATE)
    end
  end

  local current_steering = rc:get_pwm(K_STEERING)
  if current_steering >= 1490 and current_steering <= 1500 then
    if RELAY_IN1_STATE ~= 0 or RELAY_IN2_STATE ~= 0  then
	  relay:off(RELAY_IN1)
	  relay:off(RELAY_IN2)
      RELAY_IN1_STATE = 0
      RELAY_IN2_STATE = 0
	  gcs:send_text(3, "Steering: " .. current_steering .. ", RELAY_IN1: " .. RELAY_IN1_STATE .. ", RELAY_IN2: " .. RELAY_IN2_STATE)
	end
  elseif current_steering < 1490 then
    if RELAY_IN1_STATE == 0 then
	  relay:on(RELAY_IN1)
      relay:off(RELAY_IN2)
      RELAY_IN1_STATE = 1
      RELAY_IN2_STATE = 0
	  SERVO1_REVERSED:set(1)
	  gcs:send_text(3, "Steering: " .. current_steering .. ", RELAY_IN1: " .. RELAY_IN1_STATE .. ", RELAY_IN2: " .. RELAY_IN2_STATE)
	end
  else
    if RELAY_IN2_STATE == 0 then
	  relay:on(RELAY_IN2)
	  relay:off(RELAY_IN1)
      RELAY_IN1_STATE = 0
      RELAY_IN2_STATE = 1
	  SERVO1_REVERSED:set(0)
	  gcs:send_text(3, "Steering: " .. current_steering .. ", RELAY_IN1: " .. RELAY_IN1_STATE .. ", RELAY_IN2: " .. RELAY_IN2_STATE)
	end
  end

  return update, 50
end

return update()
