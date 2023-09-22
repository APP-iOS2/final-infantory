//
//  User.swift
//  Infantory
//
//  Created by 윤경환 on 2023/09/22.
//

import Foundation

struct User: Identifiable {
    var id: String
    var isInfluencer: UserType = .user // influencer인지 일반 User인지?
    var profileImageURLString: String?
    var name: String
    var phoneNumber: String
    var email: String
    var birthDate: String
    
    var loginType: LoginType
    var address: Address
    var paymentInfos: [PaymentInfo]
    
    var follower: [String]? = nil
    var applyTicket: [ApplyTicket]
    var influencerIntroduce: String?
}

// 상세주소
struct Address {
    var fullAddress: String
}

// 소셜로그인 타입
enum LoginType: String {
    case kakao
    case apple
    
}

enum UserType: String, Codable {
    case user
    case influencer
}

enum PaymentMethod: String, CaseIterable {
    case card
    case accountTransfer
    case naverPay
    case kakaoPay
    case tossPay
}

#if DEBUG
extension User {
    static let dummyUser = User(
        id: "1",
        isInfluencer: .user,
        profileImageURLString: "https://example.com/profile/1.jpg",
        name: "John Doe",
        phoneNumber: "123-456-7890",
        email: "john@example.com",
        birthDate: "1990-01-01",
        loginType: .kakao,
        address: Address(fullAddress: "123 Main Street, City"),
        paymentInfos: [
            PaymentInfo(
                product: "Product 1",
                deliveryRequest: "Please deliver to my home.",
                price: 50,
                commission: 5,
                deliveryCost: 10,
                paymentMethod: .card
            ),
            PaymentInfo(
                product: "Product 2",
                deliveryRequest: "Leave at the front desk.",
                price: 30,
                commission: 3,
                deliveryCost: 5,
                paymentMethod: .accountTransfer
            )
        ],
        applyTicket: [
            ApplyTicket(
                id: "ticket1",
                userId: "john@example.com",
                date: Date(),
                ticketGetAndUse: "Ticket 123",
                count: 2
            ),
            ApplyTicket(
                id: "ticket2",
                userId: "john@example.com",
                date: Date(),
                ticketGetAndUse: "Ticket 456",
                count: 1
            )
        ],
        influencerIntroduce: nil
    )
}
#endif
