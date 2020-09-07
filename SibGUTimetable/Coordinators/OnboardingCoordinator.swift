//
//  OnboardingCoordinator.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 02.09.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation
import UIKit

class OnboardingCoordinator: Coordinator {
    
    let onboardingViewController: OnboardingViewController
    
    var rootViewController: UIViewController {
        return onboardingViewController
    }
    
    init() {
        onboardingViewController = OnboardingViewController()
    }
    
    func start() {
        onboardingViewController.modalPresentationStyle = .fullScreen
        onboardingViewController.coordinator = self
    }
    
    func close() {
        onboardingViewController.dismiss(animated: true, completion: nil)
    }
    
}
