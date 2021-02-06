//
//  HistoryModel.swift
//  ImageSearch-watchOS
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation
import RxDataSources

typealias HistorySectionModel = AnimatableSectionModel<HistorySection, HistorySectionItem>

enum HistorySection: Int, IdentifiableType, Equatable {
    case history = 0
    
    var identity: Int {
        return rawValue
    }
    
    static func == (lhs: HistorySection, rhs: HistorySection) -> Bool {
        return lhs.identity == rhs.identity
    }
}

struct HistoryData: IdentifiableType, Equatable {
    var date: String
    var text: String
    
    var identity: String {
        return date
    }
    
    static func == (lhs: HistoryData, rhs: HistoryData) -> Bool {
        return lhs.identity == rhs.identity
    }
}

enum HistorySectionItem: IdentifiableType, Equatable {
    case history(HistoryData)
    
    var identity: String {
        switch self {
        case .history(let data):
            return data.identity
        }
    }
    
    static func == (lhs: HistorySectionItem, rhs: HistorySectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
