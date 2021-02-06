//
//  SearchInterfaceController.swift
//  ImageSearch-watchOS WatchKit Extension
//
//  Created by Jinwoo Kim on 2/5/21.
//

import WatchKit
import Foundation
import RxSwift
import RxCocoa
import Kingfisher

final class SearchInterfaceController: WKInterfaceController {
    @IBOutlet weak var textField: WKInterfaceTextField!
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    private var viewModel: SearchInterfaceModel = .init()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        bind()
    }
    
    private func bind() {
        viewModel.reloadTableViewEvent
            .withUnretained(self)
            .drive { (weakSelf, arrayData) in
                weakSelf.tableView.setNumberOfRows(arrayData.count, withRowType: SearchInterfaceModel.Const.cellReuseIdentifier)
                for (idx, data) in arrayData.enumerated() {
                    guard let object: TableCellObject = weakSelf.tableView.rowController(at: idx) as? TableCellObject else { return }
                    object.configure(data)
                    object.setFavoritedStatus()
                }
            }
            .disposed(by: viewModel.disposeBag)
    }

    @IBAction func textFieldAction(_ value: NSString?) {
        guard let text: String = value as String? else { return }
        viewModel.request(text: text)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        super.table(table, didSelectRowAt: rowIndex)
        guard let object: TableCellObject = tableView.rowController(at: rowIndex) as? TableCellObject,
              let searchData: SearchData = object.searchData
              else { return }
        viewModel.toggleFavorite(searchData)
    }
}
