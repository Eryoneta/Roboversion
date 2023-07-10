# Atualiza os arquivos-a-serem-deletados com um novo removido
#   Da lista de arquivos-modificados em $origPath, criar uma novo removido desta, com "_removeIn[$remotionCountdown]"
#     Checar pelos removidos existentes
#     Se houver um removido já com $remotionCountdown:
#       Ele recebe $remotionCountdown-1, e este recebe $remotionCountdown
#       Se houver mais, todos trocam de r até o -1 ser removido
#     Dessa forma, existem removidos apenas de $remotionCountdown até 0
Function UpdateToRemove($modifiedFilesMap, $toRemoveList, $remotionCountdown, $listOnly) {
	If($remotionCountdown -eq 0) {
		# Com 0, não deve fazer nada
		Return $modifiedFilesMap;
	}
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	$filesToCopy = [System.Collections.ArrayList]::new();
	ForEach($toRemoveFile In $toRemoveList) {
		# Copia o a-ser-removido, renomeando duplicatas, se houver
		UpdateToRemove_RenameOrDelete $modifiedFilesMap $filesToDelete $filesToRename $filesToCopy $toRemoveFile $remotionCountdown $True;
		# Existem versões
		$fileBasePath = (Split-Path -Path $toRemoveFile.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($toRemoveFile.BaseName + $toRemoveFile.Extension));
		If($modifiedFilesMap.Contains($nameKey)) {
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				# VersionIndex igual a -1 é ignorado(É o que foi copiado)
				If($versionKey -eq -1) {
					Continue;
				}
				# Existem versões deste
				If($modifiedFilesMap.Get($nameKey).Get($versionKey).Contains(-1)) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get(-1);
					# Aplica RemotionCountdown nas versões, renomeando duplicatas, se houver
					UpdateToRemove_RenameOrDelete $modifiedFilesMap $filesToDelete $filesToRename $filesToCopy $removedFile $remotionCountdown $False;
				}
			}
		}
	}
	# Da lista, deleta arquivos
	DeleteFilesList $modifiedFilesMap $filesToDelete $listOnly;
	# Da lista, renomeia arquivos
	RenameRemovedFilesList $modifiedFilesMap $filesToRename $listOnly;
	# Da lista, copia arquivos
	CopyRemovedFilesList $modifiedFilesMap $filesToCopy $listOnly;
	# Retorna mapa ordenado
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
	Return $modifiedFilesMap;
}
	Function UpdateToRemove_RenameOrDelete($modifiedFilesMap, $filesToDelete, $filesToRename, $filesToCopy, $file, $newRemotionCountdown, $copy) {
		# Deletar
		If($newRemotionCountdown -lt 0) {
			$Null = $filesToDelete.Add($file);
			Return;
		}
		# Copiar, aplicando novo RemotionCountdown
		If($copy) {
			$Null = $filesToCopy.Add([PSCustomObject]@{
				File = $file;
				NewRemotionCountdown = $newRemotionCountdown;
			});
		# Renomear, aplicando novo com RemotionCountdown
		} Else {
			$Null = $filesToRename.Add([PSCustomObject]@{
				File = $file;
				NewRemotionCountdown = $newRemotionCountdown;
			});
		}
		# Checar se não existe outro com mesmo RemotionCountdown
		$fileBasePath = (Split-Path -Path $file.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($file.BaseName + $file.Extension));
		$remotionKey = $newRemotionCountdown;
		If($modifiedFilesMap.Contains($nameKey)) {
			# Todas as versões são checadas
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				If($modifiedFilesMap.Get($nameKey).Get($versionKey).Contains($remotionKey)) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
					# Renomeia ou deleta duplicata
					UpdateToRemove_RenameOrDelete $modifiedFilesMap $filesToDelete $filesToRename $filesToCopy $removedFile ($remotionKey - 1) $False;
				}
			}
		}
	}