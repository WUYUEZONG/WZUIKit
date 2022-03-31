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

///
/// 1. 继承 WZUIPageController
///
/// 2. titleDataSources 设置菜单栏文本
///
/// 3. addTitleRightItem 天际菜单栏右边的按钮
///
/// 4. reloadData
///
open class WZUIPageController: UIViewController {
    
    /// titles
    public var titleDataSources: [String] = [] {
        didSet {
            if !titleDataSources.isEmpty {            
                reloadData(at: 0)
            }
        }
    }
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
    
    private var cachedTitleWidth: [String: CGFloat] = [:]
    
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
        
        let newController = initControllerAtIndex(index)
        newController.title = title
        // cache
//        newController.view.backgroundColor = .randomColor(50)
        cachedControllers[title] = newController
        return newController
    }
    
    func indexOfViewController(_ viewContoller: UIViewController) -> Int {
        let index = titleDataSources.firstIndex(of: viewContoller.title!) ?? 0
        return index
    }
    
    open func initControllerAtIndex(_ index: Int) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .randomColor(66)
        return vc
    }
    
}



/// params keys
extension WZUIPageController {
    
    /// the func `scrollToIndex` params key of `position`
    func keyNamedPosition() -> String { "position" }
    /// the func `scrollToIndex` params key of `index`
    func keyNamedIndex() -> String { "index" }
    
}


public extension WZUIPageController {
    
    @discardableResult
    func addTitleRightItem(title: String?, image: UIImage? = nil, at target: Any?, action: Selector) -> UIButton {
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
    /// reload newData
    ///
    ///
    /// `index` : reset title index, reset content controller
    ///  reload and set default index.
    ///
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
        
        guard index >= 0 && index < self.titleDataSources.count else { return }
        if selectedIndex == index && (isSelectedAtTitle || !resetContent) { return }
        
        if resetContent {
            
            if !isSelectedAtTitle {
                // 非点击title时
                let params: [String: Any] = [self.keyNamedIndex(): index, self.keyNamedPosition(): UICollectionView.ScrollPosition.centeredHorizontally]
                perform(#selector(scrollToIndex(params:)), with: params, afterDelay: 0.2)
            }
        } else {
            
            // 滚动content时
            var position: UICollectionView.ScrollPosition? = nil
            
            if let layoutAttribute = pageTitleCollection.layoutAttributesForItem(at: IndexPath(row: index, section: 0)) {
                let frame = layoutAttribute.frame
                let contentX = pageTitleCollection.contentOffset.x
                
                let isOutOfRight = frame.minX - contentX - pageTitleCollection.frame.width > -frame.width
                let isOutOfLeft = frame.minX < contentX
                
                position = isOutOfLeft ? .left : (isOutOfRight ? .right : nil)
            }

            if let position = position {
                scrollToIndex(params: [self.keyNamedIndex(): index, self.keyNamedPosition(): position])
            }
            
        }
        
        selectedIndex = index
        pageTitleCollection.reloadData()
        
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
        
        if let position = params[self.keyNamedPosition()] as? UICollectionView.ScrollPosition {
            pageTitleCollection.scrollToItem(at: IndexPath(row: params[self.keyNamedIndex()]! as! Int, section: 0), at: position, animated: true)
        }
        
    }
    
}


extension WZUIPageController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let key = titleDataSources[indexPath.row]
        let defaultHeight = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        if let cachedWidth = cachedTitleWidth[key] {
            return CGSize(width: cachedWidth, height: defaultHeight);
        }
        var width = key.width(attributes: [.font: UIFont.systemFont(ofSize: 15)]) + 20
        debugPrint("the width is \(width)")
        width = width < 60 ? 60 : width
        cachedTitleWidth[key] = width
        return CGSize(width: width, height: defaultHeight)
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
            label.font = .systemFont(ofSize: 15)
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
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, let controller = pageViewController.viewControllers?.first {
            reloadData(at: indexOfViewController(controller), resetContent: false, isSelectedAtTitle: false)
        }
        
    }
    
}
