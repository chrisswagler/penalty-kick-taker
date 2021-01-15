# penalty-kick-taker

The purpose of this project was to design a soccer/football penalty kick game in which the user utilizes GUI components to aim and take penalty kicks on a goal. Through the process of designing and building the game, features have been added and modified accordingly.

# Version 1
Features:
<ul>
  <li>Goal displayed on UIAxes with sliders used to control positional marker for aiming</li>
  <li>Goalie dive as rectangle randomly generated within the goal boundaries</li>
  <li>Goalie hitbox size adjusted based on selected difficulty</li>
  <li>Sound effects for goal or save</li>
  <li>Total goal and goal streak counters accompanied with a reset button</li>
</ul>

Positives: This was the first working version that captured the vision for the game. Having totally random generation for the goalie hitbox made aiming in the corners of the goal not totally foolproof. Visually, the game matched expectations with the goal frame and aiming features.

Negatives: Due to limited working knowledge of Matlab and Matlab App Designer at the time (Spring 2020), the code was messy. Explicit global variables were used rather than properties, and much of the code could have been cleaned up into separate functions. The largest issue with this version, however, was inefficiency. At the time, the best solution for creating a real-time moving marker on the axes was to continuously plot new markers. It was seemingly unattainable to delete or hide markers once they were plotted, so the next solution pursued was to replot the background image. This resulted in an incredibly slow and inefficient technique for moving the marker since it required replotting of the entire background every single move. The game's lag was very noticeable and on the forefront for issues to resolve in the next version.
