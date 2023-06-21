. "./FileMap.ps1";
. "./Functions.ps1";

Function RoboVersion($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
	
	$origPath="D:\ \BKPM\LOC1";
	$destPath="D:\ \BKPM\LOC2";
	$threads=8;
	$maxVersionLimit=3;
	$remotionCountdown=5;
	$destructive=$True;
	$listOnly=True;
	. "./FileMap.ps1";
	. "./Functions.ps1";
	. "./DevTools.ps1";
	
	
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $destPath $threads);
	
	Echo "============ARQUIVOS MODIFICADOS: ";
	EchoFileMap $modifiedFilesMap;
	Echo "============";
	
	# Atualiza os arquivos versionados e removidos em $destPath
	$modifiedFilesMap = (UpdateModified $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive);
	Echo "============ARQUIVOS MODIFICADOS APÓS UPDATE: ";
	EchoFileMap $modifiedFilesMap;
	Echo "============";
	
	# Lista os arquivos a versionar ou remover
	$toModifyFilesList = (GetToModifyFilesMap $origPath $destPath $threads);
	Echo "============ARQUIVOS A MODIFICAR: ";
	EchoFileMap $toModifyFilesList;
	Echo "============";
	
	# Atualiza os arquivos a versionar ou remover em $destPath
	# updateToModify $modifiedFilesMap $toModifyFilesList $maxVersionLimit $remotionCountdown $destructive;
	# Realiza a cópia
	# Robocopy $origPath $destPath;
}
	Function UpdateModified($modifiedFilesMap, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
		$modifiedFilesMap = (UpdateVersioned $modifiedFilesMap $maxVersionLimit $destructive $listOnly);
		$modifiedFilesMap = (UpdateRemoved $modifiedFilesMap $remotionCountdown $destructive $listOnly);
		Return $modifiedFilesMap;
	}
		# Atualiza os arquivos-versionados presentes no $destPath
		#   Se $destructive = $True:
		#     Apenas os $maxVersionLimit últimos arquivos-versionados são mantidos, o resto é deletado
		#     Estes são nomeados de $maxVersionLimit até 1, do último ao primeiro
		#     Dessa forma, os que sobrarem são sempre nomeados de 1 até $maxVersionLimit, do mais antigo ao mais novo
		#   Se $destructive = $False:
		#     Nada ocorre. Os arquivos com index maior do que $maxVersionLimit não são afetados e ficam indefinitivamente
		Function UpdateVersioned($modifiedFilesMap, $maxVersionLimit, $destructive, $listOnly) {
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
					Write-Information ("DELETE: " + $fileToDelete.Path);
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
					Write-Information ("RENAME: " + $fileToRename.Path + " -> " + $newName);
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
			Return $modifiedFilesMap;
		}
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
							# RemotionCountdown menores que 0 são ilegais(Menos o -1)
							If($removedKey -lt 0) {
								$Null = $filesToDelete.Add($removedFile);
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
								NewRemotionCountdown = ($removedFile.RemotionCountdown - 1);
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
							# RemotionCountdown menores que 0 são ilegais(Menos o -1)
							If($removedKey -lt 0) {
								$Null = $filesToDelete.Add($removedFile);
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
								$Null = $filesToRename.Add([PSCustomObject]@{
									File = $removedFile;
									NewRemotionCountdown = ($removedFile.RemotionCountdown - 1);
								});
								$unoccupiedRemotionCountdown = $removedKey;
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
			ForEach($fileToDelete In $filesToDelete) {
				# Deleta arquivo
				If($listOnly) {
					Write-Information ("DELETE: " + $fileToDelete.Path);
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
				$newRemotionCountdown = $fileToRename.NewRemotionCountdown;
				$fileToRename = $fileToRename.File;
				# Renomeia arquivo
				$version = "";
				If($fileToRename.VersionIndex -gt 0) {
					$version = ($versionStart + $fileToRename.VersionIndex + $versionEnd);
				}
				$remotion = ($remotionStart + $newRemotionCountdown + $remotionEnd);
				$newName = ($fileToRename.BaseName + $version + $remotion + $fileToRename.Extension);
				If($listOnly) {
					Write-Information ("RENAME: " + $fileToRename.Path + " -> " + $newName);
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
			$modifiedFilesMap = (GetSortedFileMap $modifiedFilesMap);
			Return $modifiedFilesMap;
		}
	Function UpdateToModify($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
		UpdateToVersion $origPath $destPath $threads $maxVersionLimit $remotionCountdown $destructive $listOnly
		UpdateToRemove $origPath $destPath $threads $maxVersionLimit $remotionCountdown $destructive $listOnly
	}
		# Atualiza os arquivos-a-serem-sobrescritos com uma nova versão
		#   Da lista de arquivos-modificados em $origPath, criar uma nova versão desta, com " _version[v]"
		#     Checar pelas versões existentes, e adicionar uma nova versão com index v maior de todos
		#     Se o index v for maior do que $maxVersionLimit:
		#       Este toma $maxVersionLimit, e o anterior toma $maxVersionLimit-1, etc
		#       O que tiver " _version[0]" é deletado
		#     Dessa forma, existem apenas versões de 1 até $maxVersionLimit
		Function UpdateToVersion($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
			
		}
		# Atualiza os arquivos-a-serem-deletados com um novo removido
		#   Da lista de arquivos-modificados em $origPath, criar uma novo removido desta, com "removeIn[$remotionCountdown]"
		#     Checar pelos removidos existentes
		#     Se houver um removido já com $remotionCountdown:
		#       Ele recebe $remotionCountdown-1, e este recebe $remotionCountdown
		#       Se houver mais, todos trocam de r até o -1 ser removido
		#     Dessa forma, existem removidos apenas de $remotionCountdown até 0
		Function UpdateToRemove($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive, $listOnly) {
			
		}
