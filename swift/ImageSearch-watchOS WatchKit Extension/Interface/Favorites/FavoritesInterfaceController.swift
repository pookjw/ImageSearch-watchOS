//
//  FavoritesInterfaceController.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/6/21.
//

import WatchKit
import Foundation


class FavoritesInterfaceController: WKInterfaceController {
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    private var viewModel: FavoritesInterfaceModel = .init()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        bind()
    }

    private func bind() {
        viewModel.reloadTableViewEvent
            .withUnretained(self)
            .drive { (weakSelf, arrayData) in
                weakSelf.tableView.setNumberOfRows(arrayData.count, withRowType: SearchInterfaceModel.Const.cellIdentifier)
                for (idx, data) in arrayData.enumerated() {
                    guard let object: TableCellObject = weakSelf.tableView.rowController(at: idx) as? TableCellObject else { return }
                    object.configure(data)
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        guard let object: TableCellObject = tableView.rowController(at: rowIndex) as? TableCellObject,
              let searchData: SearchData = object.searchData
              else { return }
        pushController(withName: "Detail", context: ["searchData": searchData])
    }
}
