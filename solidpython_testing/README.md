This is a testing branch for SolidPython as an alternative to OpenSCAD.

SolidPython is a wrapper over OpenSCAD which generates standalone OpenSCAD code using Python.
The hopes is to create an easier to use, more adjustable, and more robust framework to develop the Roller Screw.
Other OpenSCAD files can be used so existing libraries can still be utilized.

Intended Advantages:
	- More Robust framework
	- Flexibility in usage
	- Clearer usage
	- Quick adjustments of design
	- Off-load some of the more complex calculations to python
	- Thread standard swaps
	- Overall easier development and end-usage


Install:

Requires Python3

 -  Setting up Virtual Enviroment (Linux 01/16/2020)
    - Open a terminal to install location
    - Type in the following
        
        Python3 -m venv .venv
    
    - This will create an invisible directory '.venv' in your current directory
    - Use 'ls -a' to verify
    - Switch into the virtual enviroment with the following command
        
        source .venv/bin/activate
        
    - The text '(.venv)' should appear before your bash prompt
    - Install the required packages using the following command
        
        pip install -r requirements.txt
        
    - This will install all the needed modules into the virtual enviroment
    - Use the 'deactivate' command to leave the virtual enviroment
    
 - Running the python scripts
    - Running the python scripts needs to be done within the virtual enviroment
    - Go to the project directory
    - Type the follwing command
        
        source .venv/bin/activate
        
    - The text '(.venv)' should appear before your bash prompt
    - All python files can now be properly run from the terminal
