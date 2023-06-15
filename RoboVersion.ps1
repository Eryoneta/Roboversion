. "./FileMap.ps1";
. "./Functions.ps1";

Function RoboVersion($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
	
	$origPath="D:\ \BKPM\LOC1";
	$destPath="D:\ \BKPM\LOC2";
	$threads=8;
	$maxVersionLimit=3;
	$remotionCountdown=5;
	$destructive=$False;
	. "./FileMap.ps1";
	. "./Functions.ps1";
	. "./DevTools.ps1";
	
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $destPath $threads);
	
	EchoMap $modifiedFilesMap;
	
	# Atualiza os arquivos versionados e removidos em $destPath
	# updateModified $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive;
	# EchoMap $modifiedFilesMap;
	
	# Lista os arquivos a versionar ou remover
	# $toModifyFilesList = (GetToModifyFilesList $origPath $destPath $threads);
	# EchoMap $modifiedFilesMap;
	
	# Atualiza os arquivos a versionar ou remover em $destPath
	# updateToModify $modifiedFilesMap $toModifyFilesList $maxVersionLimit $remotionCountdown $destructive;
	# Realiza a cópia
	# Robocopy $origPath $destPath;
}
	Function updateModified($modifiedFilesMap, $maxVersionLimit, $remotionCountdown, $destructive) {
		updateVersioned $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive;
		# updateRemoved $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive;
	}
		# Atualiza os arquivos-versionados presentes no $destPath
		#   Se $destructive = $True:
		#     Apenas os $maxVersionLimit últimos arquivos-versionados são mantidos, o resto é deletado
		#     Estes são nomeados de $maxVersionLimit até 1, do último ao primeiro
		#     Dessa forma, os que sobrarem são sempre nomeados de 1 até $maxVersionLimit, do mais antigo ao mais novo
		#   Se $destructive = $False:
		#     Nada ocorre. Os arquivos com index maior do que $maxVersionLimit não são afetados e ficam indefinitivamente
		# Ex.: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))              --($maxVersionLimit=3)--> Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))
		# Ex.: Dest(F_v1(A), F_v2(B), F_v3(C), F_v4(D), F_v5(E))              --($maxVersionLimit=3,$destructive)--> Dest(F_v1(C), F_v2(D), F_v3(E))
		# Ex.: Dest(F_v10(A), F_v12(B), F_v23(C))                             --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B), F_v3(C))
		# Ex.: Dest(F_v1(A), F_v2(B))                                         --($maxVersionLimit=3,$destructive)--> Dest(F_v1(A), F_v2(B))
		# Ex.: Dest(F_v1(A), F_v2(B), F_v27(Y), F_v34(Z))                     --($maxVersionLimit=5,$destructive)--> Dest(F_v1(A), F_v2(B), F_v4(Y), F_v5(Z))
		# Ex.: Dest(F_v1(A), F_v2(B), F_v19(W), F_v25(X), F_v27(Y), F_v34(Z)) --($maxVersionLimit=5,$destructive)--> Dest(F_v1(A), F_v2(W), F_v3(X), F_v4(Y), F_v5(Z))
		# Ex.: Dest(F_v27(Y), F_v34(Z))                                       --($maxVersionLimit=5,$destructive)--> Dest(F_v4(Y), F_v5(Z))
		# Ex.: Dest(F_v9_r3(Y), F_v9_r1(Z))                                   --($maxVersionLimit=3,$remotionCountdown=5,$destructive)--> Dest(F_v3_r3(Y), F_v3_r1(Z))
		# Ex.: Dest(F_v12_r39(A), F_v15_r45(B))                               --($maxVersionLimit=3,$remotionCountdown=5,$destructive)--> Dest(F_v2_r39(A), F_v3_r45(B))
		# Ex.: Dest(F(A), F_v4(B), F_v5(C), F_v6(D), F_v7(E))                 --($maxVersionLimit=3,$destructive)--> Dest(F(B), F_v1(C), F_v2(D), F_v3(D))
		Function updateVersioned($modifiedFilesMap, $maxVersionLimit, $remotionCountdown, $destructive) {
			If(-Not $destructive) {
				Return;
			}
			
			$origPath="D:\ \BKPM\LOC1";
			$destPath="D:\ \BKPM\LOC2";
			$threads=8;
			$maxVersionLimit=3;
			$remotionCountdown=5;
			$modifiedFilesMap = (GetModifiedFilesMap $destPath $threads);
			
			# Aplica $maxVersionLimit, renomeando ou deletando
			ForEach($nameKey In $modifiedFilesMap.List()) {
				$unoccupiedVersionIndex = $maxVersionLimit;
				ForEach($versionKey In $modifiedFilesMap.List($nameKey)) {
					# Sem VersionIndex livres, então deletar
					If($unoccupiedVersionIndex -lt 1) {
						ForEach($removedKey In $modifiedFilesMap.List($nameKey, $versionKey)) {
							$removedFile = $modifiedFilesMap.Get($nameKey, $versionKey, $removedKey);
							Echo ("DELETE: " + $removedFile.Path);
						}
						Continue;
					}
					# VersionIndex menores que $maxVersionLimit devem permanecer assim
					If($versionKey -le $unoccupiedVersionIndex) {
						$unoccupiedVersionIndex = $versionKey;
						Continue;
					}
					# Renomear
					$version = ($versionStart + $unoccupiedVersionIndex + $versionEnd);
					$remotion = "";
					ForEach($removedKey In $modifiedFilesMap.List($nameKey, $versionKey)) {
						$removedFile = $modifiedFilesMap.Get($nameKey, $versionKey, $removedKey);
						If($removedFile.RemotionCountdown -gt -1) {
							$remotion = ($remotionStart + $removedFile.RemotionCountdown + $remotionEnd);
						}
						$newName = ($removedFile.BaseName + $version + $remotion + $removedFile.Extension)
						echo ("RENAME: " + $removedFile.Path + "->" + $newName)
					}
					$unoccupiedVersionIndex--
				}
			}
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
		# Ex.: Dest(F_r0(A), F_r1(B), F_r3(C), F_r5(D))             --($remotionCountdown=5)-->              Dest(F_r0(B), F_r2(C), F_r4(D))
		# Ex.: Dest(F_r1(A), F_r8(Y), F_r9(Z))                      --($remotionCountdown=5)-->              Dest(F_r0(A), F_r7(Y), F_r8(Z))
		# Ex.: Dest(F_r1(A), F_r8(Y), F_r9(Z))                      --($remotionCountdown=5,$destructive)--> Dest(F_r0(A), F_r4(Y), F_r5(Z))
		# Ex.: Dest(F_r1(A), F_r4(B), F_r5(C), F_r8(Y), F_r9(Z))    --($remotionCountdown=5,$destructive)--> Dest(F_r0(A), F_r2(B), F_r3(C), F_r4(Y), F_r5(Z))
		# Ex.: Dest(F_r1(A), F_r4(B), F_r5(C), F_r8(Y), F_r9(Z))    --($remotionCountdown=3,$destructive)--> Dest(F_r3(C), F_r4(Y), F_r5(Z))
		# Ex.: Dest(F_v1_r2(A), F_v1_r9(Z), F_v2_r2(B), F_v2_r8(Y)) --($remotionCountdown=3,$destructive)--> Dest(F_v1_r1(A), F_v1_r3(Z), F_v2_r1(B), F_v2_r3(Y))
		Function updateRemoved($destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
			# Path do arquivo com a lista de arquivos-removidos do $destPath
			$removedFilesList_FilePath = (Join-Path -Path $destPath -ChildPath "REMOVED")
			# Lista arquivos-removidos em REMOVED
			#   Sem destino
			#   Considerar apenas os arquivos-removidos
			#   /L = Listar apenas!
			$Null = (Robocopy $destPath null $wildcardOfRemovedFile $wildcardOfVersionedAndRemovedFile /SJ /SL /R:1 /W:0 /MT:$threads /L /NJH /NJS /FP /NC /NS /NP /NDL /UNILOG:$removedFilesList_FilePath)
			# Carrega REMOVED e o deleta
			$removedFilesList_File = (Get-Content $removedFilesList_FilePath)
			Remove-Item $removedFilesList_FilePath
			# Lista pastas-removidas
			$removedFoldersList = ((Get-ChildItem -LiteralPath $destPath $wildcardOfRemovedFolder -Recurse -Directory) | ForEach {"$($_.FullName)"})
			# Ordena lista de arquivos-removidos
			$removedList = GetOrderedFilesMap ($removedFoldersList + $removedFilesList_File)
			
			
			# Fundir o version com o remotion? Tudo em 1 Robocopy, gerando 1 hashtable compartilhado?
			
			# Diminui "remotionCountdown", renomeando ou deletando
			ForEach($key In $removedList.Keys) {
				$removed = ($removedList[$key] | Sort-Object -Property VersionIndex)
				$occupiedVersionIndexes = @{}
				$unoccupiedVersionIndex = $maxVersionLimit
				$allOcuppied = $False
				For($i = $versionedFileList.Length - 1; $i -ge 0; $i--) {
					$versionedFile = $versionedFileList[$i]
					# Sem VersionIndex livres, então deletar
					If($unoccupiedVersionIndex -lt 1) {
						echo ("DELETE: " + $versionedFile.Path)
						Continue
					}
					# VersionIndex menores que $maxVersionLimit devem permanecer assim
					If($versionedFile.VersionIndex -le $unoccupiedVersionIndex) {
						$unoccupiedVersionIndex = $versionedFile.VersionIndex
						Continue
					}
					# Renomear
					$version = $versionStart + $unoccupiedVersionIndex + $versionEnd
					$remotion = ""
					If($versionedFile.RemotionCountdown) {
						$remotion = $remotionStart + $versionedFile.RemotionCountdown + $remotionEnd
					}
					$newName = ($versionedFile.BaseName + $version + $remotion + $versionedFile.Extension)
					echo ("RENAME: " + $versionedFile.Path + "->" + $newName)
					$unoccupiedVersionIndex--
				}
			}
			
			
		}
	Function updateToModify($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
		updateToVersion $origPath $destPath $threads $maxVersionLimit $remotionCountdown $destructive
		updateToRemove $origPath $destPath $threads $maxVersionLimit $remotionCountdown $destructive
	}
		# Atualiza os arquivos-a-serem-sobrescritos com uma nova versão
		#   Da lista de arquivos-modificados em $origPath, criar uma nova versão desta, com " _version[v]"
		#     Checar pelas versões existentes, e adicionar uma nova versão com index v maior de todos
		#     Se o index v for maior do que $maxVersionLimit:
		#       Este toma $maxVersionLimit, e o anterior toma $maxVersionLimit-1, etc
		#       O que tiver " _version[0]" é deletado
		#     Dessa forma, existem apenas versões de 1 até $maxVersionLimit
		Function updateToVersion($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
			
		}
		# Atualiza os arquivos-a-serem-deletados com um novo removido
		#   Da lista de arquivos-modificados em $origPath, criar uma novo removido desta, com "removeIn[$remotionCountdown]"
		#     Checar pelos removidos existentes
		#     Se houver um removido já com $remotionCountdown:
		#       Ele recebe $remotionCountdown-1, e este recebe $remotionCountdown
		#       Se houver mais, todos trocam de r até o -1 ser removido
		#     Dessa forma, existem removidos apenas de $remotionCountdown até 0
		Function updateToRemove($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
			
		}
