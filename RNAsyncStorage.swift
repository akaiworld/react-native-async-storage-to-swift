

func parseJson( _ str_data: String? ) -> Any? {
	
	if( str_data == nil ){
		return nil
	}
	
	do {
		let data = str_data!.data(using: String.Encoding.utf8, allowLossyConversion: false)!
		return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
	}
	catch {
		print("parseJson ERROR:")
		print(error.localizedDescription)
		return nil
	}
}

class RNAsyncStorage {
	
	static var key = ""
	static var md5key = ""
	static let RCTStorageDirectory = "RCTAsyncLocalStorage_V1"
	static var path: URL?
	
	static func get(key: String, md5key: String) -> [CustomItem] {
		
		self.key = key
		self.md5key = md5key
		
		if let app_path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			path = app_path.appendingPathComponent(RCTStorageDirectory)
			
			if let data = checkManifest() {
				return convertData( data )
			} else if let data = checkFile() {
				return convertData( data )
			}
		}
		
		return [CustomItem]()
	}
	
	static func convertData( _ data: [AnyObject] ) -> [AnyObject] {
		
		// convert data code here
		
		let converted_data = [AnyObject]()
		
		return converted_data
	}
	
	static func checkManifest() -> [AnyObject]? {
		
		// get file data
		if let file_data = getFileData("manifest.json") {
			
			// try to parse file json data
			if let data = parseJson( file_data ) as? Dictionary<String, Any> {
				
				// check if our key exists
				if let data = data[key] {
					
					// and is not null
					if data is String {
						
						return keyValue( data as! String )
					}
				}
			}
		}
		
		return nil
	}
	
	static func checkFile() -> [AnyObject]? {
		
		// get file data
		if let file_data = getFileData(md5key) {
			
			return keyValue( file_data )
		}
		
		return nil
	}
	
	static func getFileData(_ name: String) -> String? {
		
		do {
			let file_path = path!.appendingPathComponent(name)
			
			// file exists
			if FileManager.default.fileExists(atPath: file_path.path) {
				let data = try String(contentsOf: file_path, encoding: String.Encoding.utf8)
				return data
			}
			
		} catch {
			print("ERROR READING FILE:")
			print(error.localizedDescription)
		}
		
		return nil
	}
	
	static func keyValue(_ data: String) -> [AnyObject]? {
		
		if let items = parseJson( data ) as? [AnyObject] {
			
			return items
		}
		
		return nil
	}
}
