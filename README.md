# NASA_ImageSearcher
iOS App to search public NASA Image Database 
Supported on iOS 15.1 and above

Libraries Used:
-
    SwiftUI: This was the framework that was used to create the UI for the app. It was chosen due to the optimization and speed that it enables for user interface development. The dynamic rendering of views also allows the app to work in all device screen sizes and orientations.
    
    XCTest: This was used as the unit testing framework and was chosen due to its native capabilities to integrate with swift and the ability to be easily integrated into a CI/CD pipeline for automation testing in the future.
    
    Combine: This is utilized heavily under the hood with SwiftUI to enable UI bindings so that UI can be updated in a reactive paradigm opposed to UIKit where UI must be explicitly updated by the developer via many complex and repetative code implimentations. This was also used in turn with XCTest to take advantage of the published variables in the view model that were crucial in achiving 95%+ Code coverage in the view models.
    
    
Archetecture Layout:
-
    HomeScreen: The main homescreen has a SearchBarView and some text allowing the user to understand what they can do with the application. When a user selects the searchBarView to start typing in a query to search for, a keyboard will automatically appear. Once finished typing in what to search, the user may hit enter on the iOS keyboard or tapping the green search button below the text entry field. A user may also search with no query to see a large list of data returned. During the entire use of the application a user can search for new results at any point and will always have the main functionality of searching available to them as this is the major function of the application.
    
    Results List: This is the list the user sees after using the search action. it will produce a list from the NASA Image API with some animation that grows a list view from the center of the view and shows a list of items returned from the API with titles and images. A loading indicator is shown while loading occurs, Each item in the list will have a title and an image where the image was produced from a url that was fetched via an AsyncImage View. If there is an available image url than the image will show, otherwise a failedImage view will appear. The user may retry to load any image when the list of items are scrolled through and go off screen and come back on screen a new AsyncImage fetch will occur as the amount of images that can come back from the API are extensive and storing all those on device would not be efficient in performance or memory. Lazy loading each image as needed when it is in view and not storing it to memory was a design dicision due to the fact of how large some of the API responses can be. If a user has a returned API response that is larger than 100 items, when they get to the last item on the list, the next page of data will be fetched from the API and appended to the list while a loading indicator is shown while loading occurs. The ViewModel used knows the max number of pages to return and wont make an API call for a page that doesn't exist so when the last page is loaded you can scroll up and down within the list view and see all items returned for a given query. 
    
    Detail View: When a user taps on an item in the list they will use a NavigationLink within a NavigationView (NavigationStack not chosen so that iOS15 could be supported) and the user will be taken to a detail view where they can see a large version of the image, the title of the image, the description of the image, and also the date it was created. The user will have a back button to go back to the list of items or still be able to search for a new item as the search bar and functionality is always available within the app since that is it's main function. When a user searches for a new item animation will shrink the current view and re animate from the center of the screen with the Searched Results List view and be able to tap on items or scroll through the list.
    
How To Build & Run
-
    The main branch is where you should run the project from.
    
    To Build and Run simply clone the repo and build the project and run it in Xcode via CMD+R and the simulator will start and you will be able to start searching for all NASA Images from the API.
    
Notes
-
    I want to note that some of the titles for the images can be quite long so a limit of 10 lines was put in place to not make the cells too tall for the content and meaning that they have since a user can tap and see all the full contents of each item in the detail view.
    
    Enjoy using the app as it was incredibly fun to make and it is a valid tool for learning about various NASA topics and there are some pretty funny images if you search Mars and look at some of the alien festival pictures available.
