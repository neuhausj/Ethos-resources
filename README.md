# Ethos-resources
Collection of resources for Ethos radios: widgets and F3K template.
So far, this collection contains:

* F3k template for 2 servos wing
* Status widget
* Battery widget

# F3K template for 2 servos wing
## Features:
* Easy to use and setup
* Calibration mode for fine ailerons alignment
* 5 Flight modes + calibration mode: Launch, Zoom, Speed, Cruise, Thermal
* Camber settings adjustable per flight modes
* One flight timer, one session timer (flight time since radio start), one plane timer (persistent flight time)
* Height call 3s after exiting zoom 
* Short beep at start / long beep at end of flight
* Automatic logs each 500ms when in flight
* Reset max altitude reached every launch
* Automatic ELRS arming when launching / disarm by pushing 2s the FS6 button
* Full travel of the ailerons when full brake to improve control 
* Differential is identical accross all FM and independant of other mixes
* Automatic switching between flight widget and summary widget

## Flight logic
1. Press the launch switch when starting your rotation. __LAUNCH mode__ is active and allows to rotate your aircraft. 
2. When the rotation is done, keep the switch active as long as you want your aircraft to pitch up. The release of this button will cause the start of the flight timer, of the logs and a short beep will confirm the launch.
3. The plane enters __ZOOM mode__. When pushing the elevator, the plane will leave this mode and enter the mode configured by the switch SB

Depending on SB, you enter then:

5. SPEED mode when SB is top. This is used to exit a thermal or simply penetrate the air better
6. CRUISE mode when SB is in the middle. This should be used to look for thermal around.
7. THERMAL mode when SB is down. This helps to slow down the plane and center the thermal at best.
> [!NOTE]
> You can set the camber of the selected mode with the throttle trim T3
7. Confirm the end of the flight with the launch switch. This will trigger a long confirmation beeep and stop all logs and flight timer

## Procedure to setup a new model
### Script installation
1. Copy the template in the __model__ folder, the wav files in the correct __audio__ folder and the widgets in the __scripts__ folder
> [!TIP]
> In the home screen, create a second category to avoid mixing the template with your planes
3. Clone the template and rename it with the name of your plane
(opt) Move the plane in the correct folder
4. Setup your radio link; check that all telemetry informations are received. You may need to rediscover the sensors.

> [!WARNING]
> The following Special functions have to be reassigned after rediscovering sensors:
> * SF3 (Play vario)
> * SF4 (Altitude)
> * SF9 (Battery) 
> * SF11 (Altitude max)

### Flight surfaces setup
> [!NOTE]
> To avoid any damage when first setting up your glider, the throws have all been limited to +/-20%

5. Go in **Outputs** and check each channel:
> * For rudder and elevator, set the __Direction__ if needed + __Min__, __Max__ and __Center__ to match the maximum travel allowed by the surfaces
> * For aileron left and right, only set the __Direction__
> * If channels are not in the correct order, use the __Swap channels__ button, at the end of the desired channel
6. To aligh ailerons, enter calibration mode by activating SH and confirming the popup
7. With the trim T5, adjust the left aileron min/max and center (2nd point from the top edge = camber in zoom mode)
8. With the trim T6, adjust first the min/max of the right aileron and then all intermediate points to exactly match the left aileron position.
9. Exit calibration mode by pushing SH back when satisfied with the alignment

### Buttons setup

In __Logical switch__:

10. Setup your launch button in __LS1 ls_launch__: click edit and set __Source (A)__ to the desired switch
11. Setup your desired receiver low battery in __LS2 ls_lowBattery__ if you have telemetry

> [!NOTE]
> Your plane is now ready to fly ! Congratulations !!

## Advanced setup
In __Vars__ you can change:
1. p_Expo: expo for ailerons
2. p_Diff: differential for ailerons
3. p_BrkToElev: brake to elevator mix
4. p_Snapflap: elevator to aileron mix
5. p_Ail_Rate: rates of aileron (default 100% for full travel)
6. p_Elev_Rate: rates of elevator
7. p_Rudder_Rate: rates of rudder

Template default is brakes are retracted when throttle is pulled back.
To reverse this behavior, go to __Mixes__ > __m_brake__ and long press on __Throttle__, then tick "Negative" 

## Summary buttons

![image](https://github.com/user-attachments/assets/bd08ef5d-122c-4406-a583-b68dc323406b)
![image](https://github.com/user-attachments/assets/c27a1571-1b98-45e4-bcae-2ad50b28f5ce)

| Command | Description |
| :- | :- |
| SA top | no audio
| SA middle | only height announcement
| SA bottom | height + vario announcement
| SB top | SPEED flight mode
| SB middle | CRUISE flight mode
| SB bottom | THERMAL flight mode
| SF | launch button (customisable)
| SG bottom | enable calibration after confirmation
| T1 | trim aileron
| T2 | trim elevator
| T3 | trim camber for selected flight mode
| T4 | trim rudder
| T5 | disabled in normal mode; adjust the left aileron in calibration
| T6 | disabled in normal mode; adjust the right aileron in calibration
| FS6 | disarm ELRS after 2seconds
| Back buttons | manual callout altitude (left) and time (right)
SC,SD,SE,SH | FS1-5: unused



## Views
3 views are predefined with the template.
* Flight view: activated after launch
![image](https://github.com/user-attachments/assets/5787ebc0-3989-4c43-83df-0e3b4ae8c95c)

* Flight summary: activated after landing
![image](https://github.com/user-attachments/assets/dfacd18e-872f-42ad-bc36-65da8113128c)

* Radio link stats: to be activated manually
![image](https://github.com/user-attachments/assets/373b67ad-fd3b-4748-8d2f-92f854b907fb)






# [Status widget]
 
Widget that displays the status of a variable when higher/equal/smaller than a specified threshold.
The threshold value, threshold type and colors are customisable.
This could typically used as status or alarm lamp.

![image](https://github.com/user-attachments/assets/fc0b9ae6-b51d-4519-882c-3828750a4c2c)


Settings:

![image](https://github.com/user-attachments/assets/1d320d77-bdc7-4ccd-98d2-cd484a9d39ae)
![image](https://github.com/user-attachments/assets/88de0b1d-2acb-429a-b036-78ae3ce507d4)



# [Battery widget]
 
Widget that displays the battery voltage from a given source.
The value can be displayed as a single cell or as total voltage.
The percentage of battery left is also displayed and the range can be customised.

![image](https://github.com/user-attachments/assets/d9b9fa36-1d48-40e7-a304-f78a7e85206d)


Settings:

![image](https://github.com/user-attachments/assets/5958b519-0624-4d95-9fce-96180ecbbbd9)

