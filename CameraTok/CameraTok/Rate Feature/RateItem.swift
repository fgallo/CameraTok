//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

public struct RateItem: Hashable, Codable {
    public let videoId: String
    public let rate: Rate
    
    public init(videoId: String, rate: Rate) {
        self.videoId = videoId
        self.rate = rate
    }
}
