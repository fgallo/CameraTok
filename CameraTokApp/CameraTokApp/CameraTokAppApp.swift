//
//  Created by Fernando Gallo on 07/08/23.
//

import SwiftUI
import CameraTok

@main
struct CameraTokAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GalleryUIComposer.galleryComposedWith(
                    videoGalleryLoader: makeVidelGalleryLoader(),
                    imageDataLoader: makeThumbnailDataLoader(),
                    selection: {}
                )
            }
        }
    }
}

extension CameraTokAppApp {
    func makeVidelGalleryLoader() -> VideoGalleryLoader {
        let videoLibrary = PhotoKitVideoLibrary()
        return LocalVideoGalleryLoader(videoLibrary: videoLibrary)
    }
    
    func makeThumbnailDataLoader() -> ThumbnailDataLoader {
        let videoLibrary = PhotoKitVideoLibrary()
        let videoDataLibrary = PhotoKitVideoDataLibrary()
        return LocalThumbnailDataLoader(videoLibrary: videoLibrary, videoDataLibrary: videoDataLibrary)
    }
}
