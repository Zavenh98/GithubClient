//
//  UserDetaisView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 20.01.26.
//

import SwiftUI

struct UserDetaisView: View {
    @State private var viewModel: UserDetaisViewModel
    
    init(viewModel: UserDetaisViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geo in
            List {
                Section {
                    PinchPanRemoteImage(
                        urlString: viewModel.user.avatarUrl ?? "",
                        showLoading: true,
                        clipShape: geo.size.width > 500 ? .circle : .square)
                    .frame(maxWidth: .infinity,
                           maxHeight: avatarMaxHeight(in: geo.size))
                    
                    Text(viewModel.user.login)
                        .font(.largeTitle.bold())
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Section("Public Repositories") {
                    ForEach(viewModel.repositories) { repo in
                        VStack(alignment: .leading) {
                            Text(repo.name)
                                .font(.title3.bold())
                                .foregroundStyle(.textPrimary)
                                .padding(.vertical, 4)
                            
                            Text("Last ubdate: \(repo.updatedAt.toString("MMM d, yyyy"))")
                                .font(.subheadline)
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                        } else if viewModel.repositories.isEmpty {
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.headline)
                                    .foregroundStyle(.textError)
                            } else {
                                NothingFoundView(
                                    text: "There is no public repositories for this user.")
                            }
                        }
                    }
                    .padding(32)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listRowBackground(Color.bgSecondary)
            }
            .listStyle(.plain)
            .background(.bgPrimary)
            .navigationTitle("User Details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchRepos()
            }
            .refreshable {
                await viewModel.fetchRepos()
            }
        }
    }
    
    private func avatarMaxHeight(in size: CGSize) -> CGFloat {
        if size.height < 500 {
            return 120
        } else if size.width > 500 {
            return 500
        } else {
            return .infinity
        }
    }
}

#Preview {
    UserDetaisView(
        viewModel: UserDetaisViewModel(
            user: User(
                id: 1,
                login: "mojombo",
                avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4"),
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
