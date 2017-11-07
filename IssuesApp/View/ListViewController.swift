//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 10. 28..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import Alamofire

protocol DatasourceRefreshable: class {
    associatedtype Item
    var datasource: [Item] { get set }
    var needRefreshDatasource: Bool { get set }
}

extension DatasourceRefreshable {
    func setNeedRefreshDatasource() {
        needRefreshDatasource = true
    }
    func refreshDataSourceIfNeeded() {
        if needRefreshDatasource {
            datasource = []
            needRefreshDatasource = false
        }
    }
}

class ListViewController<CellType: UICollectionViewCell & CellProtocol>: UIViewController, DatasourceRefreshable, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    typealias Item = CellType.Item
    typealias ResponsesHandler = (DataResponse<[Item]>) -> Void
    var needRefreshDatasource: Bool = false

    fileprivate let estimateCell: CellType = CellType.cellFromNib
    let refreshControl = UIRefreshControl()
    @IBOutlet var collectionView: UICollectionView!
    lazy var owner: String = { return GlobalState.instance.owner }()
    lazy var repo: String  = { return GlobalState.instance.repo }()
    
    var datasource: [Item] = []
    var loadMoreCell: LoadMoreFooterView?
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    var page: Int = 1
    var api: ((Int, @escaping ResponsesHandler) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func refresh() {
        page = 1
        canLoadMore = true
        loadMoreCell?.load()
        setNeedRefreshDatasource()
        load()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName(), for: indexPath) as? CellType else { return UICollectionViewCell() }
        let item = datasource[indexPath.item]
        cell.update(data: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooterView", for: indexPath) as? LoadMoreFooterView ?? LoadMoreFooterView()
            loadMoreCell = footerView
            return footerView
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = datasource[indexPath.item]
        estimateCell.update(data: data)
        let targetSize =  CGSize(width: collectionView.frame.size.width, height: 50)
        let estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        return estimatedSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
    
    func cellName() -> String  {
        return ""
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension ListViewController {
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: cellName(), bundle: nil), forCellWithReuseIdentifier: cellName())
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        load()
        loadMoreCell?.load()
    }
    
    func load() {
        guard isLoading == false else {return }
        isLoading = true
        
        api?(page, { [weak self] (response: DataResponse<[Item]>) -> Void in
            guard let `self` = self else { return }
            switch response.result {
            case .success(let items):
                print("issues: \(items)")
                self.dataLoaded(items: items)
                self.isLoading = false
            case .failure:
                self.isLoading = false
                break
            }
        })
    }
    
    func dataLoaded(items: [Item]) {
        refreshDataSourceIfNeeded()
        
        page += 1
        if items.isEmpty {
            canLoadMore = false
            loadMoreCell?.loadDone()
        }
        
        refreshControl.endRefreshing()
        datasource.append(contentsOf: items)
        collectionView.reloadData()
    }
    
    
    
    func loadMore(indexPath: IndexPath) {
        guard  indexPath.item == datasource.count - 1 && !isLoading && canLoadMore else { return }
        load()
    }
}

