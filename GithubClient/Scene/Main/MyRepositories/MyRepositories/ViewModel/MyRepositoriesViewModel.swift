//
//  MyRepositoriesViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 18.01.26.
//

import Combine
import Foundation

@Observable
final class MyRepositoriesViewModel {
    enum Loading { case initial, refresh, more, none }
    
    var repositories: [Repository] = []
    var loadingState: Loading = .none
    var refreshedCount: Int = 0
    private var currentPage = 1
    private let perPage = 10
    private var moreItemsRemaining = true
    private var itemsLoadedCount: Int?
    private var cancellables = Set<AnyCancellable>()
    private let myRepositoriesManager: MyRepositoriesManagerInput
    
    init(myRepositoriesManager: MyRepositoriesManagerInput) {
        self.myRepositoriesManager = myRepositoriesManager
    }
    
    // MARK: - Public Methods
    func loadInitialRepositories() {
        currentPage = 1
        fetchRepositories(page: currentPage, loadingState: .initial)
    }
    
    func refreshRepositories() async {
        currentPage = 1
        itemsLoadedCount = nil
        await refreshRepositories(page: currentPage)
    }
    
    func loadMoreRepositoriesIfNeeded(index: Int) {
        guard loadingState == .none else { return }
        guard let itemsLoadedCount = itemsLoadedCount,
              thresholdMeet(itemsLoadedCount, index),
              moreItemsRemaining
        else {
            return
        }
        
        currentPage += 1
        fetchRepositories(page: currentPage)
    }
    
    // MARK: - Private Methods
    // Default fetch
    private func fetchRepositories(page: Int, loadingState: Loading = .more) {
        self.loadingState = loadingState

        myRepositoriesManager.fetchRepositories(page: page, perPage: perPage)
            .sink { [weak self] result in
                DispatchQueue.main.async { self?.loadingState = .none }
                    switch result {
                    case .finished: break
                    case .failure:
                        guard let self else { return }
                        guard self.repositories.isEmpty else { return }
                        DispatchQueue.main.async {
                            self.repositories = self.myRepositoriesManager.loadCachedRepositories()
                            // Show error if needed
                        }
                    }
            } receiveValue: { [weak self] newRepos in
                guard let self else { return }
                DispatchQueue.main.async {
                    guard !newRepos.isEmpty else {
                        self.moreItemsRemaining = false
                        return
                    }
                    if loadingState == .refresh || loadingState == .initial { self.repositories.removeAll() }
                    self.moreItemsRemaining = newRepos.count == self.perPage
                    self.repositories.append(contentsOf: newRepos)
                    self.repositories = self.setIndexToRepositories(to: self.repositories)
                    self.itemsLoadedCount = self.repositories.count
                    self.loadingState = .none
                }
            }
            .store(in: &cancellables)
    }
    
    // Fetch with minimum duration
    private func refreshRepositories(page: Int) async {
        let minSeconds: Double = 1.0
        let start = Date()
        loadingState = .refresh

        await withCheckedContinuation { continuation in
            myRepositoriesManager.fetchRepositories(page: page, perPage: perPage)
                .sink { [weak self] result in
                    switch result {
                    case .finished: break
                    case .failure:
                        guard let self else { return }
                        DispatchQueue.main.async {
                            self.loadingState = .none
                            guard self.repositories.isEmpty else { return }
                            self.repositories = self.myRepositoriesManager.loadCachedRepositories()
                        }
                    }
                    continuation.resume()
                } receiveValue: { [weak self] newRepos in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.moreItemsRemaining = true
                        self.repositories.removeAll()
                        
                        guard !newRepos.isEmpty else {
                            self.loadingState = .none
                            self.moreItemsRemaining = false
                            return
                        }
                        
                        self.moreItemsRemaining = (newRepos.count == self.perPage)
                        self.repositories.append(contentsOf: newRepos)
                        self.repositories = self.setIndexToRepositories(to: self.repositories)
                        self.itemsLoadedCount = self.repositories.count
                        self.loadingState = .none
                    }
                }
                .store(in: &cancellables)
        }

        // Make rrefreshable spinner visable minimum 1 second
        let currentDuration = Date().timeIntervalSince(start)
        if currentDuration < minSeconds {
            let remainingTime = UInt64((minSeconds - currentDuration) * 1_000_000_000)
            try? await Task.sleep(nanoseconds: remainingTime)
            await MainActor.run { refreshedCount += 1 }
        }
    }
    
    private func setIndexToRepositories(to repositories: [Repository]) -> [Repository] {
        guard !repositories.isEmpty else { return [] }
        var indexedRepositories = repositories
        for i in 0..<repositories.count {
            indexedRepositories[i].index = i
        }
        return indexedRepositories
    }
    
    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        return itemsLoadedCount == index + 1
    }
}
