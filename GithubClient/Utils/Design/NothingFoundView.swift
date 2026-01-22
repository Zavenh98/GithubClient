//
//  NothingFoundView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import SwiftUI

struct NothingFoundView: View {
    private let text: String
    
    init(text: String = "Nothing found") {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.title)
            .foregroundStyle(.textPrimary)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    NothingFoundView()
}
