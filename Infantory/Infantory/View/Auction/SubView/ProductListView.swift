//
//  ProductCell.swift
//  Infantory
//
//  Created by 윤경환 on 2023/09/22.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var userViewModel: UserViewModel
    @StateObject var auctionViewModel: AuctionProductViewModel = AuctionProductViewModel()
    
    @State private var heartButton: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35)
                Text("\(userViewModel.user.name)")
                Spacer()
                Button(action: {
                    heartButton.toggle()
                }, label: {
                    Image(systemName: heartButton ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .foregroundColor(.infanDarkGray)
                })
            }
            .padding([.horizontal, .top])
            ForEach(auctionViewModel.auctionProduct) { product in
                VStack {
                    Button {
                        
                    } label: {
                        HStack {
                            // 배열의 첫번째 값 넣어둠.
                            Image("\(product.productImageURLStrings[0])")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 160)
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Hot")
                                        .font(.infanFootnote)
                                        .frame(width: 40, height: 20)
                                        .foregroundColor(.infanDarkGray)
                                        .background(Color.infanRed)
                                        .cornerRadius(10)
                                    Text("New")
                                        .font(.infanFootnote)
                                        .frame(width: 40, height: 20)
                                        .foregroundColor(.infanDarkGray)
                                        .background(Color.infanGreen)
                                        .cornerRadius(10)
                                }
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("상품명: \(product.productName)")
                                        .font(.infanTitle2)
                                        .foregroundColor(.infanDarkGray)
                                        .padding(.bottom)
                                    Text("남은시간: 03:02:01")
                                        .font(.infanBody)
                                        .foregroundColor(.infanDarkGray)
                                    Text("현재 입찰가: \(product.winningPrice)")
                                        .font(.infanBody)
                                        .foregroundColor(.infanDarkGray)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(userViewModel: UserViewModel(), auctionViewModel: AuctionProductViewModel())
    }
}