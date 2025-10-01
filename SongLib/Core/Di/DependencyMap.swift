//
//  DependencyMap.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(PreferencesRepository.self) { _ in
            PreferencesRepository()
        }.inObjectScope(.container)

        container.register(CoreDataManager.self) { _ in
            CoreDataManager.shared
        }.inObjectScope(.container)
        
        container.register(ApiServiceProtocol.self) { _ in
            ApiService()
        }.inObjectScope(.container)

        container.register(AnalyticsServiceProtocol.self) { _ in
            AnalyticsService()
        }.inObjectScope(.container)

        container.register(LoggerProtocol.self) { _ in
            Logger()
        }.inObjectScope(.container)
        
        container.register(BookDataManager.self) { resolver in
            BookDataManager(cdManager: resolver.resolve(CoreDataManager.self)!)
        }.inObjectScope(.container)
        
        container.register(SongDataManager.self) { resolver in
            SongDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
                bdManager: resolver.resolve(BookDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ListingDataManager.self) { resolver in
            ListingDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SearchDataManager.self) { resolver in
            SearchDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(HistoryDataManager.self) { resolver in
            HistoryDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongBookRepositoryProtocol.self) { resolver in
            SongBookRepository(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                bookData: resolver.resolve(BookDataManager.self)!,
                songData: resolver.resolve(SongDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ListingRepositoryProtocol.self) { resolver in
            ListingRepository(
                listData: resolver.resolve(ListingDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SubscriptionRepositoryProtocol.self) { resolver in
            SubscriptionRepository()
        }.inObjectScope(.container)
        
        container.register(TrackingRepositoryProtocol.self) { resolver in
            TrackingRepository(
                historyData: resolver.resolve(HistoryDataManager.self)!,
                searchData: resolver.resolve(SearchDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ReviewReqRepositoryProtocol.self) { resolver in
            ReviewReqRepository(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SelectionViewModel.self) { resolver in
            SelectionViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(MainViewModel.self) { resolver in
            MainViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
                listingRepo: resolver.resolve(ListingRepositoryProtocol.self)!,
                reviewRepo: resolver.resolve(ReviewReqRepositoryProtocol.self)!,
                subsRepo: resolver.resolve(SubscriptionRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ListingViewModel.self) { resolver in
            ListingViewModel(
                prefsRepo: resolver.resolve(PreferencesRepository.self)!,
                songbkRepo: resolver.resolve(SongBookRepositoryProtocol.self)!,
                listRepo: resolver.resolve(ListingRepositoryProtocol.self)!,
                subsRepo: resolver.resolve(SubscriptionRepositoryProtocol.self)!,
            )
        }.inObjectScope(.container)
        
    }
}
