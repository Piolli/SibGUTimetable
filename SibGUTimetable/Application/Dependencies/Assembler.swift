//
//  Assembler.swift
//  SibGUTimetable
//
//  Created by Александр Камышев on 06.06.2020.
//  Copyright © 2020 Alexandr. All rights reserved.
//

import Foundation

class Assembler :
    FakeRepositoryAssembler,
    FakeUserPreferencesAssembler
{

    public static let shared = Assembler()

    private init() { }

    func resolve() -> APIServer {
        return NativeAPIServer.sharedInstance
    }
    
}


