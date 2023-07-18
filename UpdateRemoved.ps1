# Atualiza os arquivos-deletados presentes no $destPath
#   Todos que tiverem "_removedIn[0]" são deletados
#   Todos que tiverem "_removedIn[r]" recebem "r-1"
#   Se $destructive = $True:
#     Apenas os $remotionCountdown+1 últimos arquivos-deletados são mantidos, o resto é deletado
#     Estes são nomeados de $remotionCountdown até 0, do último ao primeiro
#     Dessa forma, os que sobrarem são sempre nomeados de $remotionCountdown até 0, do mais novo ao mais antigo
#   Se $destructive = $False:
#     Todos serão eventualmente deletados conforme seus contadores atingem [0]
Function UpdateRemoved($modifiedFilesMap, $removedFolderList, $remotionCountdown, $destructive, $listOnly) {
	If($remotionCountdown -eq 0) {
		# Com 0, não deve manter removidos
		$remotionCountdown = -1;
	}
	# Aplica $remotionCountdown, listando arquivos para renomear ou deletar
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	# Não-Destrutivo = Diminui o RemotionCountdown, e deleta os com RemotionCountdown igual a 0
	If(-Not $destructive) {
		ForEach($removedFolder In $removedFolderList) {
			If(IsFolderEmpty $removedFolder.Path) {
				$Null = $filesToDelete.Add($removedFolder);
			}
		}
		ForEach($nameKey In $modifiedFilesMap.List()) {
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				ForEach($remotionKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
					# RemotionCountdown iguais a -1 são ignorados(São os sem remoção)
					If($remotionKey -eq -1) {
						Continue;
					}
					# RemotionCountdown iguais a 0 são deletados
					If($remotionKey -eq 0) {
						$Null = $filesToDelete.Add($removedFile);
						Continue;
					}
					# Renomear com RemotionCountdown - 1
					$Null = $filesToRename.Add([PSCustomObject]@{
						File = $removedFile;
						NewRemotionCountdown = ($remotionKey - 1);
					});
				}
			}
		}
	# Destrutivo = Aplica $remotionCountdown, listando arquivos para renomear ou deletar
	} Else {
		ForEach($removedFolder In $removedFolderList) {
			If(IsFolderEmpty $removedFolder.Path) {
				$Null = $filesToDelete.Add($removedFolder);
			}
		}
		ForEach($nameKey In $modifiedFilesMap.List()) {
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				$unoccupiedRemotionCountdown = $remotionCountdown;
				ForEach($remotionKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
					# RemotionCountdown iguais a -1 são ignorados(São os sem remoção)
					If($remotionKey -eq -1) {
						Continue;
					}
					# RemotionCountdown iguais a 0 são deletados
					If($remotionKey -eq 0) {
						$Null = $filesToDelete.Add($removedFile);
						Continue;
					}
					# Sem RemotionCountdown livres, então deletar
					If($unoccupiedRemotionCountdown -lt 0) {
						$Null = $filesToDelete.Add($removedFile);
						Continue;
					}
					# RemotionCountdown menores que $remotionCountdown são renomeados com RemotionCountdown - 1
					If($remotionKey -le $unoccupiedRemotionCountdown) {
						$unoccupiedRemotionCountdown = $remotionKey;
						$Null = $filesToRename.Add([PSCustomObject]@{
							File = $removedFile;
							NewRemotionCountdown = ($unoccupiedRemotionCountdown - 1);
						});
						$unoccupiedRemotionCountdown--;
						Continue;
					}
					# Renomear com RemotionCountdown livre
					$Null = $filesToRename.Add([PSCustomObject]@{
						File = $removedFile;
						NewRemotionCountdown = $unoccupiedRemotionCountdown;
					});
					$unoccupiedRemotionCountdown--;
				}
			}
		}
	}
	# Output
	If($filesToDelete.Count -eq 0 -And $filesToRename.Count -eq 0) {
		PrintText ("`tNenhuma ação necessária");
	}
	# Da lista, deleta arquivos
	DeleteFilesList $modifiedFilesMap $filesToDelete $listOnly;
	# Da lista, renomeia arquivos
	RenameRemovedFilesList $modifiedFilesMap $filesToRename $listOnly;
	# Retorna mapa ordenado
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
	Return $modifiedFilesMap;
}
	Function IsFolderEmpty($folderPath) {
		Return ((Get-ChildItem -LiteralPath $folderPath -File -Force | Select-Object -First 1 | Measure-Object).Count -eq 0);
	}