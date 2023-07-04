# Atualiza os arquivos-a-serem-sobrescritos com uma nova versão
#   Da lista de arquivos-modificados em $origPath, criar uma nova versão desta, com "_version[v]"
#     Checar pelas versões existentes, e adicionar uma nova versão com index v maior de todos
#     Se o index v for maior do que $maxVersionLimit:
#       Este toma $maxVersionLimit, e o anterior toma $maxVersionLimit-1, etc
#       O que tiver "_version[0]" é deletado
#     Dessa forma, existem apenas versões de 1 até $maxVersionLimit
Function UpdateToVersion($modifiedFilesMap, $toModifyList, $maxVersionLimit, $listOnly) {
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	$filesToCopy = [System.Collections.ArrayList]::new();
	ForEach($toModifyFile In $toModifyList) {
		# Copia o a-ser-versionado, renomeando duplicatas, se houver
		UpdateToVersion_RenameOrDelete $modifiedFilesMap $filesToDelete $filesToRename $filesToCopy $toModifyFile $maxVersionLimit $True;
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
	Function UpdateToVersion_RenameOrDelete($modifiedFilesMap, $filesToDelete, $filesToRename, $filesToCopy, $file, $newVersionIndex, $copy) {
		# Deletar
		If($newVersionIndex -lt 1) {
			$Null = $filesToDelete.Add($file);
			Return;
		}
		# Se é um novo VersionIndex, tentar pegar o menor index livre
		$fileBasePath = (Split-Path -Path $file.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($file.BaseName + $file.Extension));
		If($copy) {
			If(-Not $modifiedFilesMap.Contains($nameKey)) {
				$newVersionIndex = 1;
			} Else {
				If($newVersionIndex -gt 1) {
					$versionKey = $($modifiedFilesMap.Get($nameKey).List())[0];
					# $newVersionIndex deve ser maior ou igual ao último VersionIndex
					If($versionKey -lt ($newVersionIndex -1)) {
						$newVersionIndex = ($versionKey + 1);
					}
				}
			}
		}
		# Copiar, aplicando novo VersionIndex
		If($copy) {
			$Null = $filesToCopy.Add([PSCustomObject]@{
				File = $file;
				NewVersion = $newVersionIndex;
			});
		# Renomear, aplicando novo com VersionIndex
		} Else {
			$Null = $filesToRename.Add([PSCustomObject]@{
				File = $file;
				NewVersion = $newVersionIndex;
			});
		}
		# Checar se não existe outro com mesmo VersionIndex
		$versionKey = $newVersionIndex;
		If($modifiedFilesMap.Contains($nameKey)) {
			If($modifiedFilesMap.Get($nameKey).Contains($versionKey)) {
				ForEach($remotionKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
					# Renomeia ou deleta duplicata
					UpdateToVersion_RenameOrDelete $modifiedFilesMap $filesToDelete $filesToRename $filesToCopy $removedFile ($newVersionIndex - 1) $False;
					Return;
				}
			}
		}
	}