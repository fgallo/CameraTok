//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

enum Rate {
    case like
    case dislike
}

protocol VideoRateAction {
    typealias SaveResult = Error?
    typealias LoadResult = Swift.Result<[String], Error>
    
    func saveVideoRate(videoId: String, rate: Rate, completion: @escaping (SaveResult) -> Void)
    func loadAllVideoRates(completion: @escaping (LoadResult) -> Void)
}
