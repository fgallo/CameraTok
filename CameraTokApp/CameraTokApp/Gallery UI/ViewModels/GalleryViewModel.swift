//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Combine
import CameraTok

class GalleryViewModel: ObservableObject {
    private let videoGalleryLoader: VideoGalleryLoader
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var state: State = .loading
    @Published var startDate: Date = Date()
    
    init(videoGalleryLoader: VideoGalleryLoader) {
        self.videoGalleryLoader = videoGalleryLoader
        
        $startDate
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { date in
                self.loadGallery()
            }
            .store(in: &cancellables)
    }
    
    func loadGallery() {
        state = .loading
        videoGalleryLoader.load(with: startDate) { result in
            switch result {
            case let .success(videoItems):
                DispatchQueue.main.async {
                    self.state = .loaded(videoItems)
                }
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
    
    func loadMore() {
        guard case .loaded(let items) = state else {
            return
        }
        
        videoGalleryLoader.load(with: items.last?.creationDate ?? Date()) { result in
            switch result {
            case let .success(videoItems):
                DispatchQueue.main.async {
                    self.state = .loaded(items + videoItems)
                }
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
}

extension GalleryViewModel {
    enum State {
        case loading
        case loaded(_ items: [VideoItem])
        case error(_ error: Error)
    }
}
