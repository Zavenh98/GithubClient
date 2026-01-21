//
//  MyRepositoriesView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct MyRepositoriesView: View {
    
    var body: some View {
        NavigationStack {
            Color.brandMainPurple.opacity(0.3)
                .ignoresSafeArea()
                .navigationTitle("My Repositories")
        }
    }
}

#Preview {
    MyRepositoriesView()
}
