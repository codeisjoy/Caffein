# Caffein
A simple iOS application using Foursquare API to find cafés near you<br/>
This application is written in Swift 2.2 and is an universal application which means can be run in both iPhone and iPad devices with any size classes.

## Running the code
For running the code you need to have Xcode 7.3 or higher on your local machine. As there is no dependency to any 3rd party libs the only thing is needed to be done for running the code is cloning the repository and opening `Caffeine.xcodeproj` file with Xcode.<br/>
For running the application in simulator select either iPhone or iPad simulator and run the application. You can change the user location in simulator by changing the `Simulator Location` in Xcode when the application is running.<br/>
Be noted that the default location has been set Sydney. If you want to run the app in a real device you should turn `Allow Location Simulation` off in project scheme to use the device GPS to determin user location.

## Logic
- This application has just one entity which is `Venue`.
- The final goal is getting a collection of `Venue`s which is provided by API and show them in a table view.
- We need the user location to get the venues list based on.<br/><br/>
In this application the user location is coming from a map view which is using `Core Location` internaly to get the current location of user. By pressing the button down there a request containing current user coordinate and other parameters API needs will be sent off and in response the service controller after parsing given data delivers a collection of venues to be shown.<br/>
Also, there is a simple test that shows network service works properly with no error.
