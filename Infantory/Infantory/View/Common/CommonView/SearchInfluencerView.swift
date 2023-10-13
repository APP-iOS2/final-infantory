//
//  SearchInfluencerView.swift
//  Infantory
//
//  Created by 민근의 mac on 10/12/23.
//

import SwiftUI

struct SearchInfluencerView: View {
    
    @ObservedObject var searchStore: SearchStore
    
    var body: some View {
            ForEach(searchStore.influencer) { influencer in
                HStack {
                    if influencer.profileImageURLString == nil {
                        Image("Influencer1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .cornerRadius(20)
                    } else {
                        CachedImage(url: influencer.profileImageURLString ?? "") { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                            case .success(let image):
                                image
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                            case .failure:
                                Image(systemName: "xmark")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(20)
                                
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    Text(influencer.nickName)
                    Spacer()
                }
            }
            .horizontalPadding()
    }
}

struct SearchInfluencerView_Previews: PreviewProvider {
    static var previews: some View {
        SearchInfluencerView(searchStore: SearchStore())
    }
}