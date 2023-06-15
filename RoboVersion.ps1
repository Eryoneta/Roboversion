# Robocopy Params:
#   /SJ = Não seguir junctionLinks
#   /SL = Não seguir symbolicLinks
#   /R = Retentar 1 vez
#   /W = Esperar 0s antes de retentar
#   /MT = Quantidade de processamentos em paralelo(1-128)
#   /NJH = Sem cabeçário
#   /NJS = Sem sumário
#   /FP = Informar caminho completo dos arquivos
#   /NC = Não informar a classe dos arquivos
#   /NS = Não informar o tamanho dos arquivos
#   /NP = Não informar sobre progresso da cópia dos arquivos
#   /NDL = Não informar sobre pastas
#   /UNILOG = Exportar lista a um arquivo UNICODE(Inclui caracteres especiais)

# Padrão do nome de arquivos versionados
$versionStart = " _version[";
$versionEnd = "]";
# Padrão do nome de arquivos removidos
$remotionStart = " _removeIn[";
$remotionEnd = "]";

# Wildcard para ignorar arquivos versionados e removidos
$wildcardOfVersionedFile = ("*" + $versionStart + "*" + $versionEnd + "." + "*");
$wildcardOfRemovedFile = ("*" + $remotionStart + "*" + $remotionEnd + "." + "*");
$wildcardOfVersionedAndRemovedFile = ("*" + $versionStart + "*" + $versionEnd + $remotionStart + "*" + $remotionEnd + "." + "*");
# Wildcard para ignorar pastas deletadas
$wildcardOfRemovedFolder = ("*" + $remotionStart + "*" + $remotionEnd + "." + "*");

