//
//  AudioCell.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 26.01.26.
//

import SwiftUI

struct AudioCell: View {
    let audio: AudioFileItem
    
    var body: some View {
        HStack(spacing: R.Offsets.commonMinus) {
            ArtworkImage(image: audio.artwork)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(audio.title ?? audio.fileName)
                    .font(.headline)
                HStack(spacing: 6) {
                    Text(audio.artist ?? "Unknown artist")
                    Circle()
                        .fill(.textDisabled)
                        .frame(width: 6)
                    Text((audio.duration ?? 0).toMinuteSecond())
                }
                .font(.caption)
                .foregroundStyle(.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.textPrimary)
            .lineLimit(1)
        }
    }
}

#Preview {
    AudioCell(
        audio: AudioFileItem(
            url: URL(string: "https://avatars.githubusercontent.com/u/1?v=4")!,
            title: "Title Title Title Title ",
            artist: nil,
            artwork: nil,
            fileSize: "3,5 MB",
            duration: 200)
    )
}
