//
//  TranslationService.swift
//  Le Baluchon
//
//  Created by Maxime Point on 02/01/2023.
//

import Foundation

class TranslationService {
    
    static var shared = TranslationService()
    private init() {}
    
    private var session = URLSession(configuration: .default)
    init (session: URLSession) {
        self.session = session
    }
    
    private var task: URLSessionDataTask?
    
    /// Function performing a network call in order to obtain the translation of a text.
    /// - Parameters:
    ///   - translationFrom: Indicate the city / language from which the translation must be done (type: current or destination).
    ///   - text: Text to translate.
    ///   - callback:  Callback returning ServiceError? and a Translation?.
    func getTranslationService(translationFrom: CityType,
                               text: String,
                               callback: @escaping (ServiceError?, Translation?) -> Void) {
        
        task?.cancel()
        
        guard let currentLanguage = UserSettings.currentCity?.countryDetails?.languages?[0].iso6391,
              let destinationLanguage = UserSettings.destinationCity?.countryDetails?.languages?[0].iso6391 else {
            callback(ServiceError.languageNotfound, nil)
            return
        }
        
        /// Construction of the url for the network call (verification if the user data can be encoded for a url).
        var urlBuilder: URL? {
            if let textForUrl = text.encodingURL() {
                let baseUrl = "https://api-free.deepl.com/v2/translate?"
                switch translationFrom {
                    case .current:
                        return URL(string: "\(baseUrl)text=\(textForUrl)&target_lang=\(destinationLanguage)&source_lang=\(currentLanguage)")
                    case .destination:
                        return URL(string: "\(baseUrl)text=\(textForUrl)&target_lang=\(currentLanguage)&source_lang=\(destinationLanguage)")
                }
            } else { return nil }
        }
        
        guard let url = urlBuilder else { return callback(ServiceError.urlNotCorrect, nil) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(ApiKey.deepL, forHTTPHeaderField: "Authorization")
        
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(ServiceError.noData, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(ServiceError.badResponse, nil)
                    return
                }
                guard let responseJSON = try? SnakeCaseJSONDecoder().decode(Translation.self, from: data) else {
                    callback(ServiceError.undecodableJSON, nil)
                    return
                }
                print(data)
                print(response)
                print(responseJSON)
                callback(nil, responseJSON)
            }
        }
        task?.resume()
    }
    
}