Function RoboVersion($origPath, $destPath, $threads, $maxVersionLimit, $remotionCountdown, $destructive) {
	
	$origPath="D:\ \BKPM\LOC1";
	$destPath="D:\ \BKPM\LOC2";
	$threads=8;
	$maxVersionLimit=3;
	$remotionCountdown=5;
	$destructive=$False;
	
	# Lista os arquivos versionados e removidos
	$modifiedFilesMap = (GetModifiedFilesMap $destPath $threads);
	
	EchoHash $modifiedFilesMap;
	
	# Atualiza os arquivos versionados e removidos em $destPath
	updateModified $modifiedFilesMap $maxVersionLimit $remotionCountdown $destructive;
	EchoHash $modifiedFilesMap;
	
	# Lista os arquivos a versionar ou remover
	$toModifyFilesList = (GetToModifyFilesList $origPath $destPath $threads);
	EchoHash $modifiedFilesMap;
	
	# Atualiza os arquivos a versionar ou remover em $destPath
	updateToModify $modifiedFilesMap $toModifyFilesList $maxVersionLimit $remotionCountdown $destructive;
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

Function GetModifiedFilesMap($destPath, $threads) {
	If(-Not $destPath) {
		Return;
	}
	If(-Not $threads) {
		$threads = 8;
	}
	# Path do arquivo com a lista de arquivos versionados e removidos em $destPath
	$modifiedFilesList_FilePath = (Join-Path -Path $destPath -ChildPath "MODIFIED");
	# Lista os arquivos versionados e removidos em MODIFIED
	#   Sem destino
	#   Considerar apenas os arquivos versionados e removidos
	#   /L = Listar apenas!
	$Null = (Robocopy $destPath null `
		$wildcardOfVersionedFile `
		$wildcardOfRemovedFile `
		$wildcardOfVersionedAndRemovedFile `
		/SJ /SL /R:1 /W:0 /MT:$threads /L /NJH /NJS /FP /NC /NS /NP /NDL /UNILOG:$modifiedFilesList_FilePath);
	# Carrega MODIFIED e o deleta
	$modifiedFilesList_File = (Get-Content $modifiedFilesList_FilePath);
	Remove-Item $modifiedFilesList_FilePath;
	# Lista pastas-removidas
	$removedFoldersList = ((Get-ChildItem -LiteralPath $destPath -Filter $wildcardOfRemovedFolder -Recurse -Directory) | ForEach {"$($_.FullName)"})
	# Ordena lista de arquivos versionados e removidos e pastas removidas
	$modifiedFilesMap = GetOrderedFilesMap ($modifiedFilesList_File + $removedFoldersList);
	# Retorna a lista
	Return $modifiedFilesMap;
}
Function GetToModifyFilesMap($origPath, $destPath, $threads) {
	If(-Not $origPath -Or -Not $destPath) {
		Return;
	}
	If(-Not $threads) {
		$threads = 8;
	}
	# Path do arquivo com a lista de arquivos a serem versionados ou removidos em $destPath
	$toModifyFilesList_FilePath = (Join-Path -Path $destPath -ChildPath "TO_MODIFY");
	# Lista os arquivos a serem versionados e removidos em TO_MODIFY
	#   /MIR = Espelhar
	#   /XF = Ignorar arquivos(Os versionados, os removidos, os versionados e removidos)
	#   /XD = Ignorar pastas(Os removidos)
	$null = (Robocopy $orig $dest /MIR /SJ /SL /R:1 /W:0 /MT:$threads `
		/XF `
			$wildcardOfVersionedFile `
			$wildcardOfRemovedFile `
			$wildcardOfVersionedAndRemovedFile `
		/XD `
			$wildcardOfRemovedFolder `
		/L /NJH /NJS /FP /NC /NS /NP /UNILOG:$toModifyFilesList_FilePath)
}
# Ordena arquivos com mesmo nome em grupos, agrupando os versionados e os removidos
#   Ex.: Arquivos {
#     "C:/Folder/SubFolder/File.ext": {
#       -1: {	# Versão inexistente
#         -1: {		# Remoção inexistente
#           "C:/Folder/SubFolder/File.ext"
#         },
#         4: {		# Remoção em 4
#           "C:/Folder/SubFolder/File _removeIn[4].ext"
#         }
#       },
#       3: {	# Versão 3
#         -1: {		# Remoção inexistente
#           "C:/Folder/SubFolder/File _version[3].ext"
#         },
#         4: {		# Remoção em 4
#           "C:/Folder/SubFolder/File _version[3] _removeIn[4].ext"
#         }
#       }
#     }
#   }
# Todos ficam listados em ordem numérica
Function GetOrderedFilesMap($filePathList) {
	$allFilesMap = [FileMap]::new();
	$regexOfBaseName = "(?<BaseName>.*?)";
	$regexOfVersion = "(?:" + ([Regex]::Escape($versionStart) + "(?<VersionIndex>[0-9]+)" + [Regex]::Escape($versionEnd)) + ")?";
	$regexOfRemotion = "(?:" + ([Regex]::Escape($remotionStart) + "(?<RemotionCountdown>[0-9]+)" + [Regex]::Escape($remotionEnd)) + ")?";
	$regexOfExtension = "(?<Extension>\.[^\.]*)?";
	$regexOfFile = "^" + $regexOfBaseName + $regexOfVersion + $regexOfRemotion + $regexOfExtension + "$";
	ForEach($filePath In $filePathList) {
		If(-Not $filePath) {
			Continue;
		}
		$filePath = $filePath.Trim();
		$fileBasePath = (Split-Path -Path $filePath -Parent);
		$fileName = (Split-Path -Path $filePath -Leaf);
		# Ex.:
		#   $filePath = "C:\Folder\SubFolder\File _version[v] _removeIn[r].ext"
		#   $fileBasePath = "C:\Folder\SubFolder"
		#   $fileName = "File _version[v] _removeIn[r].ext"
		If($fileName -Match $regexOfFile) {
			# Ex.:
			#   BaseName = "File"
			#   VersionIndex = "v"
			#   RemotionCountdown = "r"
			#   Extension = ".ext"
			$baseName = (Join-Path -Path $fileBasePath -ChildPath ($Matches.BaseName + $Matches.Extension));
			# Ex.:
			#   $baseName = "C:\Folder\SubFolder\File.ext"
			$versionIndex = -1;
			If($Matches.VersionIndex) {
				$versionIndex = [int]$Matches.VersionIndex;
			}
			$remotionCountdown = -1;
			If($Matches.RemotionCountdown) {
				$remotionCountdown = [int]$Matches.RemotionCountdown;
			}
			# Valor
			$allFilesMap.Get($baseName).Get($versionIndex).Set($remotionCountdown, ([PSCustomObject]@{
				Path = $filePath;
				BaseName = $Matches.BaseName;
				VersionIndex = $versionIndex;
				RemotionCountdown = $remotionCountdown;
				Extension = $Matches.Extension;
			}));
		}
	}
	# Ordena a lista
	# $orderedFilesMap = [FileMap]::new();
	# ForEach($nameKey In $allFilesMap.List()) {
		# ForEach($versionKey In ($allFilesMap.Get($nameKey).List() | Sort-Object -Descending)) {
			# ForEach($remotionKey In ($allFilesMap.Get($nameKey).Get($versionKey).List() | Sort-Object -Descending)) {
				# $fileItem = $allFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
				# $orderedFilesMap.Get($nameKey).Get($versionKey).Set($remotionKey, $fileItem);
			# }
		# }
	# }
	# Retorna o resultado
	Return $allFilesMap;
	# Return $orderedFilesMap;
}
# Classe para facilitar a navegação no mapa de arquivos
Class FileMap {
	# HASH_MAP
	[System.Collections.IDictionary] $hashMap = [ordered]@{};
	[NameMap] $nameMap;
	# MAIN
	FileMap() {
		$this.nameMap = [NameMap]::new($this);
	}
	# GET
	[VersionMap] Get($nameKey) {
		Return $this.nameMap.Get($nameKey);
	}
	# REMOVE
	[void] Remove($nameKey) {
		$this.nameMap.Remove($nameKey);
	}
	# LIST
	[object] List() {
		Return $this.nameMap.List();
	}
}
Class NameMap {
	[FileMap] $fileMap;
	[string] $currentKey;
	[VersionMap] $versionMap;
	# MAIN
	NameMap([FileMap] $fileMap) {
		$this.fileMap = $fileMap;
		$this.versionMap = [VersionMap]::new($this);
	}
	[void] CheckMap($nameKey) {
		If(-Not $this.fileMap.hashMap.Contains($nameKey)) {
			$this.fileMap.hashMap[[object]$nameKey] = [ordered]@{};
		}
	}
	# GET
	[VersionMap] Get($nameKey) {
		$this.currentKey = $nameKey;
		$this.CheckMap($nameKey);
		Return $this.versionMap;
	}
	# REMOVE
	[void] Remove($nameKey) {
		$this.currentKey = $nameKey;
		$this.fileMap.hashMap.Remove([object]$nameKey);
	}
	# LIST
	[object] List() {
		Return $this.fileMap.hashMap.Keys;
	}
}
Class VersionMap {
	[NameMap] $nameMap;
	[int] $currentKey;
	[RemotionMap] $remotionMap;
	# MAIN
	VersionMap([NameMap] $nameMap) {
		$this.nameMap = $nameMap;
		$this.remotionMap = [RemotionMap]::new($this);
	}
	[void] CheckMap($versionKey) {
		$nameKey = $this.nameMap.currentKey;
		If(-Not $this.nameMap.fileMap.hashMap[[object]$nameKey].Contains($versionKey)) {
			$this.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey] = [ordered]@{};
		}
	}
	# GET
	[RemotionMap] Get($versionKey) {
		$this.currentKey = $versionKey;
		$this.CheckMap($versionKey);
		Return $this.remotionMap;
	}
	# REMOVE
	[void] Remove($versionKey) {
		$nameKey = $this.nameMap.currentKey;
		$this.currentKey = $versionKey;
		$this.nameMap.fileMap.hashMap[[object]$nameKey].Remove([object]$versionKey);
	}
	# LIST
	[object] List() {
		$nameKey = $this.nameMap.currentKey;
		Return $this.nameMap.fileMap.hashMap[[object]$nameKey].Keys;
	}
}
Class RemotionMap {
	[VersionMap] $versionMap;
	[int] $currentKey;
	# MAIN
	RemotionMap([VersionMap] $versionMap) {
		$this.versionMap = $versionMap;
	}
	[void] CheckMap($remotionKey) {
		$nameKey = $this.versionMap.nameMap.currentKey;
		$versionKey = $this.versionMap.currentKey;
		If(-Not $this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Contains($remotionKey)) {
			$this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey][[object]$versionKey] = $Null;
		}
	}
	# GET
	[object] Get($remotionKey) {
		$nameKey = $this.versionMap.nameMap.currentKey;
		$versionKey = $this.versionMap.currentKey;
		$this.currentKey = $remotionKey;
		$this.CheckMap($remotionKey);
		Return $this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey];
	}
	# SET
	[void] Set($remotionKey, $value) {
		$nameKey = $this.versionMap.nameMap.currentKey;
		$versionKey = $this.versionMap.currentKey;
		$this.currentKey = $remotionKey;
		$this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey] = $value;
	}
	# REMOVE
	[void] Remove($remotionKey) {
		$nameKey = $this.versionMap.nameMap.currentKey;
		$versionKey = $this.versionMap.currentKey;
		$this.currentKey = $remotionKey;
		$this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Remove([object]$remotionKey);
	}
	# LIST
	[object] List() {
		$nameKey = $this.versionMap.nameMap.currentKey;
		$versionKey = $this.versionMap.currentKey;
		Return $this.versionMap.nameMap.fileMap.hashMap[[object]$nameKey][[object]$versionKey].Keys;
	}
}
	
	
	
# Class FileMap {
	# HASH_MAP
	# [System.Collections.IDictionary] $hashMap = [ordered]@{};
	# MAIN
	# FileMap() {}
	# GET
	# [object] Get() {
		# Return $this.hashMap;
	# }
	# [object] Get($nameKey) {
		# Return $this.hashMap[[object]$nameKey];
	# }
	# [object] Get($nameKey, $versionKey) {
		# Return $this.hashMap[[object]$nameKey][[object]$versionKey];
	# }
	# [object] Get($nameKey, $versionKey, $remotionKey) {
		# Return $this.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey];
	# }
	# SET
	# [void] Set($nameKey, $value) {
		# $this.hashMap[[object]$nameKey] = $value;
	# }
	# [void] Set($nameKey, $versionKey, $value) {
		# If(-Not $this.hashMap.Contains($nameKey)) {
			# $this.hashMap[[object]$nameKey] = [ordered]@{};
		# }
		# $this.hashMap[[object]$nameKey][[object]$versionKey] = $value;
	# }
	# [void] Set($nameKey, $versionKey, $remotionKey, $value) {
		# If(-Not $this.hashMap.Contains($nameKey)) {
			# $this.hashMap[[object]$nameKey] = [ordered]@{};
		# }
		# If(-Not $this.hashMap[[object]$nameKey].Contains($versionKey)) {
			# $this.hashMap[[object]$nameKey][[object]$versionKey] = [ordered]@{};
		# }
		# $this.hashMap[[object]$nameKey][[object]$versionKey][[object]$remotionKey] = $value;
	# }
	# LIST
	# [object] List() {
		# Return $this.hashMap.Keys;
	# }
	# [object] List($nameKey) {
		# Return $this.hashMap[[object]$nameKey].Keys;
	# }
	# [object] List($nameKey, $versionKey) {
		# Return $this.hashMap[[object]$nameKey][[object]$versionKey].Keys;
	# }
# }




# Padrão do nome de arquivos versionados
$versionStart = " _version[";
$versionEnd = "]";
# Padrão do nome de arquivos removidos
$remotionStart = " _removeIn[";
$remotionEnd = "]";

# Wildcard para ignorar arquivos versionados e removidos
$wildcardOfVersionedFile = ("*" + $versionStart + "*" + $versionEnd + "." + "*");
$wildcardOfRemovedFile = ("*" + $remotionStart + "*" + $remotionEnd + "." + "*");
$wildcardOfVersionedAndRemovedFile = ("*" + $versionStart + "*" + $versionEnd + $remotionStart + "*" + $remotionEnd + "." + "*");
# Wildcard para ignorar pastas deletadas
$wildcardOfRemovedFolder = ("*" + $remotionStart + "*" + $remotionEnd + "." + "*");


Function EchoHash($hashMap) {
	ForEach($nameKey In $hashMap.List()) {
		Echo ("--> BASENAME: " + $nameKey);
		ForEach($versionKey In $hashMap.Get($nameKey).List()) {
			Echo ("----> VERSION: " + $versionKey);
			ForEach($remotionKey In $hashMap.Get($nameKey).Get($versionKey).List()) {
				Echo ("------> REMOTION: " + $remotionKey);
				Echo $hashMap.Get($nameKey).Get($versionKey).Get($remotionKey);
			}
		}
	}
}
Function Test_GetOrderedFilesMap() {
	$filePathList = "",
		"C:\Folder\SubFolder\File1 _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1.ext",
		"C:\Folder\SubFolder\File2 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _version[5].ext",
		"C:\Folder\SubFolder\File2 _version[1].ext",
		"C:\Folder\SubFolder\File2 _version[3] _removeIn[5].ext",
		"C:\Folder\SubFolder\File2 _version[3].ext",
		"C:\Folder\SubFolder\File2.ext",
		"C:\Folder\SubFolder\File3.com.ext",
		"C:\Folder\SubFolder\File4",
		"C:\Folder\SubFolder\.file5",
		"C:\Folder\SubFolder\File6 _version[6] _removeIn[5].ext";
	$filePathList = "",
		"C:\Folder\SubFolder\File1 _version[4] _removeIn[7].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[1] _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[2] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1 _removeIn[5].ext",
		"C:\Folder\SubFolder\File1 _version[15].ext",
		"C:\Folder\SubFolder\File1 _version[12] _removeIn[3].ext",
		"C:\Folder\SubFolder\File1 _version[12] _removeIn[2].ext",
		"C:\Folder\SubFolder\File1.ext";
	$orderedMap = GetOrderedFilesMap $filePathList;
	EchoHash $orderedMap;
}
Test_GetOrderedFilesMap;