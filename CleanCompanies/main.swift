import Foundation

var fileName       = "";
var listName       = "";
var isDebug        = false;
var skipDuplicates = false;
var skipNonUs      = false;
var minRating      = -1.0;
var delaySeconds   = 5;
var baseEndpoint   = "https://www.glassdoor.com/Search/results.htm?keyword=";

for i : Int in 0..<CommandLine.arguments.count {
	if CommandLine.arguments[i] == "-f" { fileName = CommandLine.arguments[i + 1]; }
	else if CommandLine.arguments[i] == "-l" { listName = CommandLine.arguments[i + 1]; }
	else if CommandLine.arguments[i] == "--debug" { isDebug = true; }
	else if CommandLine.arguments[i] == "--skip" { skipDuplicates = true; }
	else if CommandLine.arguments[i] == "--skip-us-check" { skipNonUs = true; }
	else if CommandLine.arguments[i] == "--rating" { minRating = Double(CommandLine.arguments[i + 1]) ?? -1.0; }
	else if CommandLine.arguments[i] == "--delay" { delaySeconds = Int(CommandLine.arguments[i + 1]) ?? 5; }
}
let service = ReminderService();
if (listName == "") {
	service.getLists().forEach({ print($0.title); });
}
else {
	if fileName == "" && !skipDuplicates {
		print("Filename cannot be empty...");
		exit(-1);
	}

	let rawCompanies : [String] = [];
	if !skipDuplicates {
		try? String(contentsOf: URL(string: "file://\(fileName)")!, encoding: .utf8).split(separator: "\n");
	}
	let reminders = service.getList(name: listName);
	if reminders != nil {
		if !skipDuplicates {
			for company in rawCompanies {
				if service.entryExists(cal: reminders!, entry: String(company)) {
					print("Cleaning: '\(company)'");
					if !isDebug {
						service.removeReminder(reminder: service.getReminder(cal: reminders!, name: String(company))!);
					}
					let companyEntry = service.getReminder(cal: reminders!, name: String(company))!
					if skipNonUs || companyEntry.isCompleted { continue; }
					if (String(company).lowercased().contains(" gmbh") || String(company).lowercased().contains(" uk")) {
                    	print("Company (\(String(company))) is not in the US");
                    	if !isDebug {
                        	service.markCompleted(reminder: companyEntry);
                    	}
                	}
				}
			}
		}
		else {
			for company in service.getReminders(cal: reminders!)!{
				print("Cleaning: '\(company.title!)'");
				if company.isCompleted { continue; }
				if !skipNonUs {
            		if (company.title!.lowercased().contains(" gmbh") || company.title!.lowercased().contains(" uk")) {
                		print("Company (\(company.title!)) is not in the US");
                		if !isDebug {
                    		service.markCompleted(reminder: company);
                		}
            		}
				}

				if minRating > -1 {
					let companyRating = CompanyService.extractRating(url: "\(baseEndpoint)\(company.title!)");
					if companyRating < minRating {
						print("Company (\(company.title!)) has a low rating (\(companyRating))");
						if !isDebug {
							service.markCompleted(reminder: company);
						}
					}
				}
            }
		}	
	}
}

