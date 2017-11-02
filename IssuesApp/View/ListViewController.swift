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

//protocol LoadMoreable: class {
//    var canLoadMore: Bool { get set }
//    var loadMoreCell: LoadMoreFooterView? { get set }
//    func loadMore(indexPath: IndexPath)
//    var isLoading: Bool { get set }
//}

class ListViewController: UIViewController, DatasourceRefreshable {
    var needRefreshDatasource: Bool = false

    fileprivate let estimateCell: IssueCell = IssueCell.cellFromNib
    let refreshControl = UIRefreshControl()
    @IBOutlet var collectionView: UICollectionView!
    lazy var owner: String = { return GlobalState.instance.owner }()
    lazy var repo: String  = { return GlobalState.instance.repo }()
    var datasource: [Model.Issue] = []
    var loadMoreCell: LoadMoreFooterView?
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    var page: Int = 1
    
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

}

extension ListViewController {
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "IssueCell", bundle: nil), forCellWithReuseIdentifier: "IssueCell")
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        load()
        loadMoreCell?.load()
    }
    
    func load() {
        guard isLoading == false else {return }
        isLoading = true
        App.api.repoIssues(owner: owner, repo: repo, page: page, handler: { [weak self] (response: DataResponse<[Model.Issue]>) in
            guard let `self` = self else { return }
            switch response.result {
            case .success(let items):
                print("issues: \(items)")
                self.dataLoaded(items: items)
            case .failure:
                break
            }
        })
    }
    
    func dataLoaded(items: [Model.Issue]) {
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
    
    @objc func refresh() {
        page = 1
        canLoadMore = true
        loadMoreCell?.load()
        setNeedRefreshDatasource()
        load()
    }
    
    func loadMore(indexPath: IndexPath) {
        guard  indexPath.item == datasource.count - 1 && !isLoading && canLoadMore else { return }
        load()
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath) as? IssueCell else { return UICollectionViewCell() }
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
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = datasource[indexPath.item]
        estimateCell.update(data: data)
        let targetSize =  CGSize(width: collectionView.frame.size.width, height: 50)
        let estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        return estimatedSize
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
}
