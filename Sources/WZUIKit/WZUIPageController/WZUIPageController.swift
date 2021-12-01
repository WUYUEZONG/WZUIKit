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




public protocol WZUIPageControllerDelegate {
    
    func initControllerAtIndex(_ index: Int) -> UIViewController
}




open class WZUIPageController: UIViewController {
    
    public var delegate: WZUIPageControllerDelegate?
    
    /// titles
    public var titleDataSources: [String] = []
    private var cachedControllers: [String: UIViewController] = [:]
    
    private(set) var selectedIndex: Int = 0
    
    
    private var pageTitleCollection: UICollectionView = {
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collection.contentInset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10);
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
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
        
        addChild(pageController)
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
        
        
        titleContentStack.addArrangedSubview(pageTitleCollection)
        
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
        guard index < titleCount && index >= 0 else {
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
        newController.view.backgroundColor = .randomColor(50)
        cachedControllers[title] = newController
        return newController
    }
    
    func indexOfViewController(_ viewContoller: UIViewController) -> Int {
        let index = titleDataSources.firstIndex(of: viewContoller.title!) ?? 0
        reloadData(at: index, resetContent: false, isSelectedAtTitle: false)
        return index
    }
    
}


public extension WZUIPageController {
    
    @discardableResult
    func addTitleRightItem(with title: String?, with image: UIImage? = nil, at target: Any?, with action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        if #available(iOS 13.0, *) {
            button.setTitleColor(.label, for: .normal)
        } else {
            button.setTitleColor(.darkGray, for: .normal)
        }
        let w = button.widthAnchor.constraint(equalToConstant: collectionHeight())
        NSLayoutConstraint.activate([w])
        titleContentStack.addArrangedSubview(button)
        return button
    }
    
    func reloadData(at index: Int) {
        reloadData(at: index, resetContent: true, isSelectedAtTitle: false)
    }
    
    /// reload newData
    ///
    ///
    /// `index` : reset title index, reset content controller
    ///
    /// `resetContent` : if need reset viewcontroller. default is `true`, if `false` only set the title index
    ///
    private func reloadData(at index: Int, resetContent: Bool = true, isSelectedAtTitle: Bool = true) {
        
        guard index >= 0 && index < self.titleDataSources.count else {
            return
        }
        
        selectedIndex = index
        
        
        pageTitleCollection.reloadData()
        
        if resetContent {
            
            if !isSelectedAtTitle {
                // 非点击title时
                perform(#selector(scrollToIndex(params:)), with: ["index": index, "position": UICollectionView.ScrollPosition.centeredHorizontally], afterDelay: 0.2)
            }
        } else {
            
            // 滚动content时
            
            var position: UICollectionView.ScrollPosition? = nil
            
            let visibleItems = pageTitleCollection.indexPathsForVisibleItems
            
            if let first = visibleItems.first, let last = visibleItems.last {
                if first.row > index {
                    position = .left
                } else if last.row < index {
                    position = .right
                }
            }
            
            if let position = position {
                scrollToIndex(params: ["index": index, "position": position])
            }
            
        }
        
        if resetContent, let viewController = viewControllerAtIndex(index) {
            pageController.setViewControllers([viewController], direction: .reverse, animated: false, completion: nil)
        }
    }
    
    
    /// scrollTo
    ///
    /// @KEY `index`
    /// @KEY `position` scroll animation
    ///
    @objc func scrollToIndex(params: [String: Any]?) {
        
        guard let params = params else {
            return
        }
        
        if let position = params["position"] as? UICollectionView.ScrollPosition {
            pageTitleCollection.scrollToItem(at: IndexPath(row: params["index"]! as! Int, section: 0), at: position, animated: true)
        }
        
    }
    
}


extension WZUIPageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        var label = UILabel()
        
        if let cellLabel = cell.backgroundView as? UILabel {
            label = cellLabel
            //label.text = titleDataSources[indexPath.row]
        } else {
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            cell.backgroundView = label
        }
        
        
        label.textColor = selectedIndex == indexPath.row ? .white : .gray
        label.backgroundColor = selectedIndex == indexPath.row ? .randomColor(80) : .clear
        label.text = titleDataSources[indexPath.row]
//        cell.backgroundColor = selectedIndex == indexPath.row ? .randomColor(80) : .clear//.randomColor(100)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleDataSources.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reloadData(at: indexPath.row, resetContent: true, isSelectedAtTitle: true)
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
        guard index >= 0 && index < titleDataSources.count else { return nil }
        if isToNext {
            index += 1
        } else {
            index -= 1
        }
        return viewControllerAtIndex(index)
    }
    
}
