#wallball
## A simple gesture-based game using processing.js

Wallball is a relatively simple gesture-based physics game. The app lets the user draw lines that turn into actual "physical" walls, and balls falling from above will collide with them.

There are balls of three different colors (red, green and blue), and the aim is to make one ball of each color collide with each wall, or with as many walls as possible. Every time a wall is hit by a ball, it will get the ball's color added (so for example if the wall was already blue and is touched by a red ball, it will become purple), and once a ball of each color has hitten the wall (i.e, it becomes white), it will disappear and the user will get 1000 points. Every time that two balls collide with each other, the user will also get some extra points (but not so many) depending on how hard they collided.

The game ends when a ball gets out of the screen by the top. There is no problem with balls getting out by the bottom or the sides.

Currently it has the form of a browser-based app that can be visited at http://jperals.github.io/wallball/
