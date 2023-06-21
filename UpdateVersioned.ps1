# Atualiza os arquivos-versionados presentes no $destPath
#   Se $destructive = $True:
#     Apenas os $maxVersionLimit últimos arquivos-versionados são mantidos, o resto é deletado
#     Estes são nomeados de $maxVersionLimit até 1, do último ao primeiro
#     Dessa forma, os que sobrarem são sempre nomeados de 1 até $maxVersionLimit, do mais antigo ao mais novo
#   Se $destructive = $False:
#     Nada ocorre. Os arquivos com index maior do que $maxVersionLimit não são afetados e ficam indefinitivamente
Function UpdateVersioned($modifiedFilesMap, $maxVersionLimit, $destructive, $listOnly) {

	$filePathList = "",
		"C:\Folder\SubFolder\File _version[1].ext",
		"C:\Folder\SubFolder\File _version[2].ext",
		"C:\Folder\SubFolder\File _version[3].ext",
		"C:\Folder\SubFolder\File _version[4].ext",
		"C:\Folder\SubFolder\File _version[5].ext";
	$modifiedFilesMap = GetFileMap $filePathList;

	# Não-Destrutivo = Não faz nada
	If(-Not $destructive) {
		Return $modifiedFilesMap;
	}
	# Destrutivo = Aplica $maxVersionLimit, listando arquivos para renomear ou deletar
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	ForEach($nameKey In $modifiedFilesMap.List()) {
		$unoccupiedVersionIndex = $maxVersionLimit;
		ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
			# Sem VersionIndex livres, então deletar
			If($unoccupiedVersionIndex -lt 1) {
				ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
					$Null = $filesToDelete.Add($removedFile);
				}
				Continue;
			}
			# VersionIndex iguais a -1 são ignorados(São os sem versão)
			If($versionKey -eq -1) {
				Continue;
			}
			# VersionIndex menores que 1 são ilegais(Menos o -1)
			If($versionKey -lt 1) {
				ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
					$Null = $filesToDelete.Add($removedFile);
				}
				Continue;
			}
			# VersionIndex menores que $maxVersionLimit devem permanecer assim
			If($versionKey -le $unoccupiedVersionIndex) {
				$unoccupiedVersionIndex = $versionKey;
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
	ForEach($fileToRename In $filesToRename) {
		$newVersion = $fileToRename.NewVersion;
		$fileToRename = $fileToRename.File;
		# Renomeia arquivo
		$version = ($versionStart + $newVersion + $versionEnd);
		$remotion = "";
		If($fileToRename.RemotionCountdown -gt -1) {
			$remotion = ($remotionStart + $fileToRename.RemotionCountdown + $remotionEnd);
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
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);

	EchoFileMap $modifiedFilesMap;

	Return $modifiedFilesMap;
}