//
//  Created by Fernando Gallo on 10/08/23.
//

import XCTest
@testable import CameraTok

final class LocalRateLoaderTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }

    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = RateStoreSpy()
        var sut: LocalRateLoader? = LocalRateLoader(store: store)
        
        var receivedResults = [LocalRateLoader.SaveResult]()
        sut?.save(makeRate()) { receivedResults.append($0) }
        
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load("") { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoRateOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(nil), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversRateOnNonEmptyCache() {
        let (sut, store) = makeSUT()
        let rate = makeRate()
        
        expect(sut, toCompleteWith: .success(rate), when: {
            store.completeRetrieval(with: rate)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = RateStoreSpy()
        var sut: LocalRateLoader? = LocalRateLoader(store: store)
        
        var receivedResults = [RateCache.LoadResult]()
        sut?.load("") { receivedResults.append($0) }
        
        sut = nil
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRateLoader, store: RateStoreSpy) {
        let store = RateStoreSpy()
        let sut = LocalRateLoader(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalRateLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void,
                        file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: Error?
        sut.save(makeRate()) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, expectedError, file: file, line: line)
    }
    
    private func expect(_ sut: LocalRateLoader, toCompleteWith expectedResult: RateCache.LoadResult, when action: () -> Void,
                        file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")

        sut.load("") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedRate), .success(expectedRate)):
                XCTAssertEqual(receivedRate, expectedRate, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
 
    private func makeRate() -> RateItem {
        return RateItem(videoId: "1", rate: .like)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
}
