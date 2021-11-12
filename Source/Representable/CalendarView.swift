//
//  CalendarView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/02.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    @Binding var latestMonthArray: [Int]
    @Binding var selectedDay: Int

    init(_ latestMonthArray: Binding<[Int]>, _ selectedDay: Binding<Int>) {
        self._latestMonthArray = latestMonthArray
        self._selectedDay = selectedDay
    }
    
    class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        var selectedCellStore = 0
        
        @Binding var latestMonthArray: [Int]
        @Binding var selectedDay: Int

        init(_ latestMonthArray: Binding<[Int]>, _ selectedDay: Binding<Int>) {
            self._latestMonthArray = latestMonthArray
            self._selectedDay = selectedDay
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return latestMonthArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
            
            let selectedBackGroundView = UIView(frame: cell.frame)
            selectedBackGroundView.backgroundColor = UIColor(named: "Primary")!.withAlphaComponent(0.3)
            
            let beforeSelectedBackGroundView = UIView(frame: cell.frame)
            beforeSelectedBackGroundView.backgroundColor = .white
            
            switch latestMonthArray[indexPath.item] {
            case 0:
                cell.customView?.rootView = Text("")
            default :
                cell.customView?.rootView = Text("\(latestMonthArray[indexPath.item])").foregroundColor(.gray)
                cell.bottomBorder.frame = CGRect(x: 0,
                                                 y: cell.contentView.frame.height - 0.5,
                                                 width: cell.contentView.frame.width,
                                                 height: 0.5)
                cell.bottomBorder.backgroundColor = UIColor(named: "Gray200")!.cgColor
                cell.contentView.layer.addSublayer(cell.bottomBorder)
                
                cell.selectedBackgroundView = selectedBackGroundView
                
                if indexPath.item == selectedCellStore {
                    cell.selectedBackgroundView = beforeSelectedBackGroundView
                }
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if latestMonthArray[indexPath.item] != 0 {
                collectionView.performBatchUpdates({
                    if selectedCellStore != 0 {
                        collectionView.reloadItems(at: [IndexPath(item: selectedCellStore, section: 0)])
                        selectedCellStore = indexPath.item
                    } else {
                        selectedCellStore = indexPath.item
                        let cell = collectionView.cellForItem(at: IndexPath(item: selectedCellStore, section: 0)) as! Cell
                        let selectedBackGroundView = UIView(frame: cell.frame)
                        selectedBackGroundView.backgroundColor = UIColor(named: "Primary")!.withAlphaComponent(0.3)
                        cell.selectedBackgroundView = selectedBackGroundView
                    }
                })
                
                selectedDay = latestMonthArray[indexPath.item]
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($latestMonthArray, $selectedDay)
    }
    
    func makeUIView(context: UIViewRepresentableContext<CalendarView>) -> UICollectionView {
        let itemSizeWidth = (UIScreen.main.bounds.width - 53) / 7
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSizeWidth, height: 40)
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.footerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = .white
        
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context : UIViewRepresentableContext<CalendarView>) {
        uiView.reloadData()
    }
    
    final class Cell: UICollectionViewCell {
        fileprivate var textView = Text("")
        fileprivate var customView: UIHostingController<Text>?
        
        fileprivate var bottomBorder = CALayer()
        
        fileprivate override init(frame: CGRect) {
            super.init(frame: frame)
            
            customView = UIHostingController(rootView: textView)
            customView!.view.frame = CGRect(origin: .zero, size: contentView.bounds.size)
            customView!.view.backgroundColor = .clear
            contentView.addSubview(customView!.view)
        }
        
        internal required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        internal override func prepareForReuse() {
            super.prepareForReuse()
            bottomBorder.removeFromSuperlayer()
        }
    }
}


