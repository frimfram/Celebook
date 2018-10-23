//
//  TMDBClient.swift
//  Celebook
//
//  Created by Jean Ro on 2/26/18.
//  Copyright © 2018 Jean Ro. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TMDBClient {
    
    static let shared = TMDBClient()
    
    public var persons: [Celebrity] = [Celebrity]()
    var pageFetched: Int = 0
    
    let posterOperations: PendingOperations = PendingOperations()
    
    public var selectedPersons: [Celebrity] = [Celebrity]()
    public var posterImages: [Int: [MoviePoster]] = [:]
    
    private init() {
        //private init for singleton
    }
    
    func fetchCelebrityData(handler: @escaping (String?) -> Swift.Void) {
        let methodParameters = [TMDBConstants.TMDBParameterKeys.ApiKey: TMDBConstants.TMDBParameterValues.ApiKey,
                                TMDBConstants.TMDBParameterKeys.Page: String(pageFetched+1)]
        
        let requestUrl = tmdbApiURLFromParameters(methodParameters as [String: AnyObject], withPath: "/person/popular")
        var request = URLRequest(url: requestUrl)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                handler("Error with TMDB popular person request: \(String(describing:error))")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                handler("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                handler("No data was returned by the request!")
                return
            }
            guard let json = try? JSON(data: data) else {
                handler("Could not parse the data as JSON: '\(String(describing: data))'")
                return
            }
            var clientReturn = ClientReturn()
            clientReturn.json = json
            if json["page"].exists() {
                clientReturn.pageResults = PageResultsMDB(results: json)
            }
            
            let celebrityJson = json["results"]
            let celebrityList: [Celebrity] = Celebrity.initialize(json: celebrityJson)
            self.persons.append(contentsOf: celebrityList)
            if let page = clientReturn.pageResults?.page {
                self.pageFetched = page
            }

            DispatchQueue.main.async {
                //update the UI
                for aPerson in self.persons {
                    aPerson.printDebug()
                }
                handler(nil)
            }
        }
        task.resume()
    }
    
    func fetchMovies(for personId: Int, handler: @escaping (PersonMovieCredits?, String?) -> Swift.Void) {
        let methodParameters = [TMDBConstants.TMDBParameterKeys.ApiKey: TMDBConstants.TMDBParameterValues.ApiKey]
        let pathParameters = "/person/" + String(personId) + "/movie_credits"
        let requestUrl = tmdbApiURLFromParameters(methodParameters as [String: AnyObject], withPath: pathParameters)
        var request = URLRequest(url: requestUrl)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                handler(nil, "Error with TMDB movie credits request: \(String(describing:error))")
                return
            }
            guard let data = data else {
                handler(nil, "No data was returned by the request!")
                return
            }
            guard let json = try? JSON(data: data) else {
                handler(nil, "Could not parse the data as JSON: '\(String(describing: data))'")
                return
            }
            let movieCredits = PersonMovieCredits(json: json)
            handler(movieCredits, nil)
        }
        task.resume()
    }
    
    func tmdbApiURLFromParameters(_ parameters: [String:AnyObject], withPath: String? = nil) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = TMDBConstants.TMDB.ApiScheme
        urlComponents.host = TMDBConstants.TMDB.ApiHost
        urlComponents.path = TMDBConstants.TMDB.ApiPath + (withPath ?? "")
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url!
    }
    
    func addPerson(_ person: Celebrity) {
        if !selectedPersons.contains(person) {
            selectedPersons.append(person)
            save(person)
            scheduleDownloads(person)
        }
    }
    
    func deletePerson(at index: Int) {
        let person = selectedPersons[index]
        posterOperations.downloadsInProgress[person.id]?.cancel()
        posterOperations.downloadsInProgress.removeValue(forKey: person.id)
        selectedPersons.remove(at: index)
    }
    
    func scheduleDownloads(_ person: Celebrity) {
        guard (posterOperations.downloadsInProgress.keys.first { $0 == person.id }) == nil else {
            return
        }
        if let posterDownloader = PosterImageDownloader(person) {
            posterOperations.downloadQueue.addOperation(posterDownloader)
            posterOperations.downloadsInProgress[person.id] = posterDownloader
        }
    }
    
    func save(_ person: Celebrity) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "CelebrityPerson", in: managedContext) else {
            return
        }
        let personObj = NSManagedObject(entity: entity, insertInto: managedContext)
        personObj.setValue(person.id, forKey: "id")
        personObj.setValue(person.name, forKey: "name")
        if let profilePath = person.profile_path {
            personObj.setValue(profilePath, forKey: "imagePath")
        }
    }
    
    func getAllCelebrities() -> [Celebrity]? {
        guard let managedObjects = fetchAllSaved() else {
            return nil
        }
        for obj in managedObjects {
            guard let id = obj.value(forKeyPath: "id") as? Int,
                let name = obj.value(forKeyPath: "name") as? String,
                let imagePath = obj.value(forKeyPath: "imagePath") as? String else {
                    continue
            }
            let celeb = Celebrity(id: id, name: name, profilePath: imagePath)
            addPerson(celeb)
        }
        return selectedPersons.count > 0 ? selectedPersons : nil
    }
    
    func fetchAllSaved() -> [NSManagedObject]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CelebrityPerson")
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Core Data fetch error. \(error), \(error.userInfo)")
        }
        return nil
    }
}

public struct ClientReturn{
    public var error: NSError?
    public var json: JSON?
    public var pageResults: PageResultsMDB?
}
