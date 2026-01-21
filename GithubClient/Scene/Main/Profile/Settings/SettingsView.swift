//
//  SettingsView.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 15.01.26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") var appTheme = AppTheme.system
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose preferred interface style")
                .font(.subheadline)
                .foregroundStyle(.textPrimary)
            
            Picker("Choose your preferred user interface style", selection: $appTheme) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Text(theme.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.bgPrimary)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
