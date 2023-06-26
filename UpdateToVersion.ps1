# Atualiza os arquivos-a-serem-sobrescritos com uma nova versão
#   Da lista de arquivos-modificados em $origPath, criar uma nova versão desta, com " _version[v]"
#     Checar pelas versões existentes, e adicionar uma nova versão com index v maior de todos
#     Se o index v for maior do que $maxVersionLimit:
#       Este toma $maxVersionLimit, e o anterior toma $maxVersionLimit-1, etc
#       O que tiver " _version[0]" é deletado
#     Dessa forma, existem apenas versões de 1 até $maxVersionLimit
Function UpdateToVersion($modifiedFilesMap, $toModifyFilesMap, $maxVersionLimit, $listOnly) {
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	$filesToCopy = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $toModifyFilesMap.List()) {
		$toModifyFile = $toModifyFilesMap.Get($nameKey).Get(-1).Get(-1);
		$unoccupiedVersionIndex = $maxVersionLimit;
		$isVersioned = $False;
		# Existem versões
		If($modifiedFilesMap.Contains($nameKey)) {
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				# VersionIndex maiores que $maxVersionLimit são ignorados
				If($versionKey -gt $maxVersionLimit) {
					Continue;
				}
				If(-Not $isVersioned) {
					# Há um VersionIndex livre
					If($versionKey -lt $maxVersionLimit) {
						If($versionKey -eq -1) {
							$unoccupiedVersionIndex = 1;
						} Else {
							$unoccupiedVersionIndex = $versionKey + 1;
						}
						$Null = $filesToCopy.Add([PSCustomObject]@{
							File = $toModifyFile;
							NewVersion = $unoccupiedVersionIndex;
						});
						$isVersioned = $True;
						# Não é preciso renomear os outros
						Break;
					# Não há VersionIndex livres
					} Else {
						$unoccupiedVersionIndex = $maxVersionLimit;
						$Null = $filesToCopy.Add([PSCustomObject]@{
							File = $toModifyFile;
							NewVersion = $unoccupiedVersionIndex;
						});
						$isVersioned = $True;
						$unoccupiedVersionIndex--;
						ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
							$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
							$Null = $filesToRename.Add([PSCustomObject]@{
								File = $removedFile;
								NewVersion = $unoccupiedVersionIndex;
							});
						}
						$unoccupiedVersionIndex--;
						Continue;
					}
				} Else {
					# VersionIndex iguais a -1 são ignorados(São os sem versão)
					If($versionKey -eq -1) {
						Continue;
					}
					# Sem VersionIndex livres, então deletar
					If($unoccupiedVersionIndex -lt 1) {
						ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
							$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
							$Null = $filesToDelete.Add($removedFile);
						}
						Continue;
					}
					# VersionIndex menores que $maxVersionLimit devem permanecer assim
					If($versionKey -le $unoccupiedVersionIndex) {
						$unoccupiedVersionIndex = $versionKey;
						$unoccupiedVersionIndex--;
						Continue;
					}
					# Renomear com VersionIndex livre
					ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
						$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
						$Null = $filesToRename.Add([PSCustomObject]@{
							File = $removedFile;
							NewVersion = $unoccupiedVersionIndex;
						});
					}
					$unoccupiedVersionIndex--;
				}
			}
		}
		# Não existem versões
		If(-Not $isVersioned) {
			$unoccupiedVersionIndex = 1;
			$Null = $filesToCopy.Add([PSCustomObject]@{
				File = $toModifyFile;
				NewVersion = $unoccupiedVersionIndex;
			});
			$isVersioned = $True;
		}
	}
	# Da lista, deleta arquivos
	ForEach($fileToDelete In $filesToDelete) {
		# Deleta arquivo
		If($listOnly) {
			Write-Information -MessageData ("DELETE: " + $fileToDelete.Path) -InformationAction Continue;
		} Else {
			# TODO
		}
		# Deleta do fileMap
		$fileBasePath = (Split-Path -Path $fileToDelete.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToDelete.BaseName + $fileToDelete.Extension));
		$versionKey = $fileToDelete.VersionIndex;
		$remotionKey = $fileToDelete.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Remove($remotionKey);
	}
	# Da lista, renomeia arquivos
	ForEach($fileToRename In $filesToRename | Sort-Object -Property NewVersion) {
		$newVersion = $fileToRename.NewVersion;
		$fileToRename = $fileToRename.File;
		# Renomeia arquivo
		$version = (" " + $versionStart + $newVersion + $versionEnd);
		$remotion = "";
		If($fileToRename.RemotionCountdown -gt -1) {
			$remotion = (" " + $remotionStart + $fileToRename.RemotionCountdown + $remotionEnd);
		}
		$newName = ($fileToRename.BaseName + $version + $remotion + $fileToRename.Extension);
		If($listOnly) {
			Write-Information -MessageData ("RENAME: " + $fileToRename.Path + " -> " + $newName) -InformationAction Continue;
		} Else {
			# TODO
		}
		# Renomeia do fileMap
		$fileBasePath = (Split-Path -Path $fileToRename.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToRename.BaseName + $fileToRename.Extension));
		$versionKey = $fileToRename.VersionIndex;
		$remotionKey = $fileToRename.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Remove($remotionKey);
		$modifiedFilesMap.Get($nameKey).Get($newVersion).Set($remotionKey, $fileToRename);
		$fileToRename.Path = (Join-Path -Path $fileBasePath -ChildPath $newName);
		$fileToRename.VersionIndex = $newVersion;
	}
	# Da lista, copia arquivos
	ForEach($fileToCopy In $filesToCopy) {
		$newVersion = $fileToCopy.NewVersion;
		$fileToCopy = $fileToCopy.File;
		# Copia arquivo
		$version = (" " + $versionStart + $newVersion + $versionEnd);
		$remotion = "";
		If($fileToCopy.RemotionCountdown -gt -1) {
			$remotion = (" " + $remotionStart + $fileToCopy.RemotionCountdown + $remotionEnd);
		}
		$fileBasePath = (Split-Path -Path $fileToCopy.Path -Parent);
		$newName = ($fileToCopy.BaseName + $version + $remotion + $fileToCopy.Extension);
		$newPath = (Join-Path -Path $fileBasePath -ChildPath $newName);
		If($listOnly) {
			Write-Information -MessageData ("COPY: " + $fileToCopy.Path + " -> " + $newPath) -InformationAction Continue;
		} Else {
			# TODO
		}
		# Copia no fileMap
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToCopy.BaseName + $fileToCopy.Extension));
		$versionKey = $newVersion;
		$remotionKey = $fileToCopy.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Set($remotionKey, ([PSCustomObject]@{
			Path = $newPath;
			BaseName = $fileToCopy.BaseName;
			VersionIndex = $newVersion;
			RemotionCountdown = $fileToCopy.RemotionCountdown;
			Extension = $fileToCopy.Extension;
		}));
	}
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
	Return $modifiedFilesMap;
}