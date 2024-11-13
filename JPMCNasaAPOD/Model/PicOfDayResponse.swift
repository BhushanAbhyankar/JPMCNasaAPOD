//
//  PicOfDayResponse.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

struct PicOfDayResponse:Codable{
    let date, explanation: String
    let mediaType, serviceVersion, title: String
    let url: String
    let hdurl,copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

extension PicOfDayResponse{
    static func mockPicOfDayResponse() -> Self{
        PicOfDayResponse(date: "2024-11-11", explanation:"What created an unusual dark streak in Comet Tsuchinshan-Atlas's tail? Some images of the bright comet during mid-October not only caught its impressively long tail and its thin anti-tail, but a rather unexpected feature: a dark streak in the long tail. The reason for the dark streak is currently unclear and a topic of some debate.  Possible reasons include a plume of dark dust, different parts of the bright tail being unusually superposed, and a shadow of a dense part of the coma on smaller dust particles. The streak is visible in the featured image taken on October 14 from Texas, USA. To help future analyses, if you have taken a good image of the comet that clearly shows this dark streak, please send it in to APOD. Comet Tsuchinshan–ATLAS has now faded considerably and is returning to the outer Solar System.   Gallery: Comet Tsuchinshan-ATLAS in 2024", mediaType:"image", serviceVersion: "v1", title: "The Unusual Tails of Comet Tsuchinshan-Atlas", url: "https://apod.nasa.gov/apod/image/2411/CometDarkTail_Falls_960.jpg", hdurl: "https://apod.nasa.gov/apod/image/2411/CometDarkTail_Falls_5122.jpg", copyright: "\nBray Falls\n")
    }
}
