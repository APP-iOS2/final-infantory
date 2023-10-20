//
//  ApplyLotteryStore.swift
//  InfantoryAdmin
//
//  Created by 변상필 on 10/19/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ApplyLotteryStore: ObservableObject {
    @Published var applyLotteries: [ApplyProduct] = []
    @Published var selectedCatogory: ApplyCloseFilter = .beforeRaffle
    private let dbRef = Firestore.firestore().collection("ApplyProducts")
    
    func fetchApplyProduct() async throws {
        let snapshot = try await dbRef.whereField("endDate", isLessThan: Date()).getDocuments()
        
        var product = snapshot.documents.compactMap { try? $0.data(as: ApplyProduct.self) }
        
        product = product.filter({ product in
            product.winningUserID == nil
        })
        
        
        await updateApplyLotteriesProduct(product)
    }
    
    @MainActor
    private func updateApplyLotteriesProduct(_ applyLotteries: [ApplyProduct]) {
        self.applyLotteries = applyLotteries
        
    }
    
    func addWinningUser(product: ApplyProduct) {
        let documentReference = Firestore.firestore().collection("ApplyProducts").document(product.id ?? "")
       
        documentReference.updateData(["winningUserID": product.winningUserID ?? "응모자 없음"]) { (error) in
            if error != nil {
            
            } else {
                Task {
                    try await self.fetchApplyProduct()
                }
            }
        }
        
    }
    
    func lotteryApply() {
        for var product in applyLotteries {
            if let winningUser = product.applyUserIDs.randomElement() {
                product.winningUserID = winningUser
                self.addWinningUser(product: product)
            } else {
                self.addWinningUser(product: product)
                print("응모자가 없습니다.")
            }
        }
    }
}