//
//  ApplyProductListCellView.swift
//  Infantory
//
//  Created by 안지영 on 2023/10/12.
//

import SwiftUI

struct ApplyProductListCellView: View {
    
    @ObservedObject var applyViewModel: ApplyProductStore
    var product: ApplyProduct
    
    var body: some View {
        VStack {
            HStack {
                if product.influencerProfile == nil {
                    Image("Influencer1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                    
                } else {
                    CachedImage(url: product.influencerProfile ?? "") { phase in
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
                            //
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
                
                Text(product.influencerNickname)
                    .font(.infanFootnoteBold)
                
                Spacer()
                
                if product.applyFilter == .planned {
                    Text("\(Image(systemName: "timer")) \(InfanDateFormatter.shared.dateTimeString(from: product.startDate)) OPEN")
                        .font(.infanFootnote)
                        .foregroundColor(.infanOrange)
                } else {
                    TimerView(remainingTime: applyViewModel.remainingTime(product: product))
                }
            }
            
        }
        .padding(.top, 10)
        .padding(.bottom, 6)
        .horizontalPadding()
        
        NavigationLink {
            ApplyDetailView(applyViewModel: applyViewModel, product: product)
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
                                if product.applyFilter == .close {
                                    ZStack {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .blur(radius: 5)
                                            .frame(width: (.screenWidth - 100) / 2, height: (.screenWidth - 100) / 2)
                                            .clipped()
                                        
                                        Text("응모 종료")
                                            .padding(10)
                                            .bold()
                                            .foregroundColor(.white)
                                            .background(Color.infanDarkGray)
                                            .cornerRadius(20)
                                    }
                                } else if product.applyFilter == .planned {
                                    ZStack {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .blur(radius: 5)
                                            .frame(width: (.screenWidth - 100) / 2, height: (.screenWidth - 100) / 2)
                                            .clipped()
                                        
                                        Text("응모 예정")
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
                        Image("appleLogo")
                            .resizable()
                            .scaledToFill()
                            .frame(width: (.screenWidth - 100) / 2,
                                   height: (.screenWidth - 100) / 2)
                            .clipped()
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("\(product.productName)")
                            .font(.infanBody)
                            .foregroundColor(.infanDarkGray)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            
                            if product.applyFilter != .planned {
                                Text("전체 응모: \(product.applyUserIDs.count) 회")
                                    .font(.infanHeadlineBold)
                                    .foregroundColor(.infanDarkGray)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        Spacer()
                        VStack {
                            Text("시작일  \(InfanDateFormatter.shared.dateTimeString(from: product.startDate))")
                                .font(.infanFootnote)
                                .foregroundColor(.infanGray)
                            
                            Text("마감일  \(InfanDateFormatter.shared.dateTimeString(from: product.endDate))")
                                .font(.infanFootnote)
                                .foregroundColor(.infanGray)
                        }
                    }
                    Spacer()
                }
                Divider()
            }
            .horizontalPadding()
        }
    }
}

struct ApplyProductListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ApplyProductListCellView(applyViewModel: ApplyProductStore(), product: ApplyProduct(productName: "", productImageURLStrings: [""], description: "", influencerID: "", influencerNickname: "볼빨간사춘기", startDate: Date(), endDate: Date(), applyUserIDs: [""]))
    }
}