//
//  MyRepositorycell.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import SwiftUI

struct MyRepositorycell: View {
    @State private var isExpanded: Bool = false
    let repository: Repository
    
    var body: some View {
        VStack(spacing: R.Offsets.commonMinus) {
            header
            repositoryName
            
            if isExpanded {
                secondaryInfo
            }
        }
        .padding()
        .clipped()
        .background {
            RoundedRectangle(cornerRadius: R.Corners.regular)
                .fill(.bgSecondary)
                .shadow(color: .brandMainPurple.opacity(0.08),
                        radius: R.Corners.small)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
        }
    }
    
    private var header: some View {
        HStack {
            RemoteImage(
                urlString: repository.owner.avatarUrl ?? "",
                clipShape: .circle)
            .frame(height: R.Images.small)
            
            Text(repository.owner.login)
                .font(.callout)
                .foregroundStyle(.textPrimary)

            Spacer()

            Image(systemName: "chevron.down")
                .font(.body)
                .foregroundStyle(.brandMainPurple)
                .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
        }
    }
    
    private var repositoryName: some View {
        Text(repository.name)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var secondaryInfo: some View {
        HStack(alignment: repository.language == nil ? .center : .top) {
            VStack(alignment: .leading) {
                if let language = repository.language {
                    Text("Language: \(language)")
                        .font(.footnote)
                        .foregroundStyle(.textSecondary)
                }
                
                Text("Last update: \(repository.updatedAt.toString("MMM d, yyyy"))")
                    .font(.footnote)
                    .foregroundStyle(.textSecondary)
            }
            
            Spacer(minLength: 0)
            
            Text(repository.privacyType.title)
                .font(.caption2)
                .foregroundStyle(.white)
                .padding(.horizontal, R.Offsets.commonMinus)
                .padding(.vertical, R.Offsets.extraSmall)
                .background {
                    Capsule().fill(repository.privacyType.color)
                }
        }
        .padding(.horizontal)
        .padding(.vertical, R.Offsets.commonMinus)
        .background {
            RoundedRectangle(cornerRadius: R.Corners.small)
                .fill(.bgPrimary)
                .stroke(.brandMainPurple.opacity(0.6))
        }
    }
}

#Preview {
    MyRepositorycell(repository:
                        Repository(
                            id: 1,
                            name: "MyRepo",
                            privacyType: .publicRepo,
                            language: "Swift",
                            updatedAt: Date(),
                            owner: RepositoryOwner(
                                login: "Karen",
                                avatarUrl: ""),
                            index: 0))
}
