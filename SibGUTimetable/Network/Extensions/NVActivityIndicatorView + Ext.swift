//
//  NVActivityIndicatorView + Ext.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 15.10.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import NVActivityIndicatorView

extension Reactive where Base: NVActivityIndicatorViewable & UIViewController {
    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { indicator, value in
            if value {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
}
