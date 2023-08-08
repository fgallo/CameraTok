//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Photos

class LocalThumbnailDataLoader: ThumbnailDataLoader {
    private let videoLibrary: VideoLibrary
    private let videoDataLibrary: VideoDataLibrary
    
    init(videoLibrary: VideoLibrary, videoDataLibrary: VideoDataLibrary) {
        self.videoLibrary = videoLibrary
        self.videoDataLibrary = videoDataLibrary
    }
    
    func loadThumbnailData(from videoId: String, withSize size: CGSize, completion: @escaping (ThumbnailDataLoader.Result) -> Void) {
        guard videoLibrary.isPhotoAccessAuthorized() else {
            let error = NSError(domain: "Access to device gallery is not allowed.", code: 0)
            completion(.failure(error))
            return
        }
        
        let asset = videoDataLibrary.fetchVideoAsset(id: videoId)
        
        videoDataLibrary.getThumbnailDataFromAsset(asset, size: size) { data in
            guard let data = data else {
                let error = NSError(domain: "It was not possible to retrieve image data from this asset.", code: 0)
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }
    }
}
