//
//  HomeApplyView.swift
//  Infantory
//
//  Created by 안지영 on 2023/10/16.
//

import SwiftUI

struct HomeApplyView: View {
    @ObservedObject var applyProductStore: ApplyProductStore
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(applyProductStore.filteredProduct.prefix(5)) { product in
                    NavigationLink {
                        ApplyDetailView(applyProductStore: applyProductStore, product: product)
                    } label: {
                        VStack(alignment: .leading) {           
                            TimerView(remainingTime: applyProductStore.remainingTime(product: product))
                            
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
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: (.screenWidth - 100) / 2, height: (.screenWidth - 100) / 2)
                                            .clipped()
                                        
                                    case .failure:
                                        Image(systemName: "xmark")
                                            .frame(width: (.screenWidth - 100) / 2,
                                                   height: (.screenWidth - 100) / 2)
                                        
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                            } else {
                                Image("smallAppIcon")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (.screenWidth - 100) / 2,
                                           height: (.screenWidth - 100) / 2)
                                    .clipped()
                            }
                            VStack(alignment: .leading) {
                                Text(product.influencerNickname)
                                    .foregroundColor(.infanBlack)
                                    .bold()
                                
                                Text(product.productName)
                                    .lineLimit(1)
                                
                                Text("전체 응모: \(product.applyUserIDs.count) 회")
                                    .foregroundColor(Color.infanDarkGray)
                            }
                            .font(.infanFootnote)
                        }
                        .frame(width: (.screenWidth - 100) / 2)
                    }
                }
                .padding(.leading, 20)
            }
            .frame(height: ((.screenWidth - 100) / 2) + 80)
            .scrollIndicators(.hidden)
        }
    }
}

struct HomeApplyView_Previews: PreviewProvider {
    static var previews: some View {
        HomeApplyView(applyProductStore: ApplyProductStore())
    }
}
