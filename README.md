# ModifyGCode
Work to create a script that modifies GCode on 3 walled prints to heat up the middle wall to increase strength

This is a work in progress on a proof of concept alternative to using brick layers.

This script will take a gcode file ouptut from your slicer and modify it so the inner walls starting at a given layer will print hot and over extrude in order to increase the surface area and adheasion. When printing an inner wall line, it will turn off the cooling fan, heat up to a user defined temp, and extrude a percent more as you define

There are a few prereqs

1. Only been tested with Orca slicer
2. You must check the option for "Verbose G-code"
3. You must use the wall printing order "Outer/Inner"
4. Please use a wall count of 3 for now

At the start of the code, you can set the variables to define where the script starts, the high temp, the print temp, and the over extrusion percent, as well as the max fan speed. Make sure you pay attention to those variables as they may be different for your filament. This should allow you to tune the code.

Good luck and post issues as noticed! Thanks for checking this out.
