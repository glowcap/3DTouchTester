//
//  PressureView.swift
//  3DTouchTester
//
//  Created by Daymein Gregorio on 10/21/15.
//  Copyright © 2015 Daymein Gregorio. All rights reserved.
//

import UIKit

class Pressure: UIView {
    override func drawRect(rect: CGRect) {
        PressureStyleKit.drawMain()
    }
}

class SignalConnector: UIView {
    override func drawRect(rect: CGRect) {
        PressureStyleKit.drawSignalConnector()
    }
}

class BtnConnector: UIView {
    override func drawRect(rect: CGRect) {
        PressureStyleKit.drawButtonConnector()
    }
}

class BtnCenter: UIView {
    override func drawRect(rect: CGRect) {
        PressureStyleKit.drawButtonCenter()
    }
}

class Spring: UIView {
    override func drawRect(rect: CGRect) {
        PressureStyleKit.drawSpring()
    }
}

class InfoBoard: UIView {
    override func drawRect(rect: CGRect) {
        PressureStyleKit.drawInformationSign()
    }
}
