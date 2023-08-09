//
//  Created by Fernando Gallo on 08/08/23.
//

import SwiftUI

struct FeedView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var feedViewModel: FeedViewModel
    @StateObject var scrollViewModel: ScrollViewModel
    
    let makeFeedCell: (Int) -> FeedContainerCell?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                
                backButton
                
                contentView(geo)
            }
            .edgesIgnoringSafeArea(.all)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
    }
    
    func contentView(_ geo: GeometryProxy) -> some View {
        ScrollViewReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(0..<(feedViewModel.feed.videoItems.count), id: \.self) { i in
                        makeFeedCell(i)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .id(i)
                    }
                }
                .background(GeometryReader {
                    Color.clear.preference(key: ScrollOffsetKey.self,
                                           value: -$0.frame(in: .named("scroll")).origin.y)
                })
                .onPreferenceChange(ScrollOffsetKey.self) {scrollViewModel.scrollDetector.send($0) }
                .background(UIScrollViewBridge(decelerationRate: .fast))
            }
            .coordinateSpace(name: "scroll")
            .onReceive(scrollViewModel.scrollPublisher) {
                var index = $0/geo.size.height
                // Check if next item is near
                let value = index < 1 ? index : index.truncatingRemainder(dividingBy: CGFloat(Int(index)))
                if value > 0.5 { index += 1 }
                else { index = CGFloat(Int(index)) }
                // Scroll to index
                withAnimation { reader.scrollTo(Int(index), anchor: .center) }
            }
            .onAppear {
                reader.scrollTo(Int(feedViewModel.feed.startIndex), anchor: .center)
            }
        }
    }
    
    var backButton: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            Spacer()
        }
        .zIndex(1)
        .padding(.leading, 16)
        .padding(.top, 56)
    }
}

extension FeedView {
    private struct ScrollOffsetKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue = CGFloat.zero
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(
            feedViewModel: FeedViewModel(feed: Feed(videoItems: [], startIndex: 0)),
            scrollViewModel: ScrollViewModel(),
            makeFeedCell: { _ in nil }
        )
    }
}
