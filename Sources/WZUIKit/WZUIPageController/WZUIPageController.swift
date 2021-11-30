//
//  WZUIPageController.swift
//  
//
//  Created by mntechMac on 2021/11/29.
//

import UIKit


open class WZUIPageContentController: UIViewController {
    
    var contentIdentifier: String!
    
}




protocol WZUIPageControllerDelegate {
    
    func initControllerAtIndex(_ index: Int) -> UIViewController
}




open class WZUIPageController: UIViewController {
    
    var delegate: WZUIPageControllerDelegate?
    
    /// titles
    var titleDataSources: [String] = []
    private var cachedControllers: [String: UIViewController] = [:]
    
    private(set) var selectedIndex: Int = 0
    
    
    private var pageTitleCollection: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collection.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        return collection
    }()
    
    private var pageContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var titleContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var pageController: UIPageViewController = {
        let options: [UIPageViewController.OptionsKey: Any] = [.interPageSpacing:0]
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        return page
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = .white
        
        // colors
        pageController.view.backgroundColor = view.backgroundColor
        pageTitleCollection.backgroundColor = view.backgroundColor
        
    }
    
    
    func initUI() {
        // page Content Stack
        view.addSubview(pageContentStack)
        var top = pageContentStack.topAnchor.constraint(equalTo: view.topAnchor)
        if #available(iOS 11.0, *) {
            top = pageContentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        }
        let leading = pageContentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = pageContentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = pageContentStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([top, leading, trailing, bottom])
        
        pageContentStack.addArrangedSubview(titleContentStack)
        pageContentStack.addArrangedSubview(pageController.view)
        
        
        //
        let h = titleContentStack.heightAnchor.constraint(equalToConstant: self.collectionHeight())
        NSLayoutConstraint.activate([h])
        
        
        // delegate
        pageTitleCollection.delegate = self
        pageTitleCollection.dataSource = self
        
        pageController.dataSource = self
        pageController.delegate = self
    }
    
    
    
    
    // MARK: - constant -
    
    func collectionHeight() -> CGFloat {
        return 44
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        
        let titleCount = titleDataSources.count
        guard index < titleCount || index >= 0 else {
            // out of range
            return nil
        }
        
        // get from cache
        let title = titleDataSources[index]
        if let cached = cachedControllers[title] {
            return cached
        }
        
        let newController = delegate?.initControllerAtIndex(index) ?? UIViewController()
        newController.title = title
        // cache
        cachedControllers[title] = newController
        return newController
    }
    
    func indexOfViewController(_ viewContoller: UIViewController) -> Int {
        selectedIndex = titleDataSources.firstIndex(of: viewContoller.title!) ?? 0
        return selectedIndex
    }
    
}


public extension WZUIPageController {
    
    func addTitleRightItem(with title: String?, with image: UIImage? = nil, at target: Any?, with action: Selector) {
        let button = UIButton()
        button.addTarget(target, action: action, for: .touchUpInside)
        let w = button.widthAnchor.constraint(equalToConstant: collectionHeight())
        NSLayoutConstraint.activate([w])
        titleContentStack.addArrangedSubview(button)
    }
    
    
    func reloadData(at index: Int) {
        
        selectedIndex = index
        
        pageTitleCollection.reloadData()
        if let viewController = viewControllerAtIndex(index) {
            pageController.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
        }
        
    }
    
}


extension WZUIPageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.backgroundColor = .randomColor()
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleDataSources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reloadData(at: indexPath.row)
    }
    
}


extension WZUIPageController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        return pageContentController(current: viewController, isToNext: true)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return pageContentController(current: viewController, isToNext: false)
    }
    
    func pageContentController(current: UIViewController, isToNext: Bool) -> UIViewController? {
        var index = indexOfViewController(current)
        guard index >= 0 && index < titleDataSources.count - 1 else { return nil }
        if isToNext {
            index += 1
        } else {
            index -= 1
        }
        return viewControllerAtIndex(index)
    }
    
}
