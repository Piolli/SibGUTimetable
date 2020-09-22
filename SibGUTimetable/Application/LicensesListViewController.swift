//
//  LicensesListViewController.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 22.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import AcknowList

class LicensesViewController: AcknowListViewController {
    override func loadView() {
        super.loadView()
        if let licenses = FileLoader.shared.getAdditionalLicenses() {
            acknowledgements?.append(contentsOf: licenses)
        }
    }
}
