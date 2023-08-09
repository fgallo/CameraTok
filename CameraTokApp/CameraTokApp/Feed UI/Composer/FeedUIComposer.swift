//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

import SwiftUI
import CameraTok

public final class FeedUIComposer {
    private init() {}
    
    static func feedComposedWith(feed: Feed,
                                 videoLoader: VideoDataLoader) -> FeedView {
        let feedViewModel = FeedViewModel(feed: feed)
        let scrollViewModel = ScrollViewModel()
        
        let feedView = FeedView(
            feedViewModel: feedViewModel,
            scrollViewModel: scrollViewModel,
            makeFeedCell: adaptModelToCell(
                feedViewModel: feedViewModel,
                videoLoader: videoLoader
            )
        )
        
        return feedView
    }
    
    private static func adaptModelToCell(feedViewModel: FeedViewModel, videoLoader: VideoDataLoader) -> (Int) -> FeedContainerCell? {
        return { index in
            guard index < feedViewModel.feed.videoItems.count else {
                return nil
            }
            
            let model = feedViewModel.feed.videoItems[index]
            let feedCellViewModel = FeedCellViewModel(model: model, videoLoader: videoLoader)
            return FeedContainerCell(viewModel: feedCellViewModel)
        }
    }
}
