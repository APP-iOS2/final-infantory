//
//  InfluencerMainView.swift
//  Infantory
//
//  Created by 민근의 mac on 10/16/23.
//

import SwiftUI

struct InfluencerMainView: View {
    
    @EnvironmentObject private var loginStore: LoginStore
    @EnvironmentObject private var influencerStore: InfluencerStore
    @StateObject var applyProductStore: ApplyProductStore = ApplyProductStore()
    @StateObject var auctionViewModel: AuctionProductViewModel = AuctionProductViewModel()
    @State var searchCategory: InfluencerCategory = .auction
    
    var influencerID: String

    var body: some View {
        VStack {
            
            InfluencerImageView()
            
            if influencerID != loginStore.userUid {
                Button {
                    if influencerStore.isFollow {
                        influencerStore.unfollowInfluencer(influencerID: influencerID, userID: loginStore.userUid)
                    } else {
                        influencerStore.followInfluencer(influencerID: influencerID, userID: loginStore.userUid)
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(influencerStore.isFollow ? Color.infanLightGray: Color.infanMain)
                        .cornerRadius(8)
                        .overlay {
                            Text(influencerStore.isFollow ? "팔로우 취소": "팔로우")
                                .foregroundColor(.white)
                                .font(.infanHeadline)
                                .padding()
                        }
                        .frame(width: .screenWidth - 40, height: 40)
                }
            }
            
            InfluencerTabBarView(searchCategory: $searchCategory)
            
            TabView(selection: $searchCategory) {
                ForEach(InfluencerCategory.allCases, id: \.self) { category in
                    switch searchCategory {
                    case .auction:
                        VStack {
                            if influencerStore.influencerAuctionProduct.isEmpty {
                                Text("경매 등록상품이 없습니다.")
                                    .font(.infanBody)
                                    .foregroundColor(.infanDarkGray)
                            } else {
                                ScrollView {
                                    InfluencerAuctionListView(auctionViewModel: auctionViewModel)
                                }
                            }
                        }
                        .tag(category)
                    case .apply:
                        VStack {
                            if influencerStore.influencerApplyProduct.isEmpty {
                                Text("응모 등록상품이 없습니다.")
                                    .font(.infanBody)
                                    .foregroundColor(.infanDarkGray)
                            } else {
                                ScrollView {
                                    InfluencerApplyListView(applyProductStore: applyProductStore)
                                }
                            }
                        }
                        .tag(category)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onChange(of: searchCategory, perform: { newValue in
            influencerStore.selectedCategory = newValue
        })
        .navigationBar(title: influencerStore.influencer.nickName)
        .task {
            Task {
                try await influencerStore.fetchInfluencer(influencerID: influencerID)
                try await influencerStore.fetchInfluencerApplyProduct(influencerID: influencerID)
                try await influencerStore.fetchInfluencerAuctionProduct(influencerID: influencerID)
                try await influencerStore.fetchFollower(influencerID: influencerID, userID: loginStore.userUid)
            }
        }
        .refreshable {
            Task {
                try await influencerStore.fetchInfluencer(influencerID: influencerID)
            }
        }
        .onAppear {
            influencerStore.selectedCategory = .auction
            searchCategory = .auction
        }
    }
}

struct InfluencerMainView_Previews: PreviewProvider {
    static var previews: some View {
        InfluencerMainView(influencerID: "")
    }
}
