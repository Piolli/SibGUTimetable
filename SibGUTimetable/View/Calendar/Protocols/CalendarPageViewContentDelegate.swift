//
//  CalendarPageViewContentChanged.swift
//  SibGUTimetable
//
//  Created by Alexandr on 27/06/2019.
//  Copyright © 2019 Alexandr. All rights reserved.
//

import Foundation
import UIKit

// MARK: Observer for dynamic height of collection view
protocol CalendarPageViewContentChanged {
    func pageViewContentCollectionHeightChanged(collectionViewHeight: CGFloat)
}
