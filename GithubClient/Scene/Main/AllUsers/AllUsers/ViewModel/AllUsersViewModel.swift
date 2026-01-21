//
//  AllUsersViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 20.01.26.
//

import Foundation

@Observable
final class AllUsersViewModel {
    enum Loading { case initial, refresh, more, none }
    
    var allUsers: [User] = []
    var loadingState: Loading = .none { didSet { print(loadingState) } }
    let allUsersManager: AllUsersManagerInput
    private var lastUserID: Int? = nil
    private let perPage = 30
    private var moreItemsRemaining = true
    private var itemsLoadedCount: Int? = nil
    
    init(allUsersManager: AllUsersManagerInput) {
        self.allUsersManager = allUsersManager
    }
    
    // MARK: - Public Methods
    func loadInitialUsers() {
        Task { @MainActor in
            await fetchUsers(since: nil, loadingState: .initial)
        }
    }
    
    @MainActor
    func refreshUsers() async {
        lastUserID = nil
        itemsLoadedCount = nil
        await fetchUsers(since: lastUserID, loadingState: .refresh)
    }
    
    func loadMoreUsersIfNeeded(index: Int) {
        guard loadingState == .none else { return }
        guard let itemsLoadedCount = itemsLoadedCount,
              thresholdMeet(itemsLoadedCount, index),
              moreItemsRemaining
        else {
            return
        }
        
        lastUserID = allUsers.last?.id
        Task { @MainActor in
            await fetchUsers(since: lastUserID, loadingState: .more)
        }
    }
    
    // MARK: - Private Methods
    private func fetchUsers(since: Int?,  loadingState: Loading = .more) async {
        let minSeconds: Double = 1.0
        let start = Date()
        
        self.loadingState = loadingState
        defer { self.loadingState = .none }
        
        do {
            let newUsers = try await allUsersManager.fetchUsers(since: since, perPage: perPage)
            guard !newUsers.isEmpty else {
                self.moreItemsRemaining = false
                return
            }
            
            // Manual delay at least 1 second
            let currentDuration = Date().timeIntervalSince(start)
            if currentDuration < minSeconds {
                let remainingTime = UInt64((minSeconds - currentDuration) * 1_000_000_000)
                try? await Task.sleep(nanoseconds: remainingTime)
            }
            
            if loadingState == .refresh || loadingState == .initial { self.allUsers.removeAll() }
            self.moreItemsRemaining = newUsers.count == self.perPage
            self.allUsers.append(contentsOf: newUsers)
            self.allUsers = self.setIndexToUsers(to: self.allUsers)
            self.itemsLoadedCount = self.allUsers.count
        } catch {
            guard allUsers.isEmpty else { return }
            allUsers = allUsersManager.loadCachedUsers()
        }
    }
    
    private func setIndexToUsers(to users: [User]) -> [User] {
        guard !users.isEmpty else { return [] }
        var indexedRepositories = users
        for i in 0..<users.count {
            indexedRepositories[i].index = i
        }
        return indexedRepositories
    }
    
    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        return itemsLoadedCount == index + 1
    }
}
