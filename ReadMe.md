# Player in MVVM design pattern

-  Dependency Injection for ViewModel and View
-  Player controls (play/pause) are handled in viewModel
-  ViewController initiates viewModel with dataModel object and then passes to view's initializer to configure player
-  Player will start playing Media on launch once playerItem's status changed to .readyToPlay.
-  Created button to pause and play media
-  Created ConsoleLogger class to log player status for every 0.5 and on pause/play button actions
-  Used observer on playerItem and player to start playing media and handle logger events
-  Used an identifier "COMCAST_PLAYER" to filter console logs in XCode
-  Written UnitTests for ViewModel
