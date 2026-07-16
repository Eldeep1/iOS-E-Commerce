//
//  GeographicData.swift
//  Buyza App
//

import Foundation

struct GeographicData {
    static let usStates = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
        "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
        "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
        "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
        "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
        "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
        "Wisconsin", "Wyoming", "District of Columbia"
    ]
    
    static let canadianProvinces = [
        "Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador",
        "Nova Scotia", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan",
        "Northwest Territories", "Nunavut", "Yukon"
    ]
    
    static let citiesByProvince: [String: [String]] = [
        // US States
        "Alabama": ["Birmingham", "Montgomery", "Huntsville", "Mobile", "Tuscaloosa", "Hoover", "Dothan", "Auburn", "Decatur", "Madison"],
        "Alaska": ["Anchorage", "Fairbanks", "Juneau", "Sitka", "Ketchikan", "Wasilla", "Kenai", "Kodiak", "Bethel", "Palmer"],
        "Arizona": ["Phoenix", "Tucson", "Mesa", "Chandler", "Scottsdale", "Glendale", "Gilbert", "Tempe", "Peoria", "Surprise", "Yuma", "Flagstaff"],
        "Arkansas": ["Little Rock", "Fort Smith", "Fayetteville", "Springdale", "Jonesboro", "North Little Rock", "Conway", "Rogers", "Bentonville", "Pine Bluff"],
        "California": ["Los Angeles", "San Diego", "San Jose", "San Francisco", "Fresno", "Sacramento", "Long Beach", "Oakland", "Bakersfield", "Anaheim", "Santa Ana", "Riverside", "Irvine", "Stockton", "Chula Vista", "Fremont", "San Bernardino", "Modesto", "Pasadena", "Glendale"],
        "Colorado": ["Denver", "Colorado Springs", "Aurora", "Fort Collins", "Lakewood", "Thornton", "Arvada", "Westminster", "Pueblo", "Centennial", "Boulder", "Greeley", "Longmont"],
        "Connecticut": ["Bridgeport", "New Haven", "Stamford", "Hartford", "Waterbury", "Norwalk", "Danbury", "New Britain", "West Hartford", "Greenwich", "Fairfield"],
        "Delaware": ["Wilmington", "Dover", "Newark", "Middletown", "Smyrna", "Milford", "Seaford", "Georgetown", "Elsmere", "New Castle"],
        "Florida": ["Jacksonville", "Miami", "Tampa", "Orlando", "St. Petersburg", "Hialeah", "Port St. Lucie", "Tallahassee", "Cape Coral", "Fort Lauderdale", "Pembroke Pines", "Hollywood", "Miramar", "Gainesville", "Coral Springs", "Clearwater", "Palm Bay", "West Palm Beach"],
        "Georgia": ["Atlanta", "Augusta", "Columbus", "Macon", "Savannah", "Athens", "Sandy Springs", "Roswell", "Johns Creek", "Albany", "Warner Robins", "Alpharetta", "Marietta", "Valdosta"],
        "Hawaii": ["Honolulu", "East Honolulu", "Pearl City", "Hilo", "Kailua", "Waipahu", "Kaneohe", "Mililani Town", "Kahului", "Ewa Gentry", "Kihei", "Kapolei"],
        "Idaho": ["Boise", "Meridian", "Nampa", "Idaho Falls", "Pocatello", "Caldwell", "Coeur d'Alene", "Twin Falls", "Post Falls", "Lewiston", "Rexburg"],
        "Illinois": ["Chicago", "Aurora", "Joliet", "Naperville", "Rockford", "Springfield", "Peoria", "Elgin", "Waukegan", "Cicero", "Champaign", "Bloomington", "Arlington Heights", "Evanston", "Decatur"],
        "Indiana": ["Indianapolis", "Fort Wayne", "Evansville", "South Bend", "Carmel", "Fishers", "Bloomington", "Hammond", "Gary", "Lafayette", "Muncie", "Noblesville", "Terre Haute", "Kokomo"],
        "Iowa": ["Des Moines", "Cedar Rapids", "Davenport", "Sioux City", "Iowa City", "Waterloo", "Ames", "West Des Moines", "Council Bluffs", "Dubuque", "Ankeny", "Urbandale"],
        "Kansas": ["Wichita", "Overland Park", "Kansas City", "Olathe", "Topeka", "Lawrence", "Shawnee", "Manhattan", "Lenexa", "Salina", "Hutchinson"],
        "Kentucky": ["Louisville", "Lexington", "Bowling Green", "Owensboro", "Covington", "Richmond", "Georgetown", "Florence", "Hopkinsville", "Nicholasville", "Elizabethtown"],
        "Louisiana": ["New Orleans", "Baton Rouge", "Shreveport", "Metairie", "Lafayette", "Lake Charles", "Kenner", "Bossier City", "Monroe", "Alexandria", "Houma"],
        "Maine": ["Portland", "Lewiston", "Bangor", "South Portland", "Auburn", "Biddeford", "Sanford", "Saco", "Westbrook", "Augusta", "Waterville"],
        "Maryland": ["Baltimore", "Columbia", "Germantown", "Silver Spring", "Waldorf", "Glen Burnie", "Ellicott City", "Frederick", "Dundalk", "Rockville", "Bethesda", "Gaithersburg", "Towson", "Bowie"],
        "Massachusetts": ["Boston", "Worcester", "Springfield", "Cambridge", "Lowell", "Brockton", "New Bedford", "Quincy", "Lynn", "Fall River", "Newton", "Lawrence", "Somerville", "Framingham"],
        "Michigan": ["Detroit", "Grand Rapids", "Warren", "Sterling Heights", "Ann Arbor", "Lansing", "Dearborn", "Clinton Township", "Livonia", "Troy", "Macomb", "Westland", "Flint", "Southfield", "Kalamazoo"],
        "Minnesota": ["Minneapolis", "St. Paul", "Rochester", "Duluth", "Bloomington", "Brooklyn Park", "Plymouth", "St. Cloud", "Woodbury", "Eagan", "Maple Grove", "Eden Prairie", "Coon Rapids", "Burnsville"],
        "Mississippi": ["Jackson", "Gulfport", "Southaven", "Biloxi", "Hattiesburg", "Olive Branch", "Tupelo", "Meridian", "Greenville", "Madison", "Clinton", "Pearl"],
        "Missouri": ["Kansas City", "St. Louis", "Springfield", "Columbia", "Independence", "Lee's Summit", "O'Fallon", "St. Joseph", "St. Charles", "St. Peters", "Blue Springs", "Florissant", "Joplin"],
        "Montana": ["Billings", "Missoula", "Great Falls", "Bozeman", "Butte", "Helena", "Kalispell", "Belgrade", "Havre", "Anaconda", "Miles City"],
        "Nebraska": ["Omaha", "Lincoln", "Bellevue", "Grand Island", "Kearney", "Fremont", "Hastings", "North Platte", "Norfolk", "Columbus", "Papillion"],
        "Nevada": ["Las Vegas", "Henderson", "Reno", "North Las Vegas", "Sparks", "Carson City", "Fernley", "Elko", "Mesquite", "Boulder City", "Fallon"],
        "New Hampshire": ["Manchester", "Nashua", "Concord", "Derry", "Dover", "Rochester", "Salem", "Merrimack", "Hudson", "Londonderry", "Keene", "Portsmouth"],
        "New Jersey": ["Newark", "Jersey City", "Paterson", "Elizabeth", "Edison", "Woodbridge", "Lakewood", "Toms River", "Hamilton", "Clifton", "Trenton", "Camden", "Brick", "Cherry Hill", "Passaic"],
        "New Mexico": ["Albuquerque", "Las Cruces", "Rio Rancho", "Santa Fe", "Roswell", "Farmington", "Clovis", "Hobbs", "Alamogordo", "Carlsbad", "Gallup"],
        "New York": ["New York City", "Buffalo", "Rochester", "Yonkers", "Syracuse", "Albany", "New Rochelle", "Mount Vernon", "Schenectady", "Utica", "White Plains", "Hempstead", "Troy", "Binghamton", "Long Beach"],
        "North Carolina": ["Charlotte", "Raleigh", "Greensboro", "Durham", "Winston-Salem", "Fayetteville", "Cary", "Wilmington", "High Point", "Concord", "Greenville", "Asheville", "Gastonia", "Jacksonville"],
        "North Dakota": ["Fargo", "Bismarck", "Grand Forks", "Minot", "West Fargo", "Williston", "Dickinson", "Mandan", "Jamestown", "Wahpeton"],
        "Ohio": ["Columbus", "Cleveland", "Cincinnati", "Toledo", "Akron", "Dayton", "Parma", "Canton", "Youngstown", "Lorain", "Hamilton", "Springfield", "Kettering", "Elyria", "Lakewood"],
        "Oklahoma": ["Oklahoma City", "Tulsa", "Norman", "Broken Arrow", "Edmond", "Lawton", "Moore", "Midwest City", "Enid", "Stillwater", "Muskogee"],
        "Oregon": ["Portland", "Salem", "Eugene", "Gresham", "Hillsboro", "Beaverton", "Bend", "Medford", "Springfield", "Corvallis", "Albany", "Tigard", "Lake Oswego"],
        "Pennsylvania": ["Philadelphia", "Pittsburgh", "Allentown", "Erie", "Reading", "Scranton", "Bethlehem", "Lancaster", "Harrisburg", "Altoona", "York", "State College", "Wilkes-Barre", "Chester"],
        "Rhode Island": ["Providence", "Cranston", "Warwick", "Pawtucket", "East Providence", "Woonsocket", "Newport", "Central Falls", "Westerly", "Newport"],
        "South Carolina": ["Charleston", "Columbia", "North Charleston", "Mount Pleasant", "Rock Hill", "Greenville", "Summerville", "Sumter", "Goose Creek", "Hilton Head Island", "Florence", "Spartanburg"],
        "South Dakota": ["Sioux Falls", "Rapid City", "Aberdeen", "Brookings", "Watertown", "Mitchell", "Yankton", "Pierre", "Huron", "Spearfish"],
        "Tennessee": ["Nashville", "Memphis", "Knoxville", "Chattanooga", "Clarksville", "Murfreesboro", "Franklin", "Jackson", "Johnson City", "Bartlett", "Hendersonville", "Kingsport"],
        "Texas": ["Houston", "San Antonio", "Dallas", "Austin", "Fort Worth", "El Paso", "Arlington", "Corpus Christi", "Plano", "Laredo", "Lubbock", "Garland", "Irving", "Amarillo", "Grand Prairie", "Brownsville", "McKinney", "Frisco", "Pasadena", "Mesquite"],
        "Utah": ["Salt Lake City", "West Valley City", "Provo", "West Jordan", "Orem", "Sandy", "Ogden", "St. George", "Layton", "South Jordan", "Lehi", "Millcreek", "Taylorsville"],
        "Vermont": ["Burlington", "South Burlington", "Rutland", "Barre", "Montpelier", "Winooski", "St. Albans", "Newport", "Vergennes", "Essex Junction"],
        "Virginia": ["Virginia Beach", "Norfolk", "Chesapeake", "Richmond", "Newport News", "Alexandria", "Hampton", "Roanoke", "Portsmouth", "Suffolk", "Lynchburg", "Harrisonburg", "Charlottesville", "Danville"],
        "Washington": ["Seattle", "Spokane", "Tacoma", "Vancouver", "Bellevue", "Kent", "Everett", "Renton", "Spokane Valley", "Federal Way", "Yakima", "Kirkland", "Bellingham", "Kennewick", "Auburn"],
        "West Virginia": ["Charleston", "Huntington", "Morgantown", "Parkersburg", "Wheeling", "Fairmont", "Weirton", "Martinsburg", "Beckley", "Clarksburg"],
        "Wisconsin": ["Milwaukee", "Madison", "Green Bay", "Kenosha", "Racine", "Appleton", "Waukesha", "Eau Claire", "Oshkosh", "Janesville", "West Allis", "La Crosse", "Sheboygan"],
        "Wyoming": ["Cheyenne", "Casper", "Laramie", "Gillette", "Rock Springs", "Sheridan", "Green River", "Evanston", "Riverton", "Jackson"],
        "District of Columbia": ["Washington D.C."],
        
        // Canadian Provinces / Territories
        "Alberta": ["Calgary", "Edmonton", "Red Deer", "Lethbridge", "St. Albert", "Medicine Hat", "Grande Prairie", "Airdrie", "Spruce Grove", "Leduc"],
        "British Columbia": ["Vancouver", "Surrey", "Burnaby", "Richmond", "Abbotsford", "Coquitlam", "Kelowna", "Langley", "Saanich", "Delta", "Victoria", "Nanaimo", "Kamloops"],
        "Manitoba": ["Winnipeg", "Brandon", "Steinbach", "Thompson", "Portage la Prairie", "Winkler", "Selkirk", "Morden", "Dauphin", "The Pas"],
        "New Brunswick": ["Moncton", "Saint John", "Fredericton", "Dieppe", "Riverview", "Quispamsis", "Miramichi", "Edmundston", "Bathurst", "Oromocto"],
        "Newfoundland and Labrador": ["St. John's", "Conception Bay South", "Mount Pearl", "Paradise", "Corner Brook", "Grand Falls-Windsor", "Gander", "Portugal Cove-St. Philip's", "Torbay", "Labrador City"],
        "Nova Scotia": ["Halifax", "Sydney", "Dartmouth", "Truro", "New Glasgow", "Glace Bay", "Kentville", "Sydney Mines", "Amherst", "New Waterford"],
        "Ontario": ["Toronto", "Ottawa", "Mississauga", "Brampton", "Hamilton", "London", "Markham", "Vaughan", "Kitchener", "Windsor", "Burlington", "Greater Sudbury", "Oshawa", "Barrie", "St. Catharines", "Cambridge", "Kingston", "Guelph", "Thunder Bay", "Waterloo"],
        "Prince Edward Island": ["Charlottetown", "Summerside", "Stratford", "Cornwall", "Montague", "Kensington", "Souris", "Alberton", "Tignish", "Georgetown"],
        "Quebec": ["Montreal", "Quebec City", "Laval", "Gatineau", "Longueuil", "Sherbrooke", "Saguenay", "Lévis", "Trois-Rivières", "Terrebonne", "Saint-Jean-sur-Richelieu", "Brossard", "Repentigny"],
        "Saskatchewan": ["Saskatoon", "Regina", "Prince Albert", "Moose Jaw", "Swift Current", "Yorkton", "North Battleford", "Estevan", "Weyburn", "Lloydminster"],
        "Northwest Territories": ["Yellowknife", "Hay River", "Inuvik", "Fort Smith", "Behchokǫ̀", "Fort Simpson", "Tuktoyaktuk"],
        "Nunavut": ["Iqaluit", "Rankin Inlet", "Arviat", "Baker Lake", "Cambridge Bay", "Pond Inlet", "Igloolik"],
        "Yukon": ["Whitehorse", "Dawson City", "Watson Lake", "Haines Junction", "Carmacks", "Faro", "Mayo"]
    ]
    
    static func cities(for province: String) -> [String] {
        return citiesByProvince[province] ?? ["Central City", "North City", "South City", "West City", "East City"]
    }
    
    // MARK: - Validation Resources
    
    static let zipRanges: [String: [ClosedRange<Int>]] = [
        "Alabama": [350...369],
        "Alaska": [995...999],
        "Arizona": [850...865],
        "Arkansas": [716...729],
        "California": [900...961],
        "Colorado": [800...816],
        "Connecticut": [60...69],
        "Delaware": [197...199],
        "Florida": [320...349],
        "Georgia": [300...319, 398...399],
        "Hawaii": [967...968],
        "Idaho": [832...839],
        "Illinois": [600...629],
        "Indiana": [460...479],
        "Iowa": [500...528],
        "Kansas": [660...679],
        "Kentucky": [400...427],
        "Louisiana": [700...715],
        "Maine": [40...49],
        "Maryland": [206...212, 214...219],
        "Massachusetts": [10...27],
        "Michigan": [480...499],
        "Minnesota": [550...567],
        "Mississippi": [386...397],
        "Missouri": [630...658],
        "Montana": [590...599],
        "Nebraska": [680...693],
        "Nevada": [889...898],
        "New Hampshire": [30...38],
        "New Jersey": [70...89],
        "New Mexico": [870...884],
        "New York": [100...149],
        "North Carolina": [270...289],
        "North Dakota": [580...588],
        "Ohio": [430...458],
        "Oklahoma": [730...749],
        "Oregon": [970...979],
        "Pennsylvania": [150...196],
        "Rhode Island": [28...29],
        "South Carolina": [290...299],
        "South Dakota": [570...577],
        "Tennessee": [370...385],
        "Texas": [750...799, 885...885],
        "Utah": [840...847],
        "Vermont": [50...59],
        "Virginia": [201...201, 220...246],
        "Washington": [980...994],
        "West Virginia": [247...269],
        "Wisconsin": [530...549],
        "Wyoming": [820...831],
        "District of Columbia": [200...205, 209...209, 569...569]
    ]

    static func isValidZip(_ zip: String, for province: String, in country: String) -> Bool {
        let cleanZip = zip.trimmingCharacters(in: .whitespaces).uppercased()
        
        if country == "Canada" {
            guard cleanZip.range(of: "^[A-Z]\\d[A-Z] ?\\d[A-Z]\\d$", options: .regularExpression) != nil else {
                return false
            }
            let firstChar = String(cleanZip.prefix(1))
            let validPrefixes: [String: [String]] = [
                "Alberta": ["T"],
                "British Columbia": ["V"],
                "Manitoba": ["R"],
                "New Brunswick": ["E"],
                "Newfoundland and Labrador": ["A"],
                "Nova Scotia": ["B"],
                "Ontario": ["K", "L", "M", "N", "P"],
                "Prince Edward Island": ["C"],
                "Quebec": ["G", "H", "J"],
                "Saskatchewan": ["S"],
                "Northwest Territories": ["X"],
                "Nunavut": ["X"],
                "Yukon": ["Y"]
            ]
            if let prefixes = validPrefixes[province] {
                return prefixes.contains(firstChar)
            }
            return true
            
        } else if country == "United States" {
            guard cleanZip.range(of: "^\\d{5}(-\\d{4})?$", options: .regularExpression) != nil else {
                return false
            }
            
            guard let prefix3 = Int(cleanZip.prefix(3)) else { return false }
            
            if let ranges = zipRanges[province] {
                return ranges.contains { $0.contains(prefix3) }
            }
            return true
        }
        
        return true
    }
    
    // MARK: - Phone Number Validation
    static let validAreaCodes: Set<String> = [
        "201", "202", "203", "204", "205", "206", "207", "208", "209", "210",
        "211", "212", "213", "214", "215", "216", "217", "218", "219", "220",
        "223", "224", "225", "226", "227", "228", "229", "231", "234", "235",
        "236", "239", "240", "242", "246", "248", "249", "250", "251", "252",
        "253", "254", "256", "257", "260", "262", "263", "264", "267", "268",
        "269", "270", "272", "274", "276", "279", "281", "283", "284", "285",
        "286", "289", "301", "302", "303", "304", "305", "306", "307", "308",
        "309", "310", "311", "312", "313", "314", "315", "316", "317", "318",
        "319", "320", "321", "323", "324", "325", "326", "327", "328", "329",
        "330", "331", "332", "334", "335", "336", "337", "338", "339", "340",
        "341", "343", "345", "346", "347", "350", "351", "352", "353", "354",
        "357", "359", "360", "361", "363", "364", "365", "367", "368", "369",
        "372", "377", "380", "382", "384", "385", "386", "401", "402", "403",
        "404", "405", "406", "407", "408", "409", "410", "411", "412", "413",
        "414", "415", "416", "417", "418", "419", "420", "423", "424", "425",
        "426", "428", "430", "431", "432", "434", "435", "436", "437", "438",
        "440", "441", "442", "443", "445", "447", "448", "450", "456", "457",
        "458", "461", "463", "464", "465", "468", "469", "470", "471", "472",
        "473", "474", "475", "478", "479", "480", "483", "484", "500", "501",
        "502", "503", "504", "505", "506", "507", "508", "509", "510", "511",
        "512", "513", "514", "515", "516", "517", "518", "519", "520", "521",
        "522", "523", "524", "525", "526", "527", "528", "529", "530", "531",
        "532", "533", "534", "539", "540", "541", "544", "548", "551", "555",
        "557", "559", "561", "562", "563", "564", "566", "567", "570", "571",
        "572", "573", "574", "575", "577", "579", "580", "581", "582", "584",
        "585", "586", "587", "588", "600", "601", "602", "603", "604", "605",
        "606", "607", "608", "609", "610", "611", "612", "613", "614", "615",
        "616", "617", "618", "619", "620", "621", "622", "623", "624", "626",
        "628", "629", "630", "631", "633", "636", "639", "640", "641", "645",
        "646", "647", "649", "650", "651", "656", "657", "658", "659", "660",
        "661", "662", "664", "667", "669", "670", "671", "672", "678", "679",
        "680", "681", "682", "683", "684", "686", "689", "700", "701", "702",
        "703", "704", "705", "706", "707", "708", "709", "710", "711", "712",
        "713", "714", "715", "716", "717", "718", "719", "720", "721", "724",
        "725", "726", "727", "728", "729", "730", "731", "732", "734", "737",
        "738", "740", "742", "743", "747", "748", "753", "754", "757", "758",
        "760", "762", "763", "765", "767", "769", "770", "771", "772", "773",
        "774", "775", "778", "779", "780", "781", "782", "784", "785", "786",
        "787", "800", "801", "802", "803", "804", "805", "806", "807", "808",
        "809", "810", "811", "812", "813", "814", "815", "816", "817", "818",
        "819", "820", "821", "825", "826", "828", "829", "830", "831", "832",
        "833", "835", "837", "838", "839", "840", "843", "844", "845", "847",
        "848", "849", "850", "854", "855", "856", "857", "858", "859", "860",
        "861", "862", "863", "864", "865", "866", "867", "868", "869", "870",
        "872", "873", "876", "877", "878", "879", "888", "900", "901", "902",
        "903", "904", "905", "906", "907", "908", "909", "910", "911", "912",
        "913", "914", "915", "916", "917", "918", "919", "920", "924", "925",
        "928", "929", "930", "931", "932", "934", "936", "937", "938", "939",
        "940", "941", "942", "943", "945", "947", "948", "949", "950", "951",
        "952", "954", "956", "959", "970", "971", "972", "973", "975", "978",
        "979", "980", "983", "984", "985", "986", "988", "989"
    ]
    
    static func isValidPhoneNumber(_ phone: String, in country: String) -> Bool {
        if country == "Canada" || country == "United States" {
            let digits = phone.filter { $0.isNumber }
            
            // Check for valid 10 digit number
            let isValid10 = digits.count == 10 && !digits.hasPrefix("1") && !digits.hasPrefix("0")
            let isValid11 = digits.count == 11 && digits.hasPrefix("1")
            
            if isValid10 || isValid11 {
                // Get the area code
                let startIndex = isValid11 ? digits.index(digits.startIndex, offsetBy: 1) : digits.startIndex
                let endIndex = digits.index(startIndex, offsetBy: 3)
                let areaCode = String(digits[startIndex..<endIndex])
                
                return validAreaCodes.contains(areaCode)
            }
            
            return false
        }
        return phone.filter { $0.isNumber }.count >= 7
    }
    
    // MARK: - Sample Data Helpers
    
    static func samplePostalCode(for province: String, in country: String) -> String {
        if country == "Canada" {
            // Return a valid postal code prefix based on the province
            switch province {
            case "Alberta": return "T2P 1J9"
            case "British Columbia": return "V6B 1A1"
            case "Manitoba": return "R3C 1A5"
            case "New Brunswick": return "E3B 1A1"
            case "Newfoundland and Labrador": return "A1C 1A1"
            case "Nova Scotia": return "B3J 1A1"
            case "Ontario": return "M5V 2H1"
            case "Prince Edward Island": return "C1A 1A1"
            case "Quebec": return "H3B 1A1"
            case "Saskatchewan": return "S4P 1A1"
            case "Northwest Territories": return "X1A 2P7"
            case "Nunavut": return "X0A 0H0"
            case "Yukon": return "Y1A 2C6"
            default: return "K1A 0B1"
            }
        } else {
            // US ZIP code sample based on range
            if let ranges = zipRanges[province], let firstRange = ranges.first {
                let sampleZip = firstRange.lowerBound
                return String(format: "%05d", sampleZip * 100 + 1)
            }
            return "90210"
        }
    }
    
    static func samplePhoneNumber(for province: String, in country: String) -> String {
        if country == "United States" {
            switch province {
            case "Alabama": return "205"
            case "Alaska": return "907"
            case "Arizona": return "602"
            case "Arkansas": return "501"
            case "California": return "213"
            case "Colorado": return "303"
            case "Connecticut": return "860"
            case "Delaware": return "302"
            case "Florida": return "305"
            case "Georgia": return "404"
            case "Hawaii": return "808"
            case "Idaho": return "208"
            case "Illinois": return "312"
            case "Indiana": return "317"
            case "Iowa": return "515"
            case "Kansas": return "316"
            case "Kentucky": return "502"
            case "Louisiana": return "504"
            case "Maine": return "207"
            case "Maryland": return "410"
            case "Massachusetts": return "617"
            case "Michigan": return "313"
            case "Minnesota": return "612"
            case "Mississippi": return "601"
            case "Missouri": return "816"
            case "Montana": return "406"
            case "Nebraska": return "402"
            case "Nevada": return "702"
            case "New Hampshire": return "603"
            case "New Jersey": return "973"
            case "New Mexico": return "505"
            case "New York": return "212"
            case "North Carolina": return "704"
            case "North Dakota": return "701"
            case "Ohio": return "614"
            case "Oklahoma": return "405"
            case "Oregon": return "503"
            case "Pennsylvania": return "215"
            case "Rhode Island": return "401"
            case "South Carolina": return "803"
            case "South Dakota": return "605"
            case "Tennessee": return "615"
            case "Texas": return "713"
            case "Utah": return "801"
            case "Vermont": return "802"
            case "Virginia": return "804"
            case "Washington": return "206"
            case "West Virginia": return "304"
            case "Wisconsin": return "414"
            case "Wyoming": return "307"
            case "District of Columbia": return "202"
            default: return "555"
            }
        } else if country == "Canada" {
            switch province {
            case "Alberta": return "403"
            case "British Columbia": return "604"
            case "Manitoba": return "204"
            case "New Brunswick": return "506"
            case "Newfoundland and Labrador": return "709"
            case "Nova Scotia": return "902"
            case "Ontario": return "416"
            case "Prince Edward Island": return "902"
            case "Quebec": return "514"
            case "Saskatchewan": return "306"
            case "Northwest Territories": return "867"
            case "Nunavut": return "867"
            case "Yukon": return "867"
            default: return "555"
            }
        }
        return "555"
    }
}
