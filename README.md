# TileDoot
By Garry Kling

TileDoot is a tile sliding game where you slide tiles around the board to match adjacent colors. When like colors touch, they disappear and the remaining tiles slide into their place. You can slide up, down, left, and right, which moves all tiles in this direction. Players try to match a pre-determined par for each puzzle in order to earn stars. A Par score is three stars, one more move than par is two stars, and anything worse than that is only one star. 

The code is in Swift with the usual small amount of Objective-C need to interface with Cocoa. A recursive function at the end of each puzzle move determines if colors match using a connected components algorithm. If any tiles are deleted, the function calls itself again to move remaining tiles into emptied spaces if need, and check for new color matches. The game model communicates with the controller via a Swift protocol so that sprite animation can be handled directly. Tile actions are encapsulated in a Command pattern that is used by the delegate to move game tiles around. User interaction is forwarded from the view to model via a protocol as well. The game grid itself lives in a 2D array (using an override of the [] operator) and there is a parallel tree used by the connected components algorithm to group tiles for deletion.

Audio and visual assets were created using glass tiles used in mosiac artwork, and eventually I would love if gameplay could be integrated into a more skeumorphic look and behavior. The sound effects are made using sliding and dropping tiles, and sprites are textures using photos of tiles. Puzzles live in text files using a very simple shorthand that is easily parsed to load puzzles. Player scores are made persistent via iOS UserDefaults, but could use the GameCenter in the future. 

Thanks for looking at my project! If you have any questions or comments, please feel free to drop me a line!
