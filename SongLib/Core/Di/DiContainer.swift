//
//  DiContainer.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import Swinject

final class DiContainer {
    static let shared = DiContainer()
    let container: Container

    private init() {
        container = Container()
        DependencyMap.registerDependencies(in: container)
        validateDependencies()
    }

    private func validateDependencies() {
        let dependencies: [() -> Any?] = [
            { self.container.resolve(AnalyticsServiceProtocol.self) },
            { self.container.resolve(LoggerProtocol.self) },
            { self.container.resolve(ApiServiceProtocol.self) },
            { self.container.resolve(NetworkUtils.self) },
            { self.container.resolve(CoreDataManager.self) },
            { self.container.resolve(BookDataManager.self) },
            { self.container.resolve(SongDataManager.self) },
            { self.container.resolve(ListingDataManager.self) },
            { self.container.resolve(SearchDataManager.self) },
            { self.container.resolve(HistoryDataManager.self) },
            { self.container.resolve(DraftDataManager.self) },
            { self.container.resolve(PrefsRepo.self) },
            { self.container.resolve(SongBookRepoProtocol.self) },
            { self.container.resolve(ListingRepoProtocol.self) },
            { self.container.resolve(SubsRepoProtocol.self) },
            { self.container.resolve(TrackingRepoProtocol.self) },
            { self.container.resolve(ReviewReqRepoProtocol.self) },
            { self.container.resolve(DraftRepoProtocol.self) },
            { self.container.resolve(DraftsViewModel.self) },
            { self.container.resolve(SplashViewModel.self) },
            { self.container.resolve(SelectionViewModel.self) },
            { self.container.resolve(MainViewModel.self) },
            { self.container.resolve(ListingViewModel.self) },
        ]

        for resolve in dependencies {
            guard resolve() != nil else {
                fatalError("One or more dependencies are not registered in the container.")
            }
        }
        print("All dependencies are successfully registered.")
    }
}

extension DiContainer {
    func resolve<T>(_ type: T.Type) -> T {
        guard let dependency = container.resolve(type) else {
            fatalError("Failed to resolve dependency: \(type)")
        }
        return dependency
    }

    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        guard let dependency = container.resolve(type, argument: argument) else {
            fatalError("Failed to resolve dependency: \(type) with argument: \(argument)")
        }
        return dependency
    }
}
