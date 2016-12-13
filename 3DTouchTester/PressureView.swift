//
//  PressureView.swift
//  3DTouchTester
//
//  Created by Daymein Gregorio on 10/21/15.
//  Copyright © 2015 Daymein Gregorio. All rights reserved.
//

import UIKit

class Pressure: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawMain()
    }
}

class SignalConnector: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawSignalConnector()
    }
}

class BtnConnector: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawButtonConnector()
    }
}

class BtnCenter: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawButtonCenter()
    }
}

class Spring: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawSpring()
    }
}

class InfoBoard: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawInformationSign()
    }
}

class Signal: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawSixSignalRing()
    }
}

class Non6BaseView: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawNon6StartView()
    }
}

class Non6BtnTop: UIView {
    override func draw(_ rect: CGRect) {
        PressureStyleKit.drawNon6StartBtn()
    }
}
