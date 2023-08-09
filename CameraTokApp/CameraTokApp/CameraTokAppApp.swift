//
//  Created by Fernando Gallo on 07/08/23.
//

import SwiftUI
import CameraTok

@main
struct CameraTokAppApp: App {
    @State var navigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                GalleryUIComposer.galleryComposedWith(
                    videoGalleryLoader: makeVidelGalleryLoader(),
                    imageDataLoader: makeThumbnailDataLoader(),
                    selection: { feed in
                        navigationPath.append(feed)
                    }
                )
                .navigationDestination(for: Feed.self) { feed in
                    FeedUIComposer.feedComposedWith(
                        feed: feed,
                        videoLoader: makeVideoDataLoader()
                    )
                }
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
    
    func makeVideoDataLoader() -> VideoDataLoader {
        let videoLibrary = PhotoKitVideoLibrary()
        let videoDataLibrary = PhotoKitVideoDataLibrary()
        return LocalVideoDataLoader(videoLibrary: videoLibrary, videoDataLibrary: videoDataLibrary)
    }
}
