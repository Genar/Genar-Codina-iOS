# MusicNet

## iOS app that asks music information using Spotify API.
It consists of a log in screen, a search screen to find a specific artist and giving the results in a list and, finally, a detail collection showing the different albums related to a specific artist.

### EamCoreServices
Contains common code which could be exported to a library like a XCFramework or SPM (generic webservices calls, reachability, two way binding, etc.).

### Repository
Contains code to call specific webservices, DDBB, etc.

### Modules
Contains the specific MVVM-C implementation for every screen

## The app has been developed using the MVVM-C pattern.
