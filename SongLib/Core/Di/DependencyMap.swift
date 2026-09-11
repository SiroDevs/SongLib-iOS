//
//  DependencyMap.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

struct DependencyMap {
    static func registerDependencies(in container: Container) {
        container.register(PrefsRepo.self) { _ in
            PrefsRepo()
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
        
        container.register(NetworkUtils.self) { _ in
            NetworkUtils.shared
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
        
        container.register(DraftDataManager.self) { resolver in
            DraftDataManager(
                cdManager: resolver.resolve(CoreDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SongBookRepoProtocol.self) { resolver in
            SongBookRepo(
                apiService: resolver.resolve(ApiServiceProtocol.self)!,
                bookData: resolver.resolve(BookDataManager.self)!,
                songData: resolver.resolve(SongDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ListingRepoProtocol.self) { resolver in
            ListingRepo(
                listData: resolver.resolve(ListingDataManager.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SubsRepoProtocol.self) { resolver in
            SubsRepo()
        }.inObjectScope(.container)
        
        container.register(TrackingRepoProtocol.self) { resolver in
            TrackingRepo(
                historyData: resolver.resolve(HistoryDataManager.self)!,
                searchData: resolver.resolve(SearchDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ReviewReqRepoProtocol.self) { resolver in
            ReviewReqRepo(
                prefsRepo: resolver.resolve(PrefsRepo.self)!
            )
        }.inObjectScope(.container)
        
        container.register(DraftRepoProtocol.self) { resolver in
            DraftRepo(
                draftData: resolver.resolve(DraftDataManager.self)!
            )
        }.inObjectScope(.container)
        
        container.register(DraftsViewModel.self) { resolver in
            DraftsViewModel(
                draftRepo: resolver.resolve(DraftRepoProtocol.self)!
            )
        }.inObjectScope(.container)
        
        container.register(DraftEditorViewModel.self) { (resolver, draft: Draft?) in
            DraftEditorViewModel(
                draftRepo: resolver.resolve(DraftRepoProtocol.self)!,
                draft: draft
            )
        }
        
        container.register(SelectionViewModel.self) { resolver in
            SelectionViewModel(
                netUtils: resolver.resolve(NetworkUtils.self)!,
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                songbkRepo: resolver.resolve(SongBookRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(SplashViewModel.self) { resolver in
            SplashViewModel(
                netUtils: resolver.resolve(NetworkUtils.self)!,
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(MainViewModel.self) { resolver in
            MainViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                songbkRepo: resolver.resolve(SongBookRepoProtocol.self)!,
                listingRepo: resolver.resolve(ListingRepoProtocol.self)!,
                reviewRepo: resolver.resolve(ReviewReqRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
        container.register(ListingViewModel.self) { resolver in
            ListingViewModel(
                prefsRepo: resolver.resolve(PrefsRepo.self)!,
                songbkRepo: resolver.resolve(SongBookRepoProtocol.self)!,
                listRepo: resolver.resolve(ListingRepoProtocol.self)!,
                subsRepo: resolver.resolve(SubsRepoProtocol.self)!,
                draftRepo: resolver.resolve(DraftRepoProtocol.self)!,
            )
        }.inObjectScope(.container)
        
    }
}
