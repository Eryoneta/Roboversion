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
	DeleteFilesList $modifiedFilesMap $filesToDelete $listOnly;
	# Da lista, renomeia arquivos
	RenameVersionedFilesList $modifiedFilesMap $filesToRename $listOnly;
	# Da lista, copia arquivos
	CopyVersionedFilesList $modifiedFilesMap $filesToCopy $listOnly;
	# Retorna mapa ordenado
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
	Return $modifiedFilesMap;
}