'======================================================================='

' Title: LCD Display LDR Controller
' Last Updated :  01.2022
' Author : A.Hossein.Khalilian
' Program code  : BASCOM-AVR 2.0.8.5
' Hardware req. : Atmega32 + LDR + 16x2 Character lcd display

'======================================================================='

$regfile = "m16def.dat"
$crystal = 1000000

Config Lcdpin = Pin , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.2 , Rs = Portb.0
Config Lcd = 16 * 2
Cursor Off
Cls

Enable Interrupts
Config Adc = Single , Prescaler = Auto , Reference = Avcc
Start Adc

Config Portc.1 = Output
Reset Portc.1
Relay Alias Portc.1

Dim Ldr As Word
Dim Setpoint As Word
Dim Setpoint_max As Word
Dim Setpoint_min As Word

'-----------------------------------------------------------

Do
   Gosub Red_temp
   Gosub Show_temp
   Gosub Termostat
   Waitms 300
Loop

End

'-----------------------------------------------------------

Red_temp:
   Ldr = Getadc(7) : Ldr = Ldr * 4.8828125
   Setpoint = Getadc(6) : Setpoint = Setpoint * 4.8828125
Return

''''''''''''''''''''''''''''''

Show_temp:
   Locate 1 , 1 : Lcd "LDR:" ; Ldr ; " mV"
   Locate 2 , 1 : Lcd "Setpoint:" ; Setpoint ; " mV"
Return

''''''''''''''''''''''''''''''

Termostat:
   Setpoint_max = Setpoint
   Setpoint_min = Setpoint - 10
   If Ldr > Setpoint_max Then
      Reset Relay
   Elseif Ldr <= Setpoint_min Then
      Set Relay
   End If
Return

'-----------------------------------------------------------