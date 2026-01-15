//
//  AllUsersView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct AllUsersView: View {
    var body: some View {
        NavigationStack {
            Color.blue.opacity(0.3)
                .ignoresSafeArea()
                .navigationTitle("All Users")
        }
    }
}

#Preview {
    AllUsersView()
}
