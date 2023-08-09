//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation
import CameraTok

class FeedCellViewModel: ObservableObject {
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
            switch result {
            case let .success(url):
                DispatchQueue.main.async {
                    self.state = .loaded(url)
                }
                
            case .failure:
                self.state = .error
            }
        }
    }
}

extension FeedCellViewModel {
    enum State {
        case loading
        case loaded(_ url: URL)
        case error
    }
}
