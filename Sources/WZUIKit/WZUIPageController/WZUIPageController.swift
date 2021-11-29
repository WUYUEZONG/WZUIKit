//
//  WZUIPageController.swift
//  
//
//  Created by mntechMac on 2021/11/29.
//

import UIKit


open class WZUIPageController: UIViewController {
    
    /// titles
    var titleDataSources: [String] = []
    
    
    private var pageTitleContent: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.delegate = self
        collection.dataSource = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        
        pageContentStack.addArrangedSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        let h = collection.heightAnchor.constraint(equalToConstant: self.collectionHeight())
        NSLayoutConstraint.activate([h])
        
        return collection
    }()
    
    private var pageContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
//        let top = stack.topAnchor.constraint(equalTo: view.topAnchor)
        let top = stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let leading = stack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        return stack
    }()
    
    private var pageController: UIPageViewController = {
        let options: [UIPageViewController.OptionsKey: Any] = [.interPageSpacing:0]
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        page.dataSource = self
        page.delegate = self
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    // MARK: - constant -
    
    func collectionHeight() -> CGFloat {
        return 44
    }
    
}


extension WZUIPageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleDataSources.count
    }
    
}
