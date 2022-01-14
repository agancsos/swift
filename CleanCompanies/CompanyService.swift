import Foundation

public class CompanyService {
    private static var session      : URLSession = .shared;
    private static var verbose      : Bool = false;
    private static var timeout      : Double = 2.0;
    private static var maxRetries   : Int = 500;
    private static func rawMessageRequest(request : URLRequest, attempt: Int = 0) -> String {
        var request2 = request;
        let group = DispatchGroup();
        self.session.configuration.urlCredentialStorage = nil;
        request2.timeoutInterval = Double(timeout);
        var result = "";
        group.enter();
        let task = session.dataTask(with: request2) {(data, response, error) in
            let dataString = String(data: (data ?? "".data(using: .utf8))!, encoding: .utf8)!
            if ((response as? HTTPURLResponse)?.statusCode ?? 404 != 200) {
                if (attempt < maxRetries) {
                    result = rawMessageRequest(request: request2, attempt: attempt + 1);
                    group.leave();
                }
                else {
                    group.leave();
                }
            }
            else {
                result = dataString;
                group.leave();
            };
        };
        task.resume();
	group.wait(timeout: DispatchTime.now() + DispatchTimeInterval.seconds(30));
        return result;
    }

    public static func extractRating(url: String) -> Double {
        let pattern = "Working-at[^\"]+\"";
        let uri = URL(string: "\(url)");
        if uri == nil { return 9999.9999; }
        var rawHtml = "";
        var req = URLRequest(url: uri!);
        req.addValue("PostmanRuntime/7.26.8", forHTTPHeaderField: "User-Agent");
        req.httpMethod = "POST";
        req.httpBody = "{\"sc.keyword\":\"\(String(url.split(separator: "=")[1]))\"}".data(using: .utf8);
        rawHtml = rawMessageRequest(request: req, attempt: 0);
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive]);
            let matches = regex.matches(in: rawHtml, range: NSRange(rawHtml.startIndex..., in: rawHtml));
            for match in matches {
                let entry = String(rawHtml[Range(match.range, in: rawHtml)!]).replacingOccurrences(of: "\"", with: "");
				if entry.contains("\(String(url.replacingOccurrences(of: " ", with: "-").split(separator: "=")[1]))-EI_") {
					let uri2 = URL(string: "https://www.glassdoor.com/Overview/\(entry)");
					if uri2 == nil { return 9999.9999; }
					var req2 = URLRequest(url: uri2!);
					req2.addValue("PostmanRuntime/7.26.8", forHTTPHeaderField: "User-Agent");
					let rawHtml2 = rawMessageRequest(request: req2, attempt: 0);
					let regex2 = try NSRegularExpression(pattern: "ratingValue\" : \"[^\"]+", options: [.caseInsensitive]);
					let matches2 = regex2.matches(in: rawHtml2, range: NSRange(rawHtml2.startIndex..., in: rawHtml2));
					if matches2.count > 0 {
						let match2 = matches2[0];
						let rawRating = String(rawHtml2[Range(match2.range, in: rawHtml2)!]).replacingOccurrences(of: "ratingValue\" : \"", with: "");
						return Double(rawRating) ?? 9999.9999;
					}
				}
            }
        }
        catch {
        }
        return 9999.99999;
    }
}
