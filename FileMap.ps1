# Classe para facilitar a navegação no mapa de arquivos
#   FileMap <- NameMap <- VersionMap <- RemotionMap = 4 Classes, usadas para simplificar o acesso a $hashMap
#   NameMap, VersionMap, e RemotionMap utilizam $currentKey para acessar $hashMap. Há apenas 1 instância de cada
Class FileMap {
	# HASH_MAP
	[System.Collections.IDictionary] $hashMap = [ordered]@{};
	[NameMap] $nameMap;
	# MAIN
	FileMap() {
		$this.nameMap = [NameMap]::new($this);
	}
	# GET
	[VersionMap] Get($nameKey) {
		Return $this.nameMap.Get($nameKey);
	}
	# REMOVE
	[void] Remove($nameKey) {
		$this.nameMap.Remove($nameKey);
	}
	# LIST
	[object] List() {
		Return $this.nameMap.List();
	}
}
	Class NameMap {
		[FileMap] $fileMap;
		[string] $currentKey;
		[VersionMap] $versionMap;
		# MAIN
		NameMap([FileMap] $fileMap) {
			$this.fileMap = $fileMap;
			$this.versionMap = [VersionMap]::new($this);
		}
		[void] CheckMap($nameKey) {
			If(-Not $this.fileMap.hashMap.Contains($nameKey)) {
				$this.fileMap.hashMap[[object]$nameKey] = [ordered]@{};
			} ElseIf($this.fileMap.hashMap[[object]$nameKey].Count -eq 0) {
				$this.fileMap.hashMap.Remove([object]$nameKey);
			}
		}
		# GET
		[VersionMap] Get($nameKey) {
			$this.currentKey = $nameKey;
			$this.CheckMap($nameKey);
			Return $this.versionMap;
		}
		# REMOVE
		[void] Remove($nameKey) {
			$this.currentKey = $nameKey;
			$this.fileMap.hashMap.Remove([object]$nameKey);
		}
		# LIST
		[object] List() {
			Return $this.fileMap.hashMap.Keys;
		}
	}
		Class VersionMap {
			[NameMap] $nameMap;
			[int] $currentKey;
			[RemotionMap] $remotionMap;
			# MAIN
			VersionMap([NameMap] $nameMap) {
				$this.nameMap = $nameMap;
				$this.remotionMap = [RemotionMap]::new($this);
			}
			[void] CheckMap($versionKey) {
				$nameKey = $this.nameMap.currentKey;
				If(-Not $this.nameMap.fileMap.hashMap[[object]$nameKey].Contains($versionKey)) {
					$this.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey] = [ordered]@{};
				} ElseIf($this.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Count -eq 0) {
					$this.nameMap.fileMap.hashMap[[object]$nameKey].Remove([object]$versionKey);
				}
			}
			# GET
			[RemotionMap] Get($versionKey) {
				$this.currentKey = $versionKey;
				$this.CheckMap($versionKey);
				Return $this.remotionMap;
			}
			# REMOVE
			[void] Remove($versionKey) {
				$nameKey = $this.nameMap.currentKey;
				$this.currentKey = $versionKey;
				$this.nameMap.fileMap.hashMap[[object]$nameKey].Remove([object]$versionKey);
				$this.nameMap.CheckMap($nameKey);
			}
			# LIST
			[object] List() {
				$nameKey = $this.nameMap.currentKey;
				Return $this.nameMap.fileMap.hashMap[[object]$nameKey].Keys;
			}
		}
			Class RemotionMap {
				[VersionMap] $versionMap;
				[int] $currentKey;
				# MAIN
				RemotionMap([VersionMap] $versionMap) {
					$this.versionMap = $versionMap;
				}
				[void] CheckMap($remotionKey) {
					$nameKey = $this.versionMap.nameMap.currentKey;
					$versionKey = $this.versionMap.currentKey;
					If(-Not $this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Contains($remotionKey)) {
						$this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey] = $Null;
					}
				}
				# GET
				[object] Get($remotionKey) {
					$nameKey = $this.versionMap.nameMap.currentKey;
					$versionKey = $this.versionMap.currentKey;
					$this.currentKey = $remotionKey;
					$this.CheckMap($remotionKey);
					Return $this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey];
				}
				# SET
				[void] Set($remotionKey, $value) {
					$nameKey = $this.versionMap.nameMap.currentKey;
					$versionKey = $this.versionMap.currentKey;
					$this.currentKey = $remotionKey;
					$this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey] = $value;
				}
				# REMOVE
				[void] Remove($remotionKey) {
					$nameKey = $this.versionMap.nameMap.currentKey;
					$versionKey = $this.versionMap.currentKey;
					$this.currentKey = $remotionKey;
					$this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Remove([object]$remotionKey);
					$this.versionMap.CheckMap($versionKey);
				}
				# LIST
				[object] List() {
					$nameKey = $this.versionMap.nameMap.currentKey;
					$versionKey = $this.versionMap.currentKey;
					Return $this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Keys;
				}
			}
