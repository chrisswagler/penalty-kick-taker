# penalty-kick-taker

The purpose of this project was to design a soccer/football penalty kick game in which the user utilizes GUI components to aim and take penalty kicks on a goal. Through the process of designing and building the game, features have been added and modified accordingly.

# Version 1
Features:
<ul>
  <li>Goal displayed on UIAxes with sliders used to control positional marker for aiming</li>
  <li>Goalie dive as rectanglular patch randomly generated within the goal boundaries</li>
  <li>Goalie hitbox size adjusted based on selected difficulty</li>
  <li>Sound effects for goal or save</li>
  <li>Total goal and goal streak counters accompanied with a reset button</li>
</ul>

Positives: This was the first working version that captured the vision for the game. Having totally random generation for the goalie hitbox made aiming in the corners of the goal not totally foolproof. Visually, the game matched expectations with the goal frame and aiming features.

Issues: Due to limited working knowledge of Matlab and Matlab App Designer at the time (Spring 2020), the code was messy. Explicit global variables were used rather than properties, and much of the code could have been cleaned up into separate functions. The largest issue with this version, however, was inefficiency. At the time, the best solution for creating a real-time moving marker on the axes was to continuously plot new markers. It was seemingly unattainable to delete or hide markers once they were plotted, so the next solution pursued was to replot the background image. This resulted in an incredibly slow and inefficient technique for moving the marker since it required replotting of the entire background every single move. The game's lag was very noticeable and on the forefront for issues to resolve in the next version.

# Version 2
Features:
<ul>
  <li>Overall game functionality with aiming and goalie save generation remained the same</li>
  <li>Redesign of the plotting system for positional marker and goalie</li>
  <li>Mute button added</li>
</ul>

Positives: The largest issue with Version 1 was resolved using animatedlines rather than traditional plotting. This allowed for any new points to be added and for previous points to be cleared, thus eliminating the need to replot everything in layers. This required changing the goalie patch mechanics to instead be square markers. Functions and properties were added to organize the code better and make it more readable. 

Issues: The change from plotting a patch to using square markers for the goalie hitbox brought some issues when debugging. Documentation and forums online weren't able to provide a clear description of how the MarkerSize of the square corresponded to the square's actual dimensions. This caused some trouble when attempting to find the exact boundaries of the square since the height/width weren't consistent. The left and right sides of the hitbox are sensitive, but the top and bottom have some space that doesn't register when the positional marker intersects. 

# Ideas for future iterations
<ul>
  <li>Images for ball and goalie/gloves rather than just a circle and square by hiding visibility of an image when not in use</li>
  <li>Basic animation for ball moving when kicked or goalie moving when diving</li>
  <li>Completely change the difficulty modes to be based on a prediction-based attempt or probability range change rather than just the size of the hitbox</li>
  <li>Add an element of chance for making a shot better or worse like a power meter</li>
  <li>Possibilty of missing the goal or hitting the woodwork</li>
</ul>
