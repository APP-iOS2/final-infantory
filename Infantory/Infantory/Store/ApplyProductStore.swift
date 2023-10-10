//
//  AuctionProductViewModel.swift
//  Infantory
//
//  Created by 봉주헌 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ApplyProductStore: ObservableObject {
    
    @Published var applyProduct: [ApplyProduct] = []
    @Published var selectedFilter: ApplyFilter = .inProgress
    @Published var filteredProduct: [ApplyProduct] = []
    @Published var progressSelectedFilter: ApplyInprogressFilter = .deadline
    func remainingTime(product: ApplyProduct) -> Double {
        return product.endDate.timeIntervalSince(Date())
    }
    
    func startTime(product: ApplyProduct) -> Double {
        return product.startDate.timeIntervalSince(Date())
    }
    //현재 유저 패치작업
    @MainActor
    func fetchApplyProducts() async throws {
        let snapshot = try await Firestore.firestore().collection("ApplyProducts").getDocuments()
        let products = snapshot.documents.compactMap { try? $0.data(as: ApplyProduct.self) }
        
        self.applyProduct = products
        fetchInfluencerProfile(products: products)
    }
    
    @MainActor
    func fetchInfluencerProfile(products: [ApplyProduct]) {
        for product in products {
            let documentReference = Firestore.firestore().collection("Users").document(product.influencerID)
            documentReference.getDocument { (document, error) in
                if let document = document, document.exists {
                    let influencerProfile = document.data()?["profileImageURLString"] as? String? ?? nil
                    if let index = self.applyProduct.firstIndex(where: { $0.id == product.id}) {
                        self.applyProduct[index].influencerProfile = influencerProfile
                        self.updateFilter(filter: .inProgress)
                    }
                } else {
                    #if DEBUG
                    print("인플루언서 프로필이 없습니다")
                    #endif
                }
                
            }
        }
        
    }
    @MainActor
    func updateFilter(filter: ApplyFilter) {
        switch filter {
        case .inProgress:
            selectedFilter = .inProgress
            filteredProduct = applyProduct.filter{
                $0.applyFilter == .inProgress
            }
        case .planned:
            selectedFilter = .planned
            filteredProduct = applyProduct.filter{
                $0.applyFilter == .planned
            }
        case .close:
            selectedFilter = .close
            filteredProduct = applyProduct.filter{
                $0.applyFilter == .close
            }
        }
    }
    @MainActor
    func addApplyTicketUserId(ticketCount: Int,
                              product: ApplyProduct,
                              userID: String,
                              userUID: String,
                              completion: @escaping (ApplyProduct) -> Void) {
        
        let documentReference = Firestore.firestore().collection("ApplyProducts").document(product.id ?? "id 없음")
        documentReference.getDocument { (document, error) in
            if let document = document, document.exists {
                // 문서가 존재하는 경우, 현재 배열 필드 값을 가져옵니다.
                var currentArray = document.data()?["applyUserIDs"] as? [String] ?? []
                // 새 값을 배열에 추가하고 중복된 값도 허용합니다.
                for _ in 1 ... ticketCount {
                    currentArray.append(userID)
                }
                
                // 업데이트된 배열을 Firestore에 다시 업데이트합니다.
                documentReference.updateData(["applyUserIDs": currentArray]) { (error) in
                    if error != nil {
                        #if DEBUG
                        print("Error updating document: (error)")
                        #endif
                    } else {
                        #if DEBUG
                        print("Document successfully updated")
                        #endif
                        Task {
                            try await self.addApplyofUser(ticketCount: ticketCount,
                                                          product: product,
                                                          userUID: userUID,
                                                          database: documentReference) { product in
                                completion(product)
                            }
                        }
                    }
                }
            } else {
                #if DEBUG
                print("Document does not exist")
                #endif
            }
        }
    }
    @MainActor
    func addApplyofUser(ticketCount: Int,
                        product: ApplyProduct,
                        userUID: String,
                        database: DocumentReference,
                        completion: @escaping (ApplyProduct) -> Void) async throws {
        let applyDocument = try await database.getDocument()
        let product = try applyDocument.data(as: ApplyProduct.self)
        let applyTicket = ApplyTicket(date: Date(),
                                      ticketGetAndUse: "\(product.productName) 응모",
                                      count: -ticketCount)
        _ = try Firestore
            .firestore()
            .collection("Users")
            .document(userUID)
            .collection("ApplyTickets")
            .addDocument(from: applyTicket)
        completion(product)
    }
    
}
