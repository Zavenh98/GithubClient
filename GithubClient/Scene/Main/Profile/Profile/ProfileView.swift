//
//  ProfileView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import PhotosUI
import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var isShownLogOutAlert: Bool = false
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .onLoad(perform: {
                    viewModel.appState = self.appState
                    viewModel.loadInitialData()
                })
                .alert("Are you shure you want to log out?", isPresented: $isShownLogOutAlert, actions: {
                    Button("No", role: .cancel, action: {})
                    Button("Yes", role: .destructive, action: {
                        viewModel.logOut()
                    })
                }, message: {
                    Text("All your cached data will be deleted when you log out.")
                })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
        }
    }
}

// MARK: - Components
extension ProfileView {
    private var content: some View {
        VStack(spacing: 16) {
            profilePicture
            VStack(spacing: 0) {
                username
                Spacer(minLength: 0)
                logoutButton
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 32)
        .background(.bgPrimary)
    }
    
    private var profilePicture: some View {
        PhotosPicker(selection: $avatarItem, matching: .images) {
            Group {
                if let uiImage = viewModel.avatarImage {
                    Image(uiImage: uiImage)
                        .fitToAspectRatio()
                } else {
                    Image(.avatarPlaceholder)
                        .fitToAspectRatio()
                }
            }
            .frame(maxWidth: horizontalSizeClass == .compact ? 200 : 400)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.15), radius: 5)
        }
        .onChange(of: avatarItem) {
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    await viewModel.setAvatar(data)
                }
            }
        }
    }
    
    private var username: some View {
        Text(viewModel.username)
            .font(horizontalSizeClass == .compact ? .title.bold() : .largeTitle.bold())
            .foregroundStyle(.textPrimary)
    }
    
    private var logoutButton: some View {
        HStack {
            Button {
                isShownLogOutAlert.toggle()
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.largeTitle.bold())
                        .rotationEffect(Angle(degrees: 180))
                        .foregroundStyle(.brandMainPurple)
                    
                    Text("Log out")
                        .font(.title3.bold())
                        .foregroundStyle(.textPrimary)
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ProfileView(
        viewModel: ProfileViewModel(
            keychainManager: KeychainManager(),
            defaultsManager: DefaultsStorageManager(),
            fileStorageManager: FileStorageManager()))
    .environment(AppState(isAuthenticated: true))
}
