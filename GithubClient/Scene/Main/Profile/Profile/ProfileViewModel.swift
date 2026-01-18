//
//  ProfileViewModel.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import Foundation
import UIKit

@Observable
final class ProfileViewModel {
    var appState: AppState? = nil
    var avatarImage: UIImage?
    var username: String = ""
    
    private let avatarPath: String = "user/avatar.jpg"
    
    private let keychainManager: KeychainManagerInput
    private let defaultsManager: DefaultsStorageManagerInput
    private let fileStorageManager: FileStorageManager

    
    init(
        keychainManager: KeychainManagerInput,
        defaultsManager: DefaultsStorageManagerInput,
        fileStorageManager: FileStorageManager
    ) {
        self.keychainManager = keychainManager
        self.defaultsManager = defaultsManager
        self.fileStorageManager = fileStorageManager
    }
    
    func loadInitialData() {
        loadAvatar()
        getUsername()
    }
    
    func setAvatar(_ data: Data) async {
        guard let uiImage = UIImage(data: data) else { return }
        guard let jpeg = uiImage.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try await fileStorageManager.saveData(jpeg, at: avatarPath)
            defaultsManager.set(avatarPath, for: .profilePictureFileName)
            avatarImage = uiImage
        } catch {
            print("Saving avatar imae failed:", error)
        }
    }
    
    private func loadAvatar() {
        guard let path: String = defaultsManager.string(for: .profilePictureFileName) else { return }

        Task {
            let data = try await fileStorageManager.loadData(from: path)
            avatarImage = UIImage(data: data)
        }
    }
    
    private func getUsername() {
        username = defaultsManager.string(for: .currentUserUsername) ?? ""
    }
    
    func logOut() {
        try? keychainManager.deleteCredentials()
        
        if let path = defaultsManager.string(for: .profilePictureFileName) {
            Task {
                try? await fileStorageManager.delete(path: path)
            }
        }
        
        defaultsManager.clear()
        
        appState?.appFlow = .login
    }
}
