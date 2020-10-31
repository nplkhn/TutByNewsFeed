//
//  NewsCollectionViewController.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/28/20.
//

import UIKit


class NewsCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "NewsCollectionViewCell"
    private var news: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            getNewsText()
            newsManager.findFavourites(in: news)
        }
    }
    
    private var saved: [News] {
        return news.filter { news -> Bool in
            return news.isSaved ?? false
        }
    }
    
    // custom transition
//    var selectedCell: NewsCollectionViewCell?
//    var selectedCellContentViewSnapshot: UIView?
//    var animator: Animator?
    
    // services
    private let networkService = NetworkService.shared
    private let newsManager = NewsManager.sharedManager
    
    // ui
    private var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["All News","Saved"])
        
        segmentControl.tintColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = .clear
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentControl.selectedSegmentIndex = 0
        
        return segmentControl
    }()
    private var isShowSaved = false {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        setupView()
        
        getFeed()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.clearsSelectionOnViewWillAppear = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = UIColor(named: "TBBackground")
        navigationController?.navigationBar.barTintColor = UIColor(named: "TBBackground")
        
        navigationItem.titleView = segmentControl
        
        segmentControl.addTarget(self, action: #selector(self.segmentControlTapped(segmentControl:)), for: .valueChanged)
    }
    
    private func getFeed() {
        networkService.requestFeed { (news, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let news = news {
                self.news = news
            }
        }
    }
    
    private func getNewsText() {
        news.forEach { news in
            guard let link = news.link else { return }
            networkService.requestNews(from: link) { text, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let text = text else { return }
                news.newsText = text
            }
        }
    }
    
    
    @objc private func segmentControlTapped(segmentControl: UISegmentedControl) {
        if segmentControl.selectedSegmentIndex == 0 {
            isShowSaved = false
        } else {
            isShowSaved = true
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if isShowSaved {
            return saved.count
        }
        return news.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsCollectionViewCell
        cell.setActivityViewCenter(to: cell.contentView.center)
        
        //        cell.setImage(image: UIImage(systemName: "photo")!.withRenderingMode(.alwaysOriginal))
        cell.setTitle(title: news[indexPath.row].title!)
        cell.setDescription(description: news[indexPath.row].newsDescription!)
        
        guard let imageLink = news[indexPath.row].imageLink else { return cell }
        
        if let image = newsManager.getImage(for: imageLink) {
            cell.setImage(image: image)
        } else {
            networkService.requestImage(from: news[indexPath.row].imageLink!) { (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                guard let data = data, let image = UIImage(data: data) else  { return }
                self.newsManager.cacheImageData(data, for: imageLink)
                DispatchQueue.main.async {
                    cell.setImage(image: image)
                }
            }
        }
        
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = self.collectionView.center.x
        
        for cell in self.collectionView.visibleCells where cell is NewsCollectionViewCell {
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            
            let cellCenterX = basePosition.x + self.collectionView.frame.size.width / 2.0
            
            
            let distance = abs(cellCenterX - centerX)
            
            let tolerance: CGFloat = 0.02
            var scale = 1.0 + tolerance - ((distance / centerX) * 0.105)
            if scale > 1 {
                scale = 1
            }
            
            if(scale < 0.75){
                scale = 0.75
            }
            
            //            (cell as! NewsCollectionViewCell).setTransformToImage(transform: CGAffineTransform(scaleX: scale, y: scale))
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        networkService.cancellTask(for: news[indexPath.row].imageLink ?? "")
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedCell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell
//        selectedCellContentViewSnapshot = selectedCell?.contentView.snapshotView(afterScreenUpdates: false)
        
        let newsVC = NewsViewController()
        newsVC.setup(with: news[indexPath.row])
        
        
        present(newsVC, animated: true) {
            self.collectionView.deselectItem(at: indexPath, animated: false)
        }
        
//        show(newsVC, sender: nil)
        
    }
}

extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width * 0.85, height: collectionView.bounds.size.height * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
}

// Custom transition
//
//extension NewsCollectionViewController: UIViewControllerTransitioningDelegate {
//
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        guard let firstVC = presented as? NewsCollectionViewController,
//              let secondVC = presenting as? NewsViewController,
//              let selectedCellContentViewSnapshot = selectedCellContentViewSnapshot else { return nil }
//
//        animator = Animator(type: .present, firstVC: firstVC, secondVC: secondVC, selectedCellContentViewSnapshot: selectedCellContentViewSnapshot)
//
//        return animator
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        guard let secondVC = dismissed as? NewsViewController,
//              let selectedCellContentViewSnapshot = selectedCellContentViewSnapshot else { return nil }
//        animator = Animator(type: .dismiss, firstVC: self, secondVC: secondVC, selectedCellContentViewSnapshot: selectedCellContentViewSnapshot)
//        return animator
//    }
//}
