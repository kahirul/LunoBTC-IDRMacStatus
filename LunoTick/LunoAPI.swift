import Foundation

class LunoAPI {
  let BASE_URL = "https://api.mybitx.com/api/1/ticker?pair=XBTIDR"
  var askingPrice: String = ""
  
  func fetch(success: @escaping (String) -> Void) {
    let session = URLSession.shared
    let url = URL(string: BASE_URL)
    
    let task = session.dataTask(with: url!) { data, response, err in
      if let error = err {
        NSLog("LunoAPI error: \(error)")
      }
      
      if let httpResponse = response as? HTTPURLResponse {
        switch httpResponse.statusCode {
        case 200:
          self.extractPrice(data!)
          success(self.askingPrice)
        default:
          NSLog("LunoAPI return response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
        }
      }
    }
    
    task.resume()
  }
  
  func extractPrice(_ data: Data) {
    typealias JSONDict = [String:AnyObject]
    var json: JSONDict = JSONDict()
    
    do {
      json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
    } catch  {
      NSLog("JSON parsing failed: \(error)")
    }
    
    formatAskingPrice(json["ask"] as? NSString)
  }
  
  func formatAskingPrice(_ rawPrice: NSString?) {
    if let priceString = rawPrice {
      let price = priceString.doubleValue
      
      let formatter = NumberFormatter()
      formatter.numberStyle = NumberFormatter.Style.currency
      formatter.currencyGroupingSeparator = "."
      formatter.maximumFractionDigits = 0
      formatter.currencySymbol = ""
      
      if let formattedPrice = formatter.string(from: price as NSNumber) {
          askingPrice = formattedPrice
      }
    }
  }
}
