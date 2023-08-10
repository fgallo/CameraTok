//
//  Created by Fernando Gallo on 10/08/23.
//

import Foundation
import CameraTok

class RateStoreSpy: RateStore {
    enum ReceivedMessage: Equatable {
        case insert(RateItem)
        case delete
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private(set) var deletionCompletions = [(Error?) -> Void]()
    private(set) var insertionCompletions = [(Error?) -> Void]()
    private(set) var retrievalCompletions = [(RetrieveCachedRatesResult) -> Void]()
    
    func insert(_ rate: RateItem, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(rate))
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(_ videoId: String, completion: @escaping RetrieveCompletion) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with rate: RateItem, at index: Int = 0) {
        retrievalCompletions[index](.found(rate))
    }
}
