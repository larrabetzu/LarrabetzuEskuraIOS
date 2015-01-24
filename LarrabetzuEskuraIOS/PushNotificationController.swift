import Foundation

class PushNotificationController : NSObject {
    
    override init() {
        super.init()
        
        let parseApplicationId = valueForAPIKey(keyname: "PARSE_APPLICATION_ID")
        let parseClientKey     = valueForAPIKey(keyname: "PARSE_CLIENT_KEY")
        
        ParseCrashReporting.enable()

        Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
        
    }
    
}