///
/// - Author
/// Abel Gancsos
///
/// - Synopisis
/// Prototype for a much larger project to crawl positions from a list of companies
///
import Foundation
import Combine

public enum ResultState : Int, CaseIterable {
    case NEW
    case REVIEWED
    case APPLIED
    case OFFERED
    case ACCEPTED
    case REJECTED
}

class Result {
    public var resultId        : Int = -1;
    public var code            : String = "";
    public var lastUpdatedDate : String = "";
    public var postedDate      : String = "";
    public var applied         : Bool = false;
    public var title           : String = "";
    public var description     : String = "";
    public var required        : String = "";
    public var optional        : String = "";
    public var benefits        : String = "";
    public var otherDetails    : String = "";
    public var minYearsNeeded  : Int = 0;
    public var sourceEndpoint  : String = "";
    public var state           : ResultState = .NEW;
}

class JobCrawler {
	private static var session     : URLSession = .shared;
	public static var verbose      : Bool = false;
	public static var timeout      : Double = 2.0;
	public static var maxRetries   : Int = 500;

	private static func rawMessageRequest(request : URLRequest, contentType : String = "application/json",  attempt: Int = 0, _ completion: @escaping (String) -> ()) {
        var request2 = request;
        self.session.configuration.urlCredentialStorage = nil;
        request2.timeoutInterval = Double(timeout);
        request2.addValue("application/json", forHTTPHeaderField: "Accept");
        request2.addValue(contentType, forHTTPHeaderField: "Content-Type");
        session.reset {
            let task = session.dataTask(with: request2) {(data, response, error) in
                let dataString = String(data: (data ?? "".data(using: .utf8))!, encoding: .utf8)!
                if ((response as? HTTPURLResponse)?.statusCode ?? 404 != 200) {
                    if (attempt < maxRetries) {
                        rawMessageRequest(request: request2, contentType: contentType, attempt: attempt + 1, { rsp2 in
                            completion(rsp2);
                        });
                    }
                    else {
                        completion("Error");
                    }
                }
                else {
                    completion(dataString)
                };
            };
            if (task.error != nil) {
                completion("Error");
            }
            task.resume();
        }
    }

	private static func extractCareerPage(raw: String, company: String) -> String {
		let regex = try! NSRegularExpression(pattern: "\\<a [^\\>]*\\>[^\\<]*(careers|jobs)</a\\>", options: [.caseInsensitive]);
        let match = regex.firstMatch(in: raw, options: [], range: NSRange(location: 0, length: raw.count));
        if (match != nil) {
            var result = String((raw as NSString).substring(with: match!.range)).components(separatedBy: "href=")[1];
            result = result.components(separatedBy: ">")[0].replacingOccurrences(of: "\"", with: "");
            if (result.prefix(1) == "/") { result = "https://www.\(company).com/\(result)"; }
			return result;
		}
		else {
			return "";
		}
	}

	private static func extractTargetCareersPage(raw: String, company: String) -> String {
		var regex = try! NSRegularExpression(pattern: "\\<form[^\\>]*.*\\</form\\>>", options: [.caseInsensitive]);
        var match = regex.firstMatch(in: raw, options: [], range: NSRange(location: 0, length: raw.count));
        if (match != nil) {
            var result = String((raw as NSString).substring(with: match!.range));
            result = result.components(separatedBy: ">")[0].replacingOccurrences(of: "\"", with: "");
            if (result.prefix(1) == "/") { result = "https://www.\(company).com/\(result)"; }
            return result;
        }
		else {
            regex = try! NSRegularExpression(pattern: "redirect[^\\\"]*(careers|jobs)[^\\\"]*\\\"", options: [.caseInsensitive]);
            match = regex.firstMatch(in: raw, options: [], range: NSRange(location: 0, length: raw.count));
            if (match != nil) {
                var result = String((raw as NSString).substring(with: match!.range)).replacingOccurrences(of: "\"", with: "");
				result = result.components(separatedBy: "url=")[1].removingPercentEncoding!;
                return result;
            }
            else{
                return "";
            }
        }
	}

