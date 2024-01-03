# arcade-shooter
A simple arcade style space shooter using Godot and GDScript.
For now it is just planned to be a vertical scroller, but I may try to additonal horizontal levels or try out some other ideas.

This is a test project and my first real attempt at game development.  
This project was intended to help me learn Godot and get better at writing scripts.
This project began with the "Dodge The Creeps!" tutorial on the official Godot documentation website.

I have slowly replaced assets, heavily modified the scripts and made some of my own additions.
The base game of the tutorial was based around dodging mobs that randomly spawned around the edges of the screen.
You gained score points for each second you survived and the goal was to get a high score.

My goal is to create a simple space shooter in the vain of Asteroids or even something crazy like Geometry Wars or R-type.
I replaced the main player sprite, which was some squid alien creature, with a space ship I made in LibreSprite, that looks suspiciously like an X-wing.
I added a laser scene and implemented a fire function that rapid fires lasers, and functionality that enables the mobs the queue_free when hit by the laser.
I am going to first implement a score system where you simply try to get a high score by killing as many mobs as possible.
I have additional ideas if I decide to expand on this project further, including full levels where the goal is to complete the level instead of just getting a high score.

