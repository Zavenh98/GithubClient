//
//  MyRepositoriesView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct MyRepositoriesView: View {
    private let topAnchorID = "top"
    @State private var viewModel: MyRepositoriesViewModel
    
    init (viewModel: MyRepositoriesViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            content
                .background(.bgPrimary)
                .navigationTitle("My Repositories")
                .navigationBarTitleDisplayMode(.large)
                .onLoad {
                    viewModel.loadInitialRepositories()
                }
        }
    }
}

// MARK: - Components
extension MyRepositoriesView {
    @ViewBuilder
    private var content: some View {
        if viewModel.loadingState == .initial {
            progressView
        } else if viewModel.repositories.isEmpty {
            NothingFoundView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            listContent
        }
    }
    
    private var listContent: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: R.Offsets.commonMinus) {
                    ForEach(viewModel.repositories) { repo in
                        MyRepositorycell(repository: repo)
                            .onAppear { viewModel.loadMoreRepositoriesIfNeeded(
                                index: repo.index)
                            }
                    }
                }
                .id(topAnchorID)
                .padding()
                if viewModel.loadingState == .more {
                    progressView
                }
            }
            .onChange(of: viewModel.refreshedCount) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        proxy.scrollTo(topAnchorID, anchor: .top)
                    }
                }
            }
            .refreshable {
                await viewModel.refreshRepositories()
            }
        }
    }
    
    private var progressView: some View {
        ProgressView()
            .foregroundStyle(.brandMainPurple)
            .scaleEffect(1.6)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MyRepositoriesView(
        viewModel: MyRepositoriesViewModel(
            myRepositoriesManager: MyRepositoriesManager(
            defaultsStorageManager: DefaultsStorageManager(), networkManager: NetworkManager(
                    keychainManager: KeychainManager(),
                    reachablityManager: ReachabilityManager()
                )
            )
        )
    )
}
