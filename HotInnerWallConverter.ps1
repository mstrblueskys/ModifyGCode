###########################################################
#
#    Klipper Gcode Modification Script
#    written by: mstrblueskys
#    12-7-2024
#     
#    Purpose: Use this script to modify your 3 wall 3D
#    prints to include a hot, overextruded infill wall
#    in an attempt to increase the strength of the print
#    
#    Instructions:
#    0. Adjust variables to to hone print quality
#    1. Run code
#    2. Give the filepath including extention when prompted
#    3. Let run
#    4. Find the output file in the same folder with _Mod
#    5. Print _Mod file
#
###########################################################


# Variables are set here:
$printTemp = "220" # Degrees C
$innerTemp = "240" # Degrees C
$innerExtrude = "102" # Percent
$maxFanSpeed = "172" # Fan speed measurement unit ¯\_(ツ)_/¯
$StartLayer = 4 # Layer where your outter walls enclose inner walls

############ Application starts here: #####################

# Get the file location and build dest location

$inputG = Read-Host -Prompt "What's the path to your .gcode file?"

$inputNoExt = $inputG.Replace(".gcode","")

$outFile = -join($inputNoExt, "_Mod.gcode")

# I need a variable to track and one to recompile the code and a wall counter

$innerWallCode = !$true
$ouptutContent = @()
$curWallLayer = 0

# Pull file contents and itterate on each line

Get-Content "$inputG" | ForEach-Object {

    # it's more clear to me to define the current row variable

    $currentRow = $_

    # Add the current row to the new file

    $ouptutContent += $currentRow
    
    # Check for layer change and increment if so

    If( $currentRow -eq ";LAYER_CHANGE"){
        $curWallLayer ++
    }

    # Only run if we're not on base layers as defined

    If($curWallLayer -ge  $startLayer){

        # Check if we're on an inner wall
        # if inner wall, add code to heat, turn off fan, and extrude more and record you're on an inner wall
        # if not, check to see if we're done wiping after an inner wall and add code to reset values

        If($currentRow -eq ";TYPE:Inner wall") {
            $innerWallCode=$true
            $ouptutContent += "M106 S0 ; set fan speed to zero"
            $ouptutContent += "M109 S$innerTemp ; Set nozzle temp and wait"
            $ouptutContent += "M221 S$innerExtrude ; Increase extrusion to 102%"
        } elseif ($innerWallCode -and $currentRow -eq ";WIPE_END") {
            $innerWallCode=!$true
            $ouptutContent += "M106 S$maxFanSpeed ; set fan speed to zero"
            $ouptutContent += "M109 S$printTemp ; Set nozzle temp and wait"
            $ouptutContent += "M221 S100 ; Increase extrusion to 102%"
        }

    }

}

# Give us a new gcode file and tell us about it

$ouptutContent | Set-Content -Path $outFile

"Your output filepath is $outFile"