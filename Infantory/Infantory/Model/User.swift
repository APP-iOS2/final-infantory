//
//  User.swift
//  Infantory
//
//  Created by 윤경환 on 2023/09/22.
//

import Foundation

struct User {
    var id: String
    var isInfluencer: UserType // influencer인지 일반 User인지?
    var profileImageURLString: String?
    var name: String
    var phoneNumber: String
    var email: String
    
    var loginType: LoginType
    var address: Address
    var paymentInfos: [PaymentsInfo]
}

// 상세주소
struct Address {
    
}

// 소셜로그인 타입
enum LoginType: String {
    case kakao
    case apple
    
}

enum UserType {
    case user
    case influencer
}
