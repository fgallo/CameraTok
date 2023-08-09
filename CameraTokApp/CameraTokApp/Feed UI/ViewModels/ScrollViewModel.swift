//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation
import Combine

class ScrollViewModel: ObservableObject {
    let scrollDetector: CurrentValueSubject<CGFloat, Never>
    let scrollPublisher: AnyPublisher<CGFloat, Never>
    
    init() {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        self.scrollPublisher = detector
            .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
            .dropFirst().eraseToAnyPublisher()
        self.scrollDetector = detector
    }
}
