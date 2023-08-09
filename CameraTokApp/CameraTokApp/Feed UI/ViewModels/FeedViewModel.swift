//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

class FeedViewModel: ObservableObject  {
    let feed: Feed
    
    var startIndex: Int {
        feed.startIndex
    }
    
    init(feed: Feed) {
        self.feed = feed
    }
}
