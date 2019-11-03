//
// Created by Alexandr on 30/08/2019.
// Copyright (c) 2019 Alexandr. All rights reserved.
//

import Foundation
import RxSwift

protocol TimetableRepositoryProtocol {
    
    func getSchedule() -> Observable<Schedule>

}
