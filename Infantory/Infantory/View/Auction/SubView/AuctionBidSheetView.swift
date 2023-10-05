//
//  AuctionBidSheetView.swift
//  Infantory
//
//  Created by 변상필 on 10/4/23.
//

import SwiftUI

// 헤드라인, 바디, 헤드라인 볼드, 풋노트?

struct AuctionBidSheetView: View {
    @ObservedObject var auctionViewModel: AuctionViewModel
    
    @State private var selectedIndex: Int = 1 // 선택된 버튼
    @State private var selectedAmount: Int = 0// 선택된 금액
    
    var body: some View {
        VStack {
            headerView
            
            ForEach(1..<4) { index in
                bidSelectButton(bidAmount: (auctionViewModel.biddingInfos.last?.biddingPrice ?? 0) + auctionViewModel.bidIncrement * index, index: index)
                
            }
            
            Button {
                auctionViewModel.addBid(biddingInfo: BiddingInfo(id: UUID(),
                                                                 timeStamp: Date(),
                                                                 participants: "갓희찬",
                                                                 biddingPrice: selectedAmount))
            } label: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.infanMain)
                    .overlay {
                        Text("\(selectedAmount) 입찰하기")
                            .font(.infanHeadlineBold)
                            .foregroundStyle(.white)
                        
                    }
                    .infanHorizontalPadding()
                    .frame(width: .infinity, height: 54)
            }
        }
        .onAppear {
            self.auctionViewModel.onDataUpdate = {
                self.selectedAmount = auctionViewModel.biddingInfos.last?.biddingPrice ?? 0
                print("hello")
            }
        }
        
    }
}

extension AuctionBidSheetView {
    var headerView: some View {
        VStack {
            Text("입찰가 선택")
                .font(.infanTitle2Bold)
                .padding(.bottom, 5)
            
            Text("멋쟁이 신발")
                .padding(.bottom, 5)
            
            HStack {
                Text("\(auctionViewModel.biddingInfos.last?.biddingPrice ?? 0)")
                Text("•")
                TimerView(remainingTime: 10000)
                
            }
            .foregroundColor(.infanMain)
            .font(.infanFootnote)
            .padding(.bottom)
        }
    }
}

extension AuctionBidSheetView {
    func bidSelectButton(bidAmount: Int, index: Int) -> some View {
        
        Button {
            selectedAmount = bidAmount
            selectedIndex = index
        } label: {
            
            ZStack {
                Text("\(bidAmount)")
                    .font(.infanHeadline)
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(index == selectedIndex ? Color.infanMain : Color.white)
                    .opacity(0.3)
                    .frame(width: .infinity, height: 54)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle())
                    .foregroundColor(.gray)
                    .frame(width: .infinity, height: 54)
            }
            .infanHorizontalPadding()
        }
        .buttonStyle(.plain)
        .padding(.bottom, 8)
    }
}

struct AuctionBidSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionBidSheetView(auctionViewModel: AuctionViewModel())
    }
}

//#Preview {
//    AuctionBidSheetView()
//}
