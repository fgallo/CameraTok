//
//  Created by Fernando Gallo on 10/08/23.
//

import Foundation
import CameraTok
import Photos

class VideoLibrarySpy: VideoLibrary {
    var fetchRequests = [Date]()
    var authorized = true
    var assets = [PHAsset]()
    
    func isPhotoAccessAuthorized() -> Bool {
        return authorized
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    func fetchVideoAssets(startDate: Date) -> [PHAsset] {
        fetchRequests.append(startDate)
        return assets
    }
}
