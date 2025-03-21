import Flutter
import UIKit
import ComScore

public class FlutterComscorePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_comscore", binaryMessenger: registrar.messenger())
        let instance = FlutterComscorePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setup":
            guard let args = call.arguments as? String else {
                result("Empty arguments")
                return
            }
            
            do {
                try startComscore(args: JSONDecoder().decode(StartComscoreArgs.self, from: Data(args.utf8)))
            } catch {
                result("Error starting comscore: \(error)")
                return
            }
            
            result(nil)
        case "notifyViewEvent":
            guard let args = call.arguments as? String else {
                result("Empty arguments")
                return
            }
            
            do {
                let notifyViewEventArgs = try JSONDecoder().decode(NotifyViewEventArgs.self, from: Data(args.utf8))
                notifyViewEvent(category: notifyViewEventArgs.category, eventData: notifyViewEventArgs.eventData)
            } catch {
                result("Error comscore notifyingview event: \(error)")
                return
            }
            
            result(nil)
        case "notifyBackgroundUXStart":
            notifyBackgroundUXStart()
            result(nil)
        case "notifyBackgroundUXStop":
            notifyBackgroundUXStop()
            result(nil)
        case "setUserConsent":
            guard let args = call.arguments as? String else {
                result("Empty arguments")
                return
            }
            
            do {
                try setUserConsent(userConsent: args)
            } catch {
                result("Error comscore notifyingview event: \(error)")
                return
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func startComscore(args: StartComscoreArgs) throws {
        let infoDict = Bundle.main.infoDictionary
        guard let infoDict, let pubId = infoDict["FLUTTER_COMSCORE_PUBLISHER_ID"] as? String else {
            throw ComscoreError.pubIdNotFound
        }
        
        let myPublisherConfig = SCORPublisherConfiguration(builderBlock: { builder in
            builder?.publisherId = pubId
            
            if let userConsent = args.userConsent {
                builder?.persistentLabels = ["cs_ucfr": userConsent]
            }
        })
        
        SCORAnalytics.configuration().addClient(with:myPublisherConfig)
        SCORAnalytics.configuration().usagePropertiesAutoUpdateMode = .foregroundAndBackground
        
        if args.isChildDirected {
            SCORAnalytics.configuration().enableChildDirectedApplicationMode()
        }
        
        if args.debug {
            SCORAnalytics.configuration().enableImplementationValidationMode()
        }
        
        SCORAnalytics.start()
    }
    
    private func notifyViewEvent(category: String, eventData: [String: String]?) {
        var labels: [String: String] = [:]
        labels["ns_category"] = category
        if let eventData {
            labels.merge(eventData) { (current, new) in new }
        }
        
        SCORAnalytics.notifyViewEvent(withLabels: labels)
    }
    
    private func notifyBackgroundUXStart() {
        SCORAnalytics.notifyUxActive()
    }
    
    private func notifyBackgroundUXStop() {
        SCORAnalytics.notifyUxInactive()
    }
    
    private func setUserConsent(userConsent: String) throws {
        let infoDict = Bundle.main.infoDictionary
        guard let infoDict, let pubId = infoDict["FLUTTER_COMSCORE_PUBLISHER_ID"] as? String else {
            throw ComscoreError.pubIdNotFound
        }
        
        SCORAnalytics.configuration().publisherConfiguration(withPublisherId: pubId).setPersistentLabelWithName("cs_ucfr", value: userConsent)
    }
    
    enum ComscoreError: Error {
        case pubIdNotFound
    }
}
