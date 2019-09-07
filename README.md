A simple state machine
======================

This project is a learning experience about how to implement a simple state machine.
I don't assume that this code is helpful to anyone else, but if you really want to
use it, just go ahead and fork it.

## Getting Started

Welcome to this prototype! I prepared some easy instructions that hopefully are
helpful to you to get started.

### Prerequisites

I tested this prototype with the 64bit edition of [Godot Engine 3.1](https://godotengine.org/) 
on Ubuntu 18.04.

### Installing

After downloading Godot, you don't need to install anything.
Just clone the repository and open the project in Godot.

## Deployment

To run the code, you just need to press the play button inside the Godot Engine.

If you really like to export the prototype, feel free to use any of the default deployment
tools of the Godot Engine. The following example shows how to deploy on Ubuntu Linux.

### Deploy on Ubuntu Linux

Load the project in Godot Editor. In the menu, select `Project`->`Export ...` to open the export manager.

In the window that opens, you have to add Export Templates, if you haven't done this yet. Go to `Add ...` and select `Linux/X11`.
Then press `Export project ...` and select a file location to save the executable. Godot Engine will put the executable file and 
a resource file in the selected folder. Remember to allways share both files if you distribute it! Both files need to be placed
in the same folder.

## Built With

* [Godot](https://godotengine.org/) - Free and open source 2D and 3D game engine

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. 
For the versions available, see the [tags on this repository](https://github.com/JustForFunGames/GodotStateMachinePrototype/tags). 

## Authors

* **Micha Grandel** - *Initial work* - [michagrandel](https://github.com/michagrandel)

See also the list of [contributors](https://github.com/JustForFunGames/GodotStateMachinePrototype/contributors) who participated in this project.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE.md](LICENSE.md) file for details

## Acknolegdements

- Nystrom, Robert: "Game Programming Patterns", 2014, ISBN 978-0-9905829-0-8, p.87-104, URL: [Game Programming Patterns](http://gameprogrammingpatterns.com/state.html)
- [How to make a player state machine in Godot 3.1](https://youtu.be/j_pM3CiQwts), 10/5/2019 by Game Endeavor
- [How to make a simple state machine in Godot 3.1](https://youtu.be/BNU8xNRk_oU), 3/5/2019 by Game Endeavor

