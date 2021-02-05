//
//  SearchData.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation

struct SearchData: Codable {
    let title: String?
    let thumbnailImage: URL?
    let originalImage: URL?
    let docURL: URL?
    
    init(title: String?, thumbnailImage: URL?, originalImage: URL?, docURL: URL?) {
        self.title = title
        self.thumbnailImage = thumbnailImage
        self.originalImage = originalImage
        self.docURL = docURL
    }
    
    static func getSampleData() -> Self {
        Self(
            title: "Smoothy",
            thumbnailImage: URL(string: "https://lh3.googleusercontent.com/C1D8XmEiJFLaWHvoup34B9srKZ71QRhkow3ovuwYvRnzH647r7JO3eJyynS1yr2Lmg"),
            originalImage: URL(string: "https://lh3.googleusercontent.com/C1D8XmEiJFLaWHvoup34B9srKZ71QRhkow3ovuwYvRnzH647r7JO3eJyynS1yr2Lmg"),
            docURL: URL(string: "https://apps.apple.com/us/app/smoothy-video-chat-for-groups/id1325000338")
        )
    }
}

extension SearchData: Equatable {
    static func ==(lhs: SearchData, rhs: SearchData) -> Bool {
        return lhs.title == rhs.title &&
            lhs.thumbnailImage == rhs.thumbnailImage &&
            lhs.originalImage == rhs.originalImage &&
            lhs.docURL == rhs.docURL
    }
}
