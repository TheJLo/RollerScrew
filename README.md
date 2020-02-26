# Planetary Roller Screws

Adjustable Roller Screw designed in SolidPython on top of OpenSCAD. The Roller Screws are intended to be 3D printed as either individual pieces or as one whole unit.

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

## Frameworks
- [SolidPython](https://github.com/SolidCode/SolidPython)

## Libraries Used
- [threads.scad](https://dkprojects.net/openscad-threads/), Threads
- [Getriebe.scad](https://www.thingiverse.com/thing:1604369), Gears

## Installation
The following goes over the installation process for Windows and Mac/Linux
### Prerequisites

Before installing the Planetary Roller Screw, the following programs must be installed:

- [Python3](https://www.python.org/)
- [OpenSCAD](https://www.openscad.org/)

### Windows

Installation for a Windows machine goes as such:
1. Download or Clone this repository into an appropriate place
  * Use `git clone https://github.com/TheJLo/RollerScrew.git` from the Command Prompt
  * Or, click the green "Clone or download" button in the upper right corner of the Github page and click "Download zip"
2. Navigate to the newly created folder
3. Double-click `install.py` to begin Installation. A Command Prompt should appear and begin the installation.
  * If this step does not work, open a Command Prompt in this folder (Shift-Right-Click > Open command window here)
    * Type the following command in the window:

      `python3 install.py`

4. After installation is completed, a `.venv` folder should have appeared in the folder as well as a `config.ini` file and `output` folder

5. This should complete installation for Windows

### Mac/Linux

Installation for a Mac or Linux machine goes as such:
1. Download or Clone this repository into an appropriate place
  * Use `git clone https://github.com/TheJLo/RollerScrew.git` from the Terminal
  * Or, click the green "Clone or download" button in the upper right corner of the Github page and click "Download zip"
2. Navigate to the newly created folder
3. Double-click `install.py` to begin Installation. A Command Prompt should appear and begin the installation.
  * If this step does not work, open a Terminal in this folder
    * Type the following command in the terminal:

      `python3 install.py`

4. After installation is completed, a `config.ini` file and `output` folder should have appeared. A `.venv` folder should have been created as well, however is not visible by default. To verify type the following command in the terminal to list all folders in the current directory:

  `ls -a`

5. This should complete the installation for Mac/Linux

## Basic usage

Running of the program can be done by double-clicking the file `__main__.py` or by running `python3 .` in the program directory. This will create all the selected OpenSCAD file selected in the `output` directory. Output selection will be explained below.

### Output selection

The current method for output selection is temporary and will be changed for the front-end user in the future. For developers, this is how Output selection works behind the scenes.

Output selection is done in the file `rsgl_assembly.py` in the `src` folder (`./src/rsgl_assembly.py`). The variable that controls output is called `render_mode` and has a value of `RENDER_ALL` which enables the output of every OpenSCAD file including test ones. To change this value, one can select from the list of output values above this variable. Each value is in all caps and they can be mixed and matched using a logical-OR: `^` between values.

For Example, let's say we want to output the OpenSCAD scripts for the _Housing_ and the _nut_. To do so we would set `render_mode` like so:

`render_mode = RENDER_HOUSING ^ RENDER_NUT`

Upon running, the program would output `housing.scad` and `nut.scad`.
If we wanted to add the _roller_ to this, we would then rewrite `render_mode` like so:

`render_mode = RENDER_HOUSING ^ RENDER_NUT ^ RENDER_ROLLER`

Now upon running, the program would still output `housing.scad` and `nut.scad`; but would now also output `roller.scad` as well.

### Changing a part

Changing a part is simple and can be done changing the one file associated with that part (in the future, this may be discouraged so as to maintain the original design as needed.) To demonstrate this we are going to make a new _roller_ part which consists of a sphere with a cylinder through the middle of it.

1. To begin, we need to make a backup copy of the original roller file.
  * Navigate to the roller file located in the `src` folder. It is named `rsgl_roller.py`.
  * Copy this file and rename it something appropriate such as `rsgl_roller.py.bk`
2. Open the original `rsgl_roller.py` files
  * The file should look something like this:
```python
    from rsgl_parts import *
    from rsgl_tools import *

    class RSGL_Roller(RSGL_Part):

        def __init__(self, ref_diameter, height, thread_spec, gear_spec):
          ...

        def generate_geometry(self):
          ...
          return g
  ```
3. From this file, we care about a couple of things.
  * First, observe the variables being used in the constructor:
  ```python
  def __init__(self, ref_diameter, height, thread_spec, gear_spec):
        ...
  ```
  We can see the following parameters:
    - `ref_diameter`
    - `height`
    - `thread_spec`
    - `gear_spec`

    These are values which cannot change during run-time and are considered "Specifications" of the design. These values should be used during creation  of the part, but **should not be changed**.

  * Next, lets look at the actual generator:
  ```python
  def generate_geometry(self):
        ...
        return g
  ```
  This function has no parameters (although it could, and will in the future) and returns `g` which is the final geometry made by this function. Parameters to this function are considered "Functional Parameters" of the part and can be changed during run-time. These parameters are used in such cases where the full part cannot be defined without run-time information.

    For example, these parameters can be used to create gears of different sizes without having to worry about whether or not they will properly mesh (as this is done by the Specifications, not the Functional Parameters).

    This function is the primary function we will be using to create our part.

4. Now to change the `generate_geometry` function to create our new part!

  * As a note, although we will not be using any of the given variables for our part, those variables can (and should) be used and will be automatically populated by the programs

  * First we need to create an empty object or primitive to work on. This can be done many ways but the easiest way is with the following:
  ```python
  g = union()
  ```
  This creates an empty object for use to work with and must be done before doing and other work. As an alternative, we could have made a primitive to work on such as our sphere:
  ```python
  g = sphere(r = 10, center = True)
  ```
  which would have made our sphere and passed it back to us as `g`.

  * Next we need to make our sphere and cylinder and `union` them to `g`. This can be easily done using the `+` notation or `+=` notation in familiar fashion to other languages.
  ```python
  g = g + sphere(r = 10, center = True)
  g = g + cylinder(r = 5, center = True)
  ```
  __or__
  ```python
  g += sphere(r = 10, center = True)
  g += cylinder(r = 5, center = True)
  ```

  * That is all the geometry which is needed so now we just need to return `g` at the end of the function!

  * Much more can be done than what has been shown here and every command and feature present in [SolidPython](https://github.com/SolidCode/SolidPython) is accessible to the part. Refer to their documentation to get a sense of what is possible to do with the geometry.

5. And we are done! Now the _roller_ will output a sphere with a cylinder bisecting it down the middle! This can be done with any part and is even encouraged for the _housing_ part so users can create housings tailored to their needs.
