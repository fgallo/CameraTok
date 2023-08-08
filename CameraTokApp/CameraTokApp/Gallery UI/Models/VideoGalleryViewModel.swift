//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Combine
import CameraTok

class VideoGalleryViewModel: ObservableObject {
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
                self.state = .loaded(videoItems)
                
            case let .failure(error):
                self.state = .error(error)
            }
        }
    }
}

extension VideoGalleryViewModel {
    enum State {
        case loading
        case loaded(_ items: [VideoItem])
        case error(_ error: Error)
    }
}