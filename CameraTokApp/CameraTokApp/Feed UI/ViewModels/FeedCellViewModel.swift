//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation
import CameraTok

class FeedCellViewModel: ObservableObject {
    private let model: VideoItem
    private let videoLoader: VideoDataLoader
    private let rateAction: VideoRateAction
    
    @Published var state: State = .loading
    
    init(model: VideoItem, videoLoader: VideoDataLoader, rateAction: VideoRateAction) {
        self.model = model
        self.videoLoader = videoLoader
        self.rateAction = rateAction
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
    
    func like() {
        rate(.like)
    }
    
    func dislike() {
        rate(.dislike)
    }
    
    private func rate(_ rate: Rate) {
        let item = RateItem(videoId: model.id, rate: rate)
        rateAction.save(item) { _ in }
    }
}

extension FeedCellViewModel {
    enum State {
        case loading
        case loaded(_ url: URL)
        case error
    }
}
