//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Photos

public final class PhotoKitVideoLibrary: VideoLibrary {
    public init() {}
    
    public func isPhotoAccessAuthorized() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        return status == .authorized || status == .limited
    }
    
    public func requestAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            let authorized = status == .authorized || status == .limited
            completion(authorized)
        }
    }
    
    public func fetchVideoAssets(startDate: Date) -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        let predicate = NSPredicate(format: "mediaType = %d AND creationDate <= %@", PHAssetMediaType.video.rawValue, startDate as CVarArg)
        fetchOptions.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchOptions.sortDescriptors = [sortDescriptor]
        fetchOptions.fetchLimit = 15
        
        let result = PHAsset.fetchAssets(with: fetchOptions)
        let assets = result.objects(at: IndexSet(0..<result.count))
        
        return assets
    }
}