	private static func extractResult(url: String, company: String, _ completion: @escaping (Result) -> ()) {
		rawMessageRequest(request: URLRequest(url: URL(string: url)!), contentType: "application/json", attempt: 0, { rsp in
			let result   : Result = Result();
        	result.sourceEndpoint = url;
        	let comps = url.components(separatedBy: "/");
        	result.code = comps[comps.count - 1];
			let regex = try! NSRegularExpression(pattern: "title\\\"[^\\>]*\\>[^\\<]*", options: [.caseInsensitive]);
        	let match = regex.firstMatch(in: rsp, options: [], range: NSRange(location: 0, length: rsp.count));
			if (match != nil) {
				var title = String((rsp as NSString).substring(with: match!.range));
				let comps2 = title.components(separatedBy: "content=");
				if (comps2.count > 1) {
					title = comps2[1].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ">", with: "");
				}
				result.title = title;
			}
			completion(result);
		});
	}

	private static func filterResults(raw: String, company: String, _ completion: @escaping ([Result]) -> ()) {
		var results   : [Result] = [];
		let group     : DispatchGroup = DispatchGroup();
		let regex = try! NSRegularExpression(pattern: "\\<a [^\\>]*\\>[^\\<]*\\</a\\>", options: [.caseInsensitive]);
        let matches = regex.matches(in: raw, options: [], range: NSRange(location: 0, length: raw.count));
		for match in matches {
           	var result = String((raw as NSString).substring(with: match.range)).components(separatedBy: "href=")[1].components(separatedBy: " ")[0];
           	result = result.components(separatedBy: ">")[0].replacingOccurrences(of: "\"", with: "");
           	if (result.prefix(1) == "/") { result = "https://www.\(company).com/\(result)"; }
			if (result == "https://www.\(company).com/" || result.replacingOccurrences(of: "http", with: "") == result) { continue; }
			group.enter();
			extractResult(url: result, company: company, { rsp in 
				if (rsp.title != "") {
					results.append(rsp); 
				}
				group.leave();
			});
		}
		group.notify(queue: DispatchQueue.main, execute: { completion(results); });
	}

	public static func crawlCompany(company : String, _ completion: @escaping ([Result]) -> ()) {
		rawMessageRequest(request: URLRequest(url: URL(string: "https://www.\(company).com")!), contentType: "application/json", attempt: 0, { rsp in 
			let careersPage = extractCareerPage(raw: rsp, company: company).replacingOccurrences(of: "//", with: "/");	
			if (careersPage != "") {
				rawMessageRequest(request: URLRequest(url: URL(string: careersPage)!), contentType: "application/json", attempt: 0, { rsp2 in
					let targetCareersPage = extractTargetCareersPage(raw: rsp2, company: company);
					if (targetCareersPage != "") {
						rawMessageRequest(request: URLRequest(url: URL(string: targetCareersPage)!), contentType: "application/json", attempt: 0, { rsp3 in
							filterResults(raw: rsp3, company: company, { rsp4 in completion(rsp4); });
						});
					}
				});
			}
			else {
				completion([]);
			}
		});
	}
}

let group = DispatchGroup();
var companies   : [String] = [];

// Parse through arguments
for i : Int in 0..<CommandLine.arguments.count {
    if (CommandLine.arguments[i] == "-v") {
        JobCrawler.verbose = true;
    }
	else if (CommandLine.arguments[i] == "-t") {
		JobCrawler.timeout = Double(CommandLine.arguments[i + 1]) ?? 10.0;
	}
	else if (CommandLine.arguments[i] == "-r") {
		JobCrawler.maxRetries = Int(CommandLine.arguments[i + 1]) ?? 500;
	}
}

// Loop through companies (this would come from the profile)
for company : String in companies {
	group.enter();
	DispatchQueue.global().sync {
		group.enter();
        print("* \(company)");

		// Crawl positions from company careers page	
        JobCrawler.crawlCompany(company: company, { rsp in
        	for result in rsp {
               print("  * \(result.sourceEndpoint) (\(result.title))");
           	}
            group.leave();
        });
    }
    group.leave();
}
group.notify(queue: DispatchQueue.main) {
    exit(0);
}
dispatchMain();
