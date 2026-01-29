//
//  R.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 19.01.26.
//

import Foundation

struct R {
    enum Offsets {
        /// 4
        static let extraSmall: CGFloat = 4
        /// 8
        static let small: CGFloat = 8
        /// 12
        static let commonMinus: CGFloat = 12
        /// 16
        static let common: CGFloat = 16
        /// 20
        static let commonPlus: CGFloat = 20
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
        /// 48
        static let regular: CGFloat = 48
    }
}
