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
    
    func getTranslationService(translationFrom: CityType, text: String, callback: @escaping (ServiceError?, Translation?) -> Void) {
        task?.cancel()
        
        guard let languageCurrentCity = UserSettings.currentCity?.countryDetails?.languages?[0].iso6391,
              let languageDestinationCity = UserSettings.destinationCity?.countryDetails?.languages?[0].iso6391 else {
            callback(ServiceError.currencyNotFound, nil)
            return
        }
        
        var exchangeRateUrl: URL? {
            if let textForUrl = text.encodingURL() {
                switch translationFrom {
                    case .current:
                        return URL(string: "https://api-free.deepl.com/v2/translate?text=\(textForUrl)&target_lang=\(languageDestinationCity)&source_lang=\(languageCurrentCity)")
                    case .destination:
                        return URL(string: "https://api-free.deepl.com/v2/translate?text=\(textForUrl)&target_lang=\(languageCurrentCity)&source_lang=\(languageDestinationCity)")
                }
            }
            return nil
        }
        
        guard let url = exchangeRateUrl else { return callback(ServiceError.urlNotCorrect, nil) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(ApiKey.apiDeepL, forHTTPHeaderField: "Authorization")
        
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

