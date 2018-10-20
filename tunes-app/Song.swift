//
//  Song.swift
//  tunes-app
//
//  Created by Elisabeth Petit - Bois on 20/10/2018.
//  Copyright © 2018 Elisabeth Petit - Bois. All rights reserved.
//

import Foundation

struct Song: Codable {
    let artistName: String
    let trackName: String
    let previewURl: String
    let artworkUrl100: String
    
    var artworkUrl:String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "1000x1000")
    }
}

extension Song {
    
    //JSON TO OBJECTS
    private struct SongResponse: Codable { //must have same names as features in JSON
        let resultCount:Int
        let results:[Song]
    }
    
    static func search(with query: String, completionHandler: @escaping ([Song]) -> Void ) {
        
        let safeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //build api path
        let path = "https://itunes.apple.com/search?" +
                    "entity=song" +
                    "&term=\(safeQuery)"
        
        let url = URL(string: path)!
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
            guard let data = data,
                let response = try? JSONDecoder().decode(SongResponse.self, from: data),
                response.resultCount != 0 else
                //no data found
                {
                    completionHandler([])
                    return
                }
            
            completionHandler(response.results)
        }).resume()
    }
}
