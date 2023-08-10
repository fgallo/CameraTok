//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation
import CameraTok

class FeedCellViewModel: ObservableObject {
    private let model: VideoItem
    private let videoLoader: VideoDataLoader
    private let rateCache: RateCache
    
    @Published var state: State = .loading
    @Published var rateState: RateState = .undefined
    
    init(model: VideoItem, videoLoader: VideoDataLoader, rateCache: RateCache) {
        self.model = model
        self.videoLoader = videoLoader
        self.rateCache = rateCache
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
    
    func loadRate() {
        rateCache.load(model.id) { result in
            switch result {
            case let .success(item):
                DispatchQueue.main.async {
                    guard let item = item else {
                        self.rateState = .undefined
                        return
                    }
                    
                    self.rateState = self.rateToRateState(item.rate)
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.rateState = .undefined
                }
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
        rateCache.save(item) { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.rateState = self.rateToRateState(rate)
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

extension FeedCellViewModel {
    enum RateState {
        case liked
        case disliked
        case undefined
    }
    
    private func rateToRateState(_ rate: Rate) -> RateState {
        switch rate {
        case .like:
            return .liked
            
        case .dislike:
            return .disliked
        }
    }
}
