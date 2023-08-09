//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

import SwiftUI
import CameraTok

public final class FeedUIComposer {
    private init() {}
    
    static func feedComposedWith(model: VideoItem,
                                 videoDataLoader: VideoDataLoader) -> FeedContainerView {
        
        let feedViewModel = FeedViewModel(
            model: model,
            videoLoader: videoDataLoader
        )
        
        let feedView = FeedContainerView(
            viewModel: feedViewModel
        )
        
        return feedView
    }
}
