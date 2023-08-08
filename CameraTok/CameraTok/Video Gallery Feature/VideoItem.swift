//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation

public struct VideoItem: Equatable {
    public let id: String
    public let duration: Double
    public let liked: Bool
    
    public init(id: String, duration: Double, liked: Bool) {
        self.id = id
        self.duration = duration
        self.liked = liked
    }
}
