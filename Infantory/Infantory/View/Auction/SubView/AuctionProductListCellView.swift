//
//  AuctionProductListCellView.swift
//  Infantory
//
//  Created by 민근의 mac on 10/12/23.
//

import SwiftUI

struct AuctionProductListCellView: View {
    @EnvironmentObject var loginStore: LoginStore
    @ObservedObject var auctionViewModel: AuctionProductViewModel
    @StateObject var myActivityStore = MyActivityStore()
    var product: AuctionProduct
    
    var body: some View {
        NavigationLink {
            AuctionDetailView(auctionStore: AuctionStore(product: product))
        } label: {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    if product.productImageURLStrings.count > 0 {
                        CachedImage(url: product.productImageURLStrings[0]) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .scaledToFill()
                                    .frame(width: (.screenWidth - 100) / 2,
                                           height: (.screenWidth - 100) / 2)
                                    .clipped()
                            case .success(let image):
                                if product.auctionFilter == .close {
                                    ZStack {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .blur(radius: 5)
                                            .frame(width: (.screenWidth - 100) / 2, height: (.screenWidth - 100) / 2)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        Text("경매 종료")
                                            .padding(10)
                                            .bold()
                                            .foregroundColor(.white)
                                            .background(Color.infanDarkGray)
                                            .cornerRadius(20)
                                    }
                                
                                } else if product.auctionFilter == .planned {
                                    ZStack {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .blur(radius: 5)
                                            .frame(width: (.screenWidth - 100) / 2, height: (.screenWidth - 100) / 2)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        Text("경매 예정")
                                            .padding(10)
                                            .bold()
                                            .foregroundColor(.white)
                                            .background(Color.infanOrange)
                                            .cornerRadius(20)
                                    }
                                } else {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (.screenWidth - 100) / 2, height: (.screenWidth - 100) / 2)
                                        .clipped()
                                        .cornerRadius(10)
                                }
                            case .failure:
                                Image(systemName: "xmark")
                                    .frame(width: (.screenWidth - 100) / 2,
                                           height: (.screenWidth - 100) / 2)
                                
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                    } else {
                        ZStack(alignment: .topLeading) {
                            
                            Image("smallAppIcon")
                                .resizable()
                                .scaledToFill()
                                .frame(width: (.screenWidth - 100) / 2,
                                       height: (.screenWidth - 100) / 2)
                                .clipped()
                            
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("\(product.productName)")
                            .font(.infanBody)
                            .foregroundColor(.infanDarkGray)
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 10)
                        
                        TextAnimateView(value: myActivityStore.winningPrice == 0 ? Double(product.minPrice) : myActivityStore.winningPrice)
                            .foregroundColor(Color.infanDarkGray)
                            .monospacedDigit()
                            .animation(Animation.easeInOut(duration: 1))
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("시작일  \(InfanDateFormatter.shared.dateTimeString(from: product.startDate))")
                                .font(.infanFootnote)
                                .foregroundColor(.infanGray)
                            
                            Text("마감일  \(InfanDateFormatter.shared.dateTimeString(from: product.endDate))")
                                .font(.infanFootnote)
                                .foregroundColor(.gray)
                                .bold()
                        }
                    }
                }
                Divider()
            }
            .horizontalPadding()
            .onAppear {
                myActivityStore.fetchWinningPrice(productID: product.id ?? "")
            }
        }
    }
}

struct AuctionProductListCellView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionProductListCellView(auctionViewModel: AuctionProductViewModel(), product: AuctionProduct(id: "", productName: "", productImageURLStrings: [""], description: "", influencerID: "", influencerNickname: "", influencerProfile: "", winningUserID: "", startDate: Date(), endDate: Date(), registerDate: Date(), minPrice: 0, winningPrice: 0))
    }
}
