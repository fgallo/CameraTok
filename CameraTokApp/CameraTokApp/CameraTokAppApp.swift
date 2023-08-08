//
//  Created by Fernando Gallo on 07/08/23.
//

import SwiftUI
import CameraTok

@main
struct CameraTokAppApp: App {
    var body: some Scene {
        WindowGroup {
            let videoLibrary = PhotoKitVideoLibrary()
            let videoDataLibrary = PhotoKitVideoDataLibrary()
            let videoGalleryLoader = LocalVideoGalleryLoader(videoLibrary: videoLibrary)
            let imageDataLoader = LocalThumbnailDataLoader(videoLibrary: videoLibrary, videoDataLibrary: videoDataLibrary)
            
            GalleryUIComposer.galleryComposedWith(videoGalleryLoader: videoGalleryLoader, imageDataLoader: imageDataLoader) {
                
            }
        }
    }
}
