//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation
import CameraTok

class FeedViewModel: ObservableObject  {
    private let model: VideoItem
    private let videoLoader: VideoDataLoader
    
    @Published var state: State = .loading
    
    init(model: VideoItem, videoLoader: VideoDataLoader) {
        self.model = model
        self.videoLoader = videoLoader
    }
    
    func loadVideoData() {
        state = .loading
        videoLoader.loadVideoData(from: model.id) { result in
            
        }
    }
}

extension FeedViewModel {
    enum State {
        case loading
        case loaded(_ url: URL)
        case error
    }
}
