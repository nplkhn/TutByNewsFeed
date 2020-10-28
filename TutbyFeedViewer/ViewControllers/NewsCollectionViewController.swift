//
//  NewsCollectionViewController.swift
//  TutbyFeedViewer
//
//  Created by Никита Плахин on 10/28/20.
//

import UIKit



class NewsCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "NewsCollectionViewCell"
    
    private let networkService = NetworkService()
    private var news: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private let newsManager = NewsManager.sharedManager
    
    private var segmentControl: UISegmentedControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        setupView()
        
        getFeed()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.clearsSelectionOnViewWillAppear = false
        
        collectionView.backgroundColor = UIColor(named: "TBBackground")
        navigationController?.navigationBar.barTintColor = UIColor(named: "TBBackground")
        
        segmentControl = UISegmentedControl(items: ["All News","Saved"])
        
        segmentControl.tintColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedSegmentTintColor = .clear
        
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        segmentControl.selectedSegmentIndex = 0
        
        
        navigationItem.titleView = segmentControl
    }
    
    private func getFeed() {
        networkService.request(url: "https://news.tut.by/rss/index.rss") { (news, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let news = news {
                self.news = news
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return news.count
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsCollectionViewCell
    
        cell.setImage(image: UIImage(systemName: "photo")!.withRenderingMode(.alwaysOriginal))
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

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

}

extension NewsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width * 0.85, height: collectionView.bounds.size.height * 0.85)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
}
