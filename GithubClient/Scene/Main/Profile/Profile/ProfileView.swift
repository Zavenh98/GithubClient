//
//  ProfileView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var isSownLogOutAlert: Bool = false
    @State private var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Spacer()
                
                Button {
                    isSownLogOutAlert.toggle()
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
                .padding(.bottom, 32)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.bgPrimary)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.appState = self.appState
            }
            .alert("Are you shure you want to log out?", isPresented: $isSownLogOutAlert, actions: {
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

#Preview {
    ProfileView(
        viewModel: ProfileViewModel(keychainmanager: KeychainManager()))
    .environment(AppState(isAuthenticated: true))
}
