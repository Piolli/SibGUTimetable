//
//  Coordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 04.01.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
    var rootViewController: UIViewController { get }
}
