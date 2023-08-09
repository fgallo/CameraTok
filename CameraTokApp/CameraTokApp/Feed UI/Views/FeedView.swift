//
//  Created by Fernando Gallo on 08/08/23.
//

import SwiftUI
import AVKit

struct FeedContainerView: View {
    @StateObject var viewModel: FeedViewModel
    
    var body: some View {
        FeedView(state: viewModel.state)
    }
}

struct FeedView: View {
    var state: FeedViewModel.State
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
                
            case let .loaded(url):
                VideoPlayer(player: AVPlayer(url: url))
                .ignoresSafeArea()
                
            case .error:
                EmptyView()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(
            state: .loaded(URL(string: "https://google.com")!)
        )
    }
}
