//
//  ObjectServices.swift
//  MyHomeApp
//
//  Created by Gabriel on 2/13/25.
//

import Foundation

class ObjectServices {
    
    static var ip_adress = "192.168.48.81"
    
    class func getPresence(completion: @escaping (Error?, Float?) -> Void) {
          
        let url = "http://" + ip_adress + "/handle_GetHereActive"
        
           guard let itemURL = URL(string: url) else {
               return
           }
           
           var request = URLRequest(url: itemURL)
           request.httpMethod = "GET"

           
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard error == nil else {
                   completion(error, nil)
                   return
               }
               guard let data = data else {
                   completion(NSError(domain: "com.obj", code: 2, userInfo: [
                       NSLocalizedFailureReasonErrorKey: "No data found"
                   ]), nil)
                   return
               }

               do {
                   
                   if let responseString = String(data: data, encoding: .utf8) {
                       
                       if let range = responseString.range(of: "distance = ") {
                           let distanceString = responseString[range.upperBound...]
                           
                           if let distance = Float(distanceString.trimmingCharacters(in: .whitespaces)) {
                               completion(nil, distance)
                           } else {
                               completion(NSError(domain: "com.obj", code: 3, userInfo: [
                                   NSLocalizedFailureReasonErrorKey: "Unable to parse distance"
                               ]), nil)
                           }
                       } else {
                           completion(NSError(domain: "com.obj", code: 3, userInfo: [
                               NSLocalizedFailureReasonErrorKey: "Distance not found in response"
                           ]), nil)
                       }
                   }
               }
           }
           task.resume()
       }
    
    class func getIntrusion(completion: @escaping (Error?, Int?) -> Void) {
          
        let url = "http://" + ip_adress + "/handle_GetAlarmActive"
        
           guard let itemURL = URL(string: url) else {
               return
           }
           
           var request = URLRequest(url: itemURL)
           request.httpMethod = "GET"

           
           let task = URLSession.shared.dataTask(with: request) { data, response, error in
               guard error == nil else {
                   completion(error, nil)
                   return
               }
               guard let data = data else {
                   completion(NSError(domain: "com.obj", code: 2, userInfo: [
                       NSLocalizedFailureReasonErrorKey: "No data found"
                   ]), nil)
                   return
               }

               do {
                   
                   if let responseString = String(data: data, encoding: .utf8) {
                       
                       
                       if let range = responseString.range(of: "countAlarm = ") {
                           let intrusionString = responseString[range.upperBound...]
                           
                           if let intrusion = Int(intrusionString.trimmingCharacters(in: .whitespaces)) {
                               completion(nil, intrusion)
                           } else {
                               completion(NSError(domain: "com.obj", code: 5, userInfo: [
                                   NSLocalizedFailureReasonErrorKey: "Unable to parse distance"
                               ]), nil)
                           }
                       } else {
                           completion(NSError(domain: "com.obj", code: 6, userInfo: [
                               NSLocalizedFailureReasonErrorKey: "Distance not found in response"
                           ]), nil)
                       }
                   }
               }
           }
           task.resume()
       }
    
    // Fonction qui va activer ou désactiver l'alarme
    class func setAlarm(state: String, completion: @escaping (Error?, String?) -> Void) {
        let url = "http://" + ip_adress + "/setAlarm?state=" + state
        
        guard let itemURL = URL(string: url) else {
            completion(NSError(domain: "com.obj", code: 1, userInfo: [
                NSLocalizedFailureReasonErrorKey: "Invalid URL"
            ]), nil)
            return
        }
        
        var request = URLRequest(url: itemURL)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(error, nil)
                return
            }
            guard let data = data else {
                completion(NSError(domain: "com.obj", code: 2, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "No data found"
                ]), nil)
                return
            }
            
            // Traitement de la réponse du serveur
            if let responseString = String(data: data, encoding: .utf8) {
            
                completion(nil, responseString)
            } else {
                completion(NSError(domain: "com.obj", code: 3, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "Unable to parse response"
                ]), nil)
            }
        }
        task.resume()
    }

    class func setPowerPression(pression: Int, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "http://" + ip_adress + "/setPowerPression") else {
            completion(false, "URL invalide")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyData = "value=\(pression)"
        request.httpBody = bodyData.data(using: .utf8)
        
  
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "Erreur de connexion : \(error.localizedDescription)")
                return
            }
            
            // Vérification du statut de la réponse
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true, "power_pression modifié avec succès")
                } else {
                    completion(false, "Erreur serveur : Code \(httpResponse.statusCode)")
                }
            }
        }
        
        task.resume()
    }

    
}
