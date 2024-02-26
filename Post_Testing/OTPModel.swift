//
//  OtpModel.swift
//  Post_Testing
//
//  Created by MACPC on 22/02/24.
//



import Foundation

struct OTPModel: Decodable {
    let otp: String
    let id : Int
    
    enum CodingKeys: String, CodingKey {
           case otp = "actualKeyForOTP"
           case id
       }
}

