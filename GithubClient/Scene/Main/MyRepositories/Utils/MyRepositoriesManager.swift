//
//  MyRepositoriesManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Combine
import Foundation

protocol MyRepositoriesManagerInput {
    func fetchRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], Error>
    func loadCachedRepositories() -> [Repository]
}

final class MyRepositoriesManager: MyRepositoriesManagerInput {
    
    private let defaultsStorageManager: DefaultsStorageManagerInput
    private let networkManager: NetworkManagerInput
    
    init(
        defaultsStorageManager: DefaultsStorageManagerInput,
        networkManager: NetworkManagerInput
    ) {
        self.defaultsStorageManager = defaultsStorageManager
        self.networkManager = networkManager
    }
    
    func fetchRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], Error> {
        let request = MyRepositoriesRequest(page: page, perPage: perPage)

        return networkManager.requestPublisher(request)
            .map({ $0.map({ Repository(dto: $0) }) })
            .handleEvents(receiveOutput: { [weak self] repos in
                guard let self else { return }
                try? self.defaultsStorageManager.setObject(repos, for: .myRepositoriesCache)
            })
            .eraseToAnyPublisher()
    }

    func loadCachedRepositories() -> [Repository] {
        (try? defaultsStorageManager.getObject([Repository].self, for: .myRepositoriesCache)) ?? []
    }
}
