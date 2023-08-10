# CameraTok

## Instructions
1. Clone or download the repository
2. Open the file /CameraTokApp/CameraTokApp.xcworkspace
3. Select CameraTokApp scheme and run on simulator or device
4. To execute the tests select the CameraTok scheme and run it on any iOS target
5. Make sure to allow photos access

## Thinking process
- I aimed to adhere to SOLID principles and maintain a clean architecture throughout the project;
- I organized the codebase into different modules to achieve isolation, making components more testable and readable;
- The UI should not depend on any external modules, and to achieve this I've created a presentation layer (ViewModels) to depend on the abstractions of the domain layer;
- I started with the domain and I wrote some unit tests to cover this part of the code;
- After this I created the infrastructure using the Photos (PhotoKit) framework;
- In this part, the idea was to isolate the PhotoKit framework from the rest of the code;
- Then I created the App project, the idea was to have only code related to UI in this project, and also the composition of the domain dependencies;
- Creating a separate project for the app's UI helps to maintain a clear separation between the UI and other layers of the application;
- The UI was made with SwiftUI framework, but I have to use UIKit to build the VideoPlayer;
- The VideoPlayer on SwiftUI doesn't have almost any customization support, that's why I had to use UIKit;
- The main dificulties of this project was to build the FeedView, it's a lazy vertical list and each cell has a player that fits the entire screen;
- Despite progress, there are still ongoing issues with video sounds;
- The project is well divided into folders to maintain a clean and organized codebase.

---

## App Architecture

![](architecture.png)
