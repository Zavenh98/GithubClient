//
//  AllUsersView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct AllUsersView: View {
    @State private var viewModel: AllUsersViewModel
    
    init (viewModel: AllUsersViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .background(.bgPrimary)
                .navigationTitle("All Users")
                .navigationBarTitleDisplayMode(.large)
                .onLoad {
                    viewModel.loadInitialUsers()
                }
                .navigationDestination(for: User.self) { user in
                    UserDetaisView(
                        viewModel: UserDetaisViewModel(
                            user: user,
                            allUsersManager: viewModel.allUsersManager))
                }
        }
    }
}

// MARK: - Components
extension AllUsersView {
    @ViewBuilder
    private var content: some View {
        if viewModel.loadingState == .initial {
            ProgressView()
                .scaleEffect(1.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.allUsers.isEmpty {
            NothingFoundView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            listContent
        }
    }
    
    @ViewBuilder
    private var listContent: some View {
        List {
            Section {
                ForEach(viewModel.allUsers) { user in
                    NavigationLink(value: user) {
                        HStack(spacing: R.Sizes.Offsets.Horizontal.regular) {
                            RemoteImage(urlString: user.avatarUrl ?? "", clipShape: .circle)
                                .frame(height: R.Sizes.Images.regular)
                            Text(user.login)
                                .font(.body.bold())
                        }
                    }
                    .onAppear(perform: {
                        viewModel.loadMoreUsersIfNeeded(index: user.index)
                    })
                }
            } footer: {
                ActivityIndicatorView(isAnimating: viewModel.loadingState == .more)
                    .scaleEffect(0.8)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .listRowBackground(Color.bgSecondary)
        }
        .scrollContentBackground(.hidden)
        .background(Color.bgPrimary)
        .refreshable {
            await viewModel.refreshUsers()
        }
    }
}

#Preview {
    AllUsersView(
        viewModel: AllUsersViewModel(
            allUsersManager: AllUsersManager(
                defaultsStorsageManager: DefaultsStorageManager(),
                networkManager: NetworkManager(
                    keychainManager: KeychainManager(),
                    reachablityManager: ReachabilityManager()
                )
            )
        )
    )
}
