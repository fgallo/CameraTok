//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation
import CameraTok

class VideoGalleryCellViewModel<Image>: ObservableObject {
    private let model: VideoItem
    private let imageLoader: ThumbnailDataLoader
    private let imageTransformer: (Data) -> Image?
    
    @Published var state: State = .loading
    
    init(model: VideoItem, imageLoader: ThumbnailDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    func loadImageData(size: CGSize) {
        state = .loading
        imageLoader.loadThumbnailData(from: model.id, withSize: size) { result in
            guard let image = (try? result.get()).flatMap(self.imageTransformer) else {
                self.state = .error
                return
            }
            
            let duration = self.secondsToHoursMinutesSeconds(self.model.duration)
            self.state = .loaded(image, duration)
        }
    }
    
    func secondsToHoursMinutesSeconds(_ duration: Double) -> String {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let start = cal.startOfDay(for: date)

        // add your duration
        let newDate = start.addingTimeInterval(duration)

        // create a DateFormatter
        let formatter = DateFormatter()

        // set the format to minutes:seconds (leading zero-padded)
        formatter.dateFormat = "mm:ss"

        let resultString = formatter.string(from: newDate)

        return resultString
    }
}

extension VideoGalleryCellViewModel {
    enum State {
        case loading
        case loaded(_ image: Image, _ duration: String)
        case error
    }
}
