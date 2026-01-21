//
//  R.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import Foundation

struct R {
    enum Sizes {
        enum Offsets {
            // Horizontal
            enum Horizontal {
                /// 4
                static let extraSmall: CGFloat = 4
                /// 12
                static let small: CGFloat = 12
                /// 24
                static let regular: CGFloat = 24
                /// 32
                static let medium: CGFloat = 32
                /// 48
                static let large: CGFloat = 48
            }
            
            // Vertical
            enum Vertical {
                /// 8
                static let extraSmall: CGFloat = 8
                /// 12
                static let small: CGFloat = 12
                /// 24
                static let regular: CGFloat = 24
                /// 36
                static let medium: CGFloat = 36
                /// 40
                static let large: CGFloat = 40
            }
        }
        
        enum Corners {
            /// 8
            static let small: CGFloat = 8
            /// 16
            static let regular: CGFloat = 16
        }
        
        enum Images {
            /// 32
            static let small: CGFloat = 32
        }
    }
}
