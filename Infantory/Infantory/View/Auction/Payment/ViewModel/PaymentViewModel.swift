//
//  PaymentViewModel.swift
//  Infantory
//
//  Created by 이희찬 on 2023/09/22.
//

import Foundation

class PaymentViewModel: ObservableObject {
    //받아오고
    @Published var user: User = User.dummyUser
    @Published var product: Productable = auctionProduct
    //업로드
    @Published var paymentInfo: PaymentInfo
    
    init(user: User, product: Productable) {
        paymentInfo = PaymentInfo(
            product: product.id,
            address: user.address,
            deliveryRequest: "",
            deliveryCost: 3000,
            paymentMethod: PaymentMethod.accountTransfer)
    }
    
    func uploadPaymentInfo() {
        //파베에 업로드
    }
     
}

let auctionProduct = AuctionProduct(
    id: "1",
    productName: "Example Product",
    productImageURLStrings: ["https://dimg.donga.com/wps/NEWS/IMAGE/2021/12/11/110733453.1.jpg"],
    description: "This is an example product for auction.",
    influencerID: "상필갓",
    winningUserID: nil, // 낙찰자가 아직 없는 경우 nil로 설정
    startDate: Date(), // 현재 날짜로 설정
    endDate: Date().addingTimeInterval(7 * 24 * 60 * 60), // 현재 날짜로부터 7일 후로 설정
    minPrice: 100, // 시작가
    maxPrice: 500, // 최고가
    winningPrice: 100000 // 낙찰가는 아직 결정되지 않았으므로 0으로 설정
)
