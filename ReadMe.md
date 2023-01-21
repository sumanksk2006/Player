# Player in MVVM design pattern
-  Player controls (play/pause) are handled in model
-  ViewController initiates view that hosts player
-  View has dependency injection for viewModel
-  ViewController initiate viewModel with dataModel object and then passes to view to add playerLayer
-  Player will start playing Media on launch once playerItem's changed to .readyToPlay.
-  Created button to pause and play
-  Created ConsoleLogger class to log player status to consoler for every 0.5 and on pause/play button actions
-  Used observer on playerItem and player to start playing media and timer for console
-  Used an identifier "COMCAST_PLAYER" to filter console logs to identify all the console logs printed by logger
-  Written UnitTests for ViewModel


