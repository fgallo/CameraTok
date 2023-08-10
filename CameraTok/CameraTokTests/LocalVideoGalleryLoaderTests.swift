//
//  Created by Fernando Gallo on 07/08/23.
//

import XCTest
import Photos
@testable import CameraTok

final class LocalVideoGalleryLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyFetchRequest() {
        let (_, library) = makeSUT()
        
        XCTAssertTrue(library.fetchRequests.isEmpty)
    }
    
    func test_load_fetchesWithStartDate() {
        let (sut, library) = makeSUT()
        let date = anyDate()
        
        sut.load(with: date) { _ in }
        
        XCTAssertEqual(library.fetchRequests, [date])
    }
    
    func test_loadTwice_fetchesWithStartDateTwice() {
        let (sut, library) = makeSUT()
        let date = anyDate()
        
        sut.load(with: date) { _ in }
        sut.load(with: date) { _ in }
        
        XCTAssertEqual(library.fetchRequests, [date, date])
    }
    
    func test_load_deliversNoItemsWhenLibraryIsEmpty() {
        let (sut, library) = makeSUT()
        let date = anyDate()
        library.assets = []
        
        let exp = expectation(description: "Wait for load completion")
        sut.load(with: date) { receivedResult in
            switch receivedResult {
            case .success(let receivedItems):
                XCTAssertEqual(receivedItems, [], "Expected success: \(receivedItems), but got \(receivedResult)")
                
            default:
                XCTFail("Expected empty items, got \(receivedResult) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversItemsWhenLibraryIsNotEmpty() {
        let (sut, library) = makeSUT()
        let date = anyDate()
        let assets = [PHAsset(), PHAsset()]
        library.assets = assets
        
        let exp = expectation(description: "Wait for load completion")
        sut.load(with: date) { receivedResult in
            switch receivedResult {
            case .success(let receivedItems):
                XCTAssertEqual(receivedItems.map { $0.id }, assets.map { $0.localIdentifier }, "Expected success: \(receivedItems), but got \(receivedResult)")
                
            default:
                XCTFail("Expected empty items, got \(receivedResult) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalVideoGalleryLoader, library: VideoLibrarySpy) {
        let library = VideoLibrarySpy()
        let sut = LocalVideoGalleryLoader(videoLibrary: library)
        trackForMemoryLeaks(library)
        trackForMemoryLeaks(sut)
        return (sut, library)
    }
    
    private func makeVideoItem() -> VideoItem {
        let asset = PHAsset()
        return VideoItem(id: asset.localIdentifier, duration: 0, creationDate: Date())
    }
    
    private func anyDate() -> Date {
        return Date()
    }
    
    private class VideoLibrarySpy: VideoLibrary {
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
}
