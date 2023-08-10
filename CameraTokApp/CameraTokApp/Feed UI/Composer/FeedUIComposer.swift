//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

import SwiftUI
import CameraTok

public final class FeedUIComposer {
    private init() {}
    
    static func feedComposedWith(feed: Feed,
                                 videoLoader: VideoDataLoader,
                                 rateCache: RateCache) -> FeedView {
        let feedViewModel = FeedViewModel(feed: feed)
        let scrollViewModel = ScrollViewModel()
        
        let feedView = FeedView(
            feedViewModel: feedViewModel,
            scrollViewModel: scrollViewModel,
            makeFeedCell: adaptModelToCell(
                feedViewModel: feedViewModel,
                videoLoader: videoLoader,
                rateCache: rateCache
            )
        )
        
        return feedView
    }
    
    private static func adaptModelToCell(feedViewModel: FeedViewModel,
                                         videoLoader: VideoDataLoader,
                                         rateCache: RateCache) -> (Int) -> FeedContainerCell? {
        return { index in
            guard index < feedViewModel.feed.videoItems.count else {
                return nil
            }
            
            let model = feedViewModel.feed.videoItems[index]
            let feedCellViewModel = FeedCellViewModel(model: model, videoLoader: videoLoader, rateCache: rateCache)
            return FeedContainerCell(viewModel: feedCellViewModel)
        }
    }
}
