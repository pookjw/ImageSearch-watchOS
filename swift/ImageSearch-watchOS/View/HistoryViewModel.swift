//
//  HistoryViewModel.swift
//  ImageSearch-watchOS
//
//  Created by Jinwoo Kim on 2/6/21.
//

import Foundation
import RxSwift
import RxCocoa

final class HistoryViewModel {
    private(set) var dataDriver: Driver<[HistorySectionModel]>!
    public var disposeBag: DisposeBag = .init()
    
    private struct Const {
        static let key: String = "search_history"
    }
    
    public init() {
        self.dataDriver = WCModel.shared.context
            .map { [weak self] _ -> [HistorySectionModel] in
                guard let self = self else { return []}
                
                let history = self.getHistory()
                
                var historyItems: [HistorySectionItem] = []
                history.forEach { (date, text) in
                    historyItems.append(.history(.init(date: date, text: text)))
                }
                
                return [.init(model: .history, items: historyItems)]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    public func deleteHistory(at idx: Int) {
        var history: [String: String] = getHistory()
        
        for (idx2, (key, _)) in history.enumerated() {
            if idx == idx2 {
                history.removeValue(forKey: key)
            }
        }
        WCModel.shared.contextSource[Const.key] = history
    }
    
    private func getHistory() -> [String: String] {
        return (WCModel.shared.contextSource[Const.key] as? [String: String]) ?? [:]
    }
    
    private func updateHistory(with history: [String: String]) {
        WCModel.shared.contextSource[Const.key] = history
    }
}
