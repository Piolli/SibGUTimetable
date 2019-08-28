//
// Created by Alexandr on 26/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation

//Responsible for communicate with calendar view
protocol TimetablePageViewControllerDelegate {

    func pageViewDidMoved(state: TimetablePageViewController.PageViewMoveState)

}