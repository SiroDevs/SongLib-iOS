//
//  SubscriptionRepository.swift
//  SongLib
//
//  Created by Siro Daves on 25/08/2025.
//

import Combine
import RevenueCat

protocol SubscriptionRepositoryProtocol {
    func isProUser(isOnline: Bool, completion: @escaping (Bool) -> Void)
}

final class SubscriptionRepository: SubscriptionRepositoryProtocol {
    func isProUser(isOnline: Bool, completion: @escaping (Bool) -> Void) {
        #if DEBUG
            completion(true)
        #else
        let cachePolicy: CacheFetchPolicy = isOnline ? .fetchCurrent : .fromCacheOnly
            
            Purchases.shared.getCustomerInfo(fetchPolicy: cachePolicy) { customerInfo, error in
                guard let customerInfo = customerInfo, error == nil else {
                    completion(false)
                    return
                }

                let isActive = customerInfo.entitlements[AppConstants.entitlements]?.isActive == true
                completion(isActive)
            }
        #endif
    }
}
