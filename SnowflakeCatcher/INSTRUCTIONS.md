Snowflake Catcher
================

**[Click here to see the program!](http://noahzpepper.github.io/SnowflakeCatcher)**

In this assignment you will create a class to model a single snowflake. Then you will create an array of many snowflakes. You may find slides 241 - 345 on <a href="https://drive.google.com/open?id=0Bz2ZkT6qWPYTVkF4Q19aZ3dfdk0">apjava1.pptx</a> and the <a href="https://drive.google.com/file/d/0Bz2ZkT6qWPYTZ1FCOTZrWS1pb3M/view?usp=sharing">Arrays of Objects</a> worksheet helpful.

Steps to completing the program (These are just a suggested starting point. Feel free to adjust them anyway you'd like):

1. Sign in to GitHub and fork [this repository](https://github.com/APCSLowell/SnowflakeCatcher)

2. Add the following to the `Snowflake` class. 
  - 2 member integer variables: `x` and `y`
  - 1 member boolean variable: `isMoving`
  - The constructor should initialize the members as follows:
    - `x`: random integer from 0 to 300 (or whatever the width of the screen is) You must use `Math.random()`
    - `y`: random integer from 0 to 300 (or whatever the height of the screen is) You must use `Math.random()`
    - `isMovin`g: `true`
  - `void erase()` which first, sets the fill to black and draws a black ellipse of size 7 at (x,y)
  - `void move()` which checks if the snowflake isMoving. If it is, increase `y` by one
  - `void lookDown()` checks if `y` is between the top and bottom of the screen, and the position just below (x,y) is not black. If so, set `isMoving` to `false`; otherwise set `isMoving` to `true` 
  - `void show()` which draws a white ellipse of size 5 at x,y
  - `void wrap()` which checks if the `y` coordinate is off the bottom of the screen. If it is, set `y` to 0 and generate a new random `x` coordinate
3. Now create an array of Snowflakes. In `draw()` write a loop that goes through the array and for each snowflake does the following:
  - `erase()`
  - `lookDown()`
  - `move()`
  - `wrap()`
  - `show()`
4. In `mouseDragged()` write some code that draws to the screen. 
5. When you are happy with your assignment, push your repository to your GitHub account. Submit the url of your working program to the school loop drop box. 

Extensions
----------
Your "snow" doesn't have to fall down. You could have bubbles that travel upward toward a barrier or some other similar objects. You can keep score based on how many snowflakes have been caught. Have fun and be creative!

Samples of Student Work
-----------------------
[Jimmy](http://furiouspenguins.github.io/SnowflakeCatcher/)  
[Chris](http://chrisma1.github.io/SnowflakeCatcher/)  
[Zachary](https://zachooz.github.io/SnowflakeCatcher/)  
[Teresa](http://teresamibarra.me/SnowflakeCatcher/)  
[Lily](http://magicallilicorn.github.io/SnowflakeCatcher/)  
