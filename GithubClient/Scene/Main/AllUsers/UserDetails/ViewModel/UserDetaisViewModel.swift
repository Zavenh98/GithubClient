//
//  UserDetaisViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 21.01.26.
//

import Foundation

@MainActor
@Observable
final class UserDetaisViewModel {
    let user: User
    var repositories: [Repository] = []
    var isLoading: Bool = false
    var errorMessage: String?
    private let allUsersManager: AllUsersManagerInput
    
    init(user: User, allUsersManager: AllUsersManagerInput) {
        self.user = user
        self.allUsersManager = allUsersManager
    }
    
    func fetchRepos() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        self.errorMessage = nil
        do {
            self.repositories = try await allUsersManager.fetchUserRepos(username: user.login)
        } catch {
            guard let error = error as? LocalizedError else {
                print(error.localizedDescription)
                self.errorMessage = "Unable to load user's repositories"
                return
            }
            self.errorMessage = error.errorDescription
        }
    }
}
