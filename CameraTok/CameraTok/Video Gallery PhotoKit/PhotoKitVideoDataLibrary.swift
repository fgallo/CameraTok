//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Photos
import PhotosUI

final class PhotoKitVideoDataLibrary: VideoDataLibrary {
    func fetchVideoAsset(id: String) -> PHAsset {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        let asset = result.object(at: 0)
        
        return asset
    }
    
    func getThumbnailDataFromAsset(_ asset: PHAsset, size: CGSize, completion: @escaping (Data?) -> Void) {
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { image, info in
            completion(image?.tiffRepresentation)
        }
    }
}
