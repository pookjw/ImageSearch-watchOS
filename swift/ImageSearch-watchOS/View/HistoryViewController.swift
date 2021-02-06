//
//  HistoryViewController.swift
//  ImageSearch-watchOS
//
//  Created by Jinwoo Kim on 2/5/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HistoryViewController: UIViewController {
    typealias DataSource = RxTableViewSectionedAnimatedDataSource<HistorySectionModel>
    private struct Const {
        static let cellReuseIdentifier: String = "Cell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: HistoryViewModel = .init()
    private lazy var dataSource: DataSource = createDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Const.cellReuseIdentifier)
        bind()
    }
    
    private func bind() {
        viewModel.dataDriver
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)
        
        tableView.rx.itemDeleted
            .withUnretained(self)
            .subscribe { (weakSelf, indexPath) in
                weakSelf.viewModel.deleteHistory(at: indexPath.row)
            }
            .disposed(by: viewModel.disposeBag)
    }
    
    private func createDataSource() -> DataSource {
        let dataSource: DataSource = .init(configureCell: { (ds, tv, indexPath, item) -> UITableViewCell in
            let cell: UITableViewCell = tv.dequeueReusableCell(withIdentifier: Const.cellReuseIdentifier, for: indexPath)
            var content: UIListContentConfiguration = cell.defaultContentConfiguration()
            
            switch item {
            case .history(let data):
                content.text = data.text
                content.secondaryText = data.date
            }
            
            cell.contentConfiguration = content
            
            return cell
        })
        
        dataSource.canEditRowAtIndexPath = { (_, _) in
            return true
        }
        
        return dataSource
    }
}

