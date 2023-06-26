# Atualiza os arquivos-a-serem-deletados com um novo removido
#   Da lista de arquivos-modificados em $origPath, criar uma novo removido desta, com "removeIn[$remotionCountdown]"
#     Checar pelos removidos existentes
#     Se houver um removido já com $remotionCountdown:
#       Ele recebe $remotionCountdown-1, e este recebe $remotionCountdown
#       Se houver mais, todos trocam de r até o -1 ser removido
#     Dessa forma, existem removidos apenas de $remotionCountdown até 0
Function UpdateToRemove($modifiedFilesMap, $toModifyFilesMap, $remotionCountdown, $listOnly) {
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	$filesToCopy = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $toModifyFilesMap.List()) {
		$toModifyFile = $toModifyFilesMap.Get($nameKey).Get(-1).Get(-1);
		# Copia o a-ser-removido, renomeando duplicatas, se houver
		UpdateToRemove_RenameOrDelete $modifiedFilesMap $filesToDelete $filesToRename $filesToCopy $toModifyFile $remotionCountdown $True;
		# Existem versões
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
	ForEach($fileToRename In $filesToRename | Sort-Object -Property NewRemotionCountdown) {
		$newRemotionCountdown = $fileToRename.NewRemotionCountdown;
		$fileToRename = $fileToRename.File;
		# Renomeia arquivo
		$version = "";
		If($fileToRename.VersionIndex -gt 0) {
			$version = (" " + $versionStart + $fileToRename.VersionIndex + $versionEnd);
		}
		$remotion = (" " + $remotionStart + $newRemotionCountdown + $remotionEnd);
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
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Set($newRemotionCountdown, $fileToRename);
		$fileToRename.Path = (Join-Path -Path $fileBasePath -ChildPath $newName);
		$fileToRename.RemotionCountdown = $newRemotionCountdown;
	}
	# Da lista, copia arquivos
	ForEach($fileToCopy In $filesToCopy) {
		$newRemotionCountdown = $fileToCopy.NewRemotionCountdown;
		$fileToCopy = $fileToCopy.File;
		# Copia arquivo
		$version = "";
		If($fileToCopy.VersionIndex -gt 0) {
			$version = (" " + $versionStart + $fileToCopy.VersionIndex + $versionEnd);
		}
		$remotion = (" " + $remotionStart + $newRemotionCountdown + $remotionEnd);
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
		$versionKey = $fileToCopy.VersionIndex;
		$remotionKey = $newRemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Set($remotionKey, ([PSCustomObject]@{
			Path = $newPath;
			BaseName = $fileToCopy.BaseName;
			VersionIndex = $fileToCopy.VersionIndex;
			RemotionCountdown = $newRemotionCountdown;
			Extension = $fileToCopy.Extension;
		}));
	}
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
		$versionKey = $file.VersionIndex;
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