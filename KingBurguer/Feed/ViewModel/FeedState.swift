//
//  FeedState.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 30/07/24.
//

import Foundation

enum FeedState {
    case loading
    case success(FeedResponse)
    case successHighlight(HighlightResponse)
    case error(String)
}
