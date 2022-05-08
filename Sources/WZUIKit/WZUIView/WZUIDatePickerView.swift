//
//  WZUIDatePickerView.swift
//  
//
//  Created by August on 2022/5/7.
//

import UIKit

class WZUIDatePickerView: UIView {

    @IBOutlet weak var dateButton: UIButton! {
        didSet {
            dateButton.setTitleColor(.systemBlue, for: .normal)
            dateButton.setTitleColor(.systemRed, for: .selected)
            dateButton.tintColor = dateButton.titleColor(for: .normal)
        }
    }
    
    @IBOutlet weak var previewMonthButton: UIButton!
    
    @IBOutlet weak var nextMonthButton: UIButton!
    
    @IBOutlet weak var weekStack: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker! {
        didSet {
            datePicker.calendar = WZUITool.shared.utcCalendar
        }
    }
    
    @IBOutlet weak var dateCollection: UICollectionView! {
        didSet {
            dateCollection.dataSource = self
            dateCollection.delegate = self
            
            dateCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.description())
        }
    }
    
    lazy var currentDate: Date = {
        let date = Date()
        dateButton.setTitle(date.toString("yyyy-MM", calendar: WZUITool.shared.utcCalendar), for: .normal)
        return date
    }()
    
    lazy var datas: [Date] = {
       return getNewCurrentDatas(Date())
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        
        
        if let contentView = UIView.initNib("WZUIDatePickerView", owner: self) {
            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(contentView)
        }
    }
    
    
    @IBAction func changeDateAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        previewMonthButton.isHidden = sender.isSelected
        nextMonthButton.isHidden = sender.isSelected
        weekStack.isHidden = sender.isSelected
        dateCollection.isHidden = sender.isSelected
        datePicker.isHidden = !sender.isSelected
        
        
        
        if sender.isSelected {
            datePicker.setDate(currentDate, animated: false)
            dateButton.tintColor = dateButton.titleColor(for: .selected)
        } else {
            setupAllNewStateByDate(datePicker.date)
            dateButton.tintColor = dateButton.titleColor(for: .normal)
        }
        
    }
    
    @IBAction func previewMonthAction(_ sender: UIButton) {
        let date = WZUITool.shared.utcCalendar.date(byAdding: .month, value: -1, to: currentDate)!
        setupAllNewStateByDate(date)
    }
    @IBAction func nextMonthAction(_ sender: UIButton) {
        let date = WZUITool.shared.utcCalendar.date(byAdding: .month, value: 1, to: currentDate)!
        setupAllNewStateByDate(date)
    }
    
    
    
    
    
}

extension WZUIDatePickerView {
    
    func setupAllNewStateByDate(_ date: Date) {
        currentDate = date
        dateButton.setTitle(date.toString("yyyy-MM", calendar: WZUITool.shared.utcCalendar), for: .normal)
        datas = getNewCurrentDatas(date)
        dateCollection.reloadData()
    }
    
    /// date:
    func getNewCurrentDatas(_ date: Date) -> [Date] {
        var theFirstDayofMonth = date
        var theInterval: TimeInterval = 0
        
        let calendar = WZUITool.shared.utcCalendar
        
        if !calendar.dateInterval(of: .month, start: &theFirstDayofMonth, interval: &theInterval, for: date) {
            theFirstDayofMonth = date
        }
        
        var days: [Date] = []
        
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: theFirstDayofMonth)!
        let previewMonth = calendar.date(byAdding: .day, value: -1, to: theFirstDayofMonth)!
        let firstWeekDayOfMonth = calendar.component(.weekday, from: theFirstDayofMonth)
        // count need add to header
        let headerAdd = firstWeekDayOfMonth - 1
        
        let previewDateComponents = calendar.dateComponents([.year, .month, .day], from: previewMonth)
        let nextDateComponents = calendar.dateComponents([.year, .month, .day], from: nextMonth)
        let dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: theFirstDayofMonth)
        
        let dateFormat = "yyyy-MM-dd"
        
        for i in 0..<headerAdd {
            let aDate = "\(previewDateComponents.year!)-\(previewDateComponents.month!)-\(previewDateComponents.day! - i)".toDate(dateFormat, calendar: calendar)!
            days.insert(aDate, at: 0)
        }
        
        let currentMonthDays = howManyDaysWithMonthInThis(year: dateComponents.year!, month: dateComponents.month!)
        let restDays = 35 - headerAdd
        for i in 1...restDays {
            var aDate: Date!
            if i <= currentMonthDays {
                aDate = "\(dateComponents.year!)-\(dateComponents.month!)-\(i)".toDate(dateFormat, calendar: calendar)!
            } else {
                aDate = "\(nextDateComponents.year!)-\(nextDateComponents.month!)-\(i-currentMonthDays)".toDate(dateFormat, calendar: calendar)!
            }
            days.append(aDate)
        }
        return days
    }
    
    

    func howManyDaysWithMonthInThis(year: Int, month: Int) -> Int {
        if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12)) {
            return 31
        }
        if((month == 4) || (month == 6) || (month == 9) || (month == 11)) {
            return 30
        }
        if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3)) {
            return 28
        }
        if(year % 400 == 0) {
            return 29
        }
        if(year % 100 == 0) {
            return 28
        }
        return 29
    }
}

extension WZUIDatePickerView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UICollectionViewCell.description(), for: indexPath)
        let currentComponents = WZUITool.shared.utcCalendar.dateComponents([.month, .day], from: currentDate)
        let rowComponents = WZUITool.shared.utcCalendar.dateComponents([.month, .day], from: datas[indexPath.row])
        cell.backgroundColor = currentComponents.month == rowComponents.month  ? (currentComponents.day == rowComponents.day ? .systemGreen : .systemBlue) : .systemRed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var wspacing: CGFloat = 0
        var hspacing: CGFloat = 0
        if let f = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            wspacing = f.minimumInteritemSpacing
            hspacing = f.minimumLineSpacing
        }
        let w = (collectionView.wzWidth - collectionView.contentInset.left - collectionView.contentInset.right - wspacing * 6) / 7
        let h = (collectionView.wzHeight - collectionView.contentInset.left - collectionView.contentInset.right - hspacing * 4) / 5
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentDate = datas[indexPath.row]
        collectionView.reloadData()
    }
    
}
