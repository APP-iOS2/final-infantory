//
//  CachedImageManager.swift
//  Infantory
//
//  Created by 김성훈 on 2023/10/11.
//

import Foundation

final class CachedImageManager: ObservableObject {
    
    @Published private(set) var currentState: CurrentState?
    
    private let imageRetriver = ImageRetriver()
    
    @MainActor
    private func updateState(_ state: CurrentState) {
        self.currentState = state
    }
    
    func load(_ imgUrl: String,
              cache: ImageCache = .shared) async {

        await updateState(.loading)
        
        if let imageData = cache.get(forkey: imgUrl as NSString) {
            await updateState(.success(data: imageData))
            return
        }
        
        do {
            let data = try await imageRetriver.fetch(imgUrl)
            await updateState(.success(data: data))
            cache.set(object: data as NSData,
                      forKey: imgUrl as NSString)
        } catch {
            await updateState(.failed(error: error))
        }
    }
}

extension CachedImageManager {
    enum CurrentState {
        case loading
        case failed(error: Error)
        case success(data: Data)
    }
}

extension CachedImageManager.CurrentState: Equatable {
    static func == (lhs: CachedImageManager.CurrentState,
                    rhs: CachedImageManager.CurrentState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (let .failed(lhsError), let .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .success(lhsData), let .success(rhsData)):
            return lhsData == rhsData
        default:
            return false
        }
    }
}
