//
//  User.swift
//  Infantory
//
//  Created by 윤경환 on 2023/09/22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var isInfluencer: String // influencer인지 일반 User인지?
    var profileImageURLString: String? = nil
    var name: String
    var phoneNumber: String
    var email: String
    
    var loginType: String
    var address: Address
    
    var follower: [String]? = nil
    var applyTicket: [ApplyTicket]? = nil
    var influencerIntroduce: String? = nil
    
    // address 바꿈, 페이먼트인포랑 벌쓰데이 뺌
}

<<<<<<< HEAD
// 주소
struct Address: Codable {
    var zipCode: String // 우편번호
    var streetAddress: String // 도로명주소
    var detailAddress: String // 상세주소
=======
// 상세주소
struct Address {
    var address: String
    var zonecode: String
    var addressDetail: String
>>>>>>> be94b7d (feat: 주소변경 기능 추가 kakao주소 api연결)
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

enum PaymentMethod: String, CaseIterable, Codable {
    case card
    case accountTransfer
    case naverPay
    case kakaoPay
    case tossPay
}

#if DEBUG
extension User {
    static let dummyUser = User(
        id: "sdoYpk7SdDTcGTxgIQJy",
        isInfluencer: "user",
        profileImageURLString: "https://example.com/profile/1.jpg",
        name: "상필 갓",
        phoneNumber: "123-456-7890",
        email: "john@example.com",
        loginType: "kakao",
        address: Address(zipCode: "33333", streetAddress: "경상남도 거제시", detailAddress: "몽돌해수욕장"),
        applyTicket: [
            ApplyTicket(
                id: "ticket1",
                date: Date(),
                ticketGetAndUse: "Ticket 123",
                count: 2
            ),
            ApplyTicket(
                id: "ticket2",
                date: Date(),
                ticketGetAndUse: "Ticket 456",
                count: 1
            )
        ],
        influencerIntroduce: nil
    )
}
#endif
