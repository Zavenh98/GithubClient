//
//  ProfileView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        NavigationStack {
            Color.red.opacity(0.3)
                .navigationTitle("Profile")
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ProfileView()
}
