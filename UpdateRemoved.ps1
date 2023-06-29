# Atualiza os arquivos-deletados presentes no $destPath
#   Todos que tiverem " _removedIn[0]" são deletados
#   Todos que tiverem " _removedIn[r]" recebem "r-1"
#   Se $destructive = $True:
#     Apenas os $remotionCountdown+1 últimos arquivos-deletados são mantidos, o resto é deletado
#     Estes são nomeados de $remotionCountdown até 0, do último ao primeiro
#     Dessa forma, os que sobrarem são sempre nomeados de $remotionCountdown até 0, do mais novo ao mais antigo
#   Se $destructive = $False:
#     Todos serão eventualmente deletados conforme seus contadores atingem [0]
Function UpdateRemoved($modifiedFilesMap, $remotionCountdown, $destructive, $listOnly) {
	# Aplica $remotionCountdown, listando arquivos para renomear ou deletar
	$filesToDelete = [System.Collections.ArrayList]::new();
	$filesToRename = [System.Collections.ArrayList]::new();
	# Não-Destrutivo = Diminui o RemotionCountdown, e deleta os com RemotionCountdown igual a 0
	If(-Not $destructive) {
		ForEach($nameKey In $modifiedFilesMap.List()) {
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
					# RemotionCountdown iguais a -1 são ignorados(São os sem remoção)
					If($removedKey -eq -1) {
						Continue;
					}
					# RemotionCountdown iguais a 0 são deletados
					If($removedKey -eq 0) {
						$Null = $filesToDelete.Add($removedFile);
						Continue;
					}
					# Renomear com RemotionCountdown - 1
					$Null = $filesToRename.Add([PSCustomObject]@{
						File = $removedFile;
						NewRemotionCountdown = ($removedKey - 1);
					});
				}
			}
		}
	# Destrutivo = Aplica $remotionCountdown, listando arquivos para renomear ou deletar
	} Else {
		ForEach($nameKey In $modifiedFilesMap.List()) {
			ForEach($versionKey In $modifiedFilesMap.Get($nameKey).List()) {
				$unoccupiedRemotionCountdown = $remotionCountdown;
				ForEach($removedKey In $modifiedFilesMap.Get($nameKey).Get($versionKey).List()) {
					$removedFile = $modifiedFilesMap.Get($nameKey).Get($versionKey).Get($removedKey);
					# RemotionCountdown iguais a -1 são ignorados(São os sem remoção)
					If($removedKey -eq -1) {
						Continue;
					}
					# RemotionCountdown iguais a 0 são deletados
					If($removedKey -eq 0) {
						$Null = $filesToDelete.Add($removedFile);
						Continue;
					}
					# Sem RemotionCountdown livres, então deletar
					If($unoccupiedRemotionCountdown -lt 0) {
						$Null = $filesToDelete.Add($removedFile);
						Continue;
					}
					# RemotionCountdown menores que $remotionCountdown são renomeados com RemotionCountdown - 1
					If($removedKey -le $unoccupiedRemotionCountdown) {
						$unoccupiedRemotionCountdown = $removedKey;
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
	# Da lista, deleta arquivos
	DeleteFilesList $modifiedFilesMap $filesToDelete $listOnly;
	# Da lista, renomeia arquivos
	RenameRemovedFilesList $modifiedFilesMap $filesToRename $listOnly;
	# Retorna mapa ordenado
	$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
	Return $modifiedFilesMap;
}