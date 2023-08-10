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
                    rateCache: makeRateCache(),
                    selection: { feed in
                        navigationPath.append(feed)
                    }
                )
                .navigationDestination(for: Feed.self) { feed in
                    FeedUIComposer.feedComposedWith(
                        feed: feed,
                        videoLoader: makeVideoDataLoader(),
                        rateCache: makeRateCache()
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
    
    func makeRateCache() -> RateCache {
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("rate.store")        
        let store = CodableRateStore(storeURL: storeURL)
        return LocalRateLoader(store: store)
    }
}
