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
$versionStart = "_version[";
$versionEnd = "]";
# Padrão do nome de arquivos removidos
$remotionStart = "_removeIn[";
$remotionEnd = "]";
# Padrão do nome de pastas removidas
$remotionFolder = "_removeIfEmpty";

# Wildcard para ignorar arquivos versionados e removidos
$wildcardOfVersionedFile = ("*" + $versionStart + "*" + $versionEnd + "*");
$wildcardOfRemovedFile = ("*" + $remotionStart + "*" + $remotionEnd + "*");
# Wildcard para ignorar pastas deletadas
$wildcardOfRemovedFolder = ("*" + $remotionFolder + "*");

# Print sem interromper o fluxo
Function PrintText($text) {
	Write-Information -MessageData ($text) -InformationAction Continue;
}

# Retorna um fileMap de arquivos modificados no $destPath
Function GetModifiedFilesMap($destPath) {
	# Path do arquivo com a lista de arquivos versionados e removidos em $destPath
	$modifiedFilesList_FilePath = (Join-Path -Path $destPath -ChildPath "MODIFIED");
	# Lista os arquivos versionados e removidos em MODIFIED
	#   Sem destino
	#   Considerar apenas os arquivos versionados e removidos
	#   /L = Listar apenas!
	$Null = (Robocopy $destPath null `
		$wildcardOfVersionedFile `
		$wildcardOfRemovedFile `
		/S /SJ /SL /R:1 /W:0 /L /NJH /NJS /FP /NC /NS /NP /NDL /UNILOG:$modifiedFilesList_FilePath);
	$modifiedFilesList_File = "";
	If(Test-Path -LiteralPath $modifiedFilesList_FilePath -PathType "Leaf") {
		# Carrega MODIFIED e o deleta
		$modifiedFilesList_File = (Get-Content $modifiedFilesList_FilePath);
		$Null = (Remove-Item $modifiedFilesList_FilePath);
	}
	# É incapaz de lidar com path>260, resultando em erro em loop
	## $removedFoldersPathList = ((
	## 	Get-ChildItem -LiteralPath $destPath -Filter $wildcardOfRemovedFolder -Recurse -Directory -Force -ErrorAction SilentlyContinue
	## ) | ForEach {"$($_.FullName)"});
	# Solução: Usar Robocopy para listar TODAS as pastas(Não aceita filtro de pastas-removidas...) e filtrar pelas removidas. Lento, mas funciona...!
	#
	# Lista as pastas em MODIFIED
	#   Sem destino
	#   Considerar apenas pastas
	#   /L = Listar apenas!
	$Null = (Robocopy $destPath null `
		/E /SJ /SL /R:1 /W:0 /L /NJH /NJS /FP /NC /NS /NP /NFL /UNILOG:$modifiedFilesList_FilePath);
	$removedFoldersList_File = "";
	If(Test-Path -LiteralPath $modifiedFilesList_FilePath -PathType "Leaf") {
		# Carrega MODIFIED e o deleta
		$removedFoldersList_File = (Get-Content $modifiedFilesList_FilePath);
		$Null = (Remove-Item $modifiedFilesList_FilePath);
	}
	$removedFoldersList = [System.Collections.ArrayList]::new();
	ForEach($removedFolderPath In $removedFoldersList_File) {
		If(-Not $removedFolderPath) {
			Continue;
		}
		$removedFolderPath = $removedFolderPath.Trim();
		$removedFolderName = (Split-Path -Path $removedFolderPath -Leaf);
		If($removedFolderName -Like $wildcardOfRemovedFolder) {
			$Null = $removedFoldersList.Add($removedFolderPath);
		}
	}
	# Ordena lista de arquivos versionados e removidos, e pastas removidas
	$modifiedFilesMap = (GetFileMap ($modifiedFilesList_File));
	$removedFoldersMap = (GetFileMap ($removedFoldersList));
	$removedFoldersList = [System.Collections.ArrayList]::new();
	ForEach($nameKey In ($removedFoldersMap.List() | Sort-Object -Descending)) {
		$removedFolder = $removedFoldersMap.Get($nameKey).Get(-1).Get(0);
		$Null = $removedFoldersList.Add($removedFolder);
	}
	$modifiedLists = [PSCustomObject]@{
		ModifiedFilesMap = $modifiedFilesMap;
		RemovedFoldersList = $removedFoldersList;
	};
	# Retorna a lista
	Return $modifiedLists;
}

# Retorna uma lista de arquivos que serão modificados no $destPath para refletir $origPath
Function GetWillModifyFilesMap($origPath, $destPath) {
	# Path do arquivo com a lista de arquivos a serem versionados ou removidos em $destPath
	$willModifyFilesList_FilePath = (Join-Path -Path $destPath -ChildPath "WILL_MODIFY");
	# Lista os arquivos a serem versionados e removidos em WILL_MODIFY
	#   /MIR = Espelhar
	#   /XF = Ignorar arquivos(Os versionados, os removidos, os versionados e removidos)
	#   /XD = Ignorar pastas(Os removidos)
	$Null = (Robocopy $origPath $destPath /MIR /SJ /SL /R:1 /W:0 `
		/XF `
			$wildcardOfVersionedFile `
			$wildcardOfRemovedFile `
			$willModifyFilesList_FilePath `
		/XD `
			$wildcardOfRemovedFolder `
		/L /NJH /NJS /FP /NC /NS /NP /UNILOG:$willModifyFilesList_FilePath);
	$willModifyFilesList_File = "";
	If(Test-Path -LiteralPath $willModifyFilesList_FilePath -PathType "Leaf") {
		# Carrega WILL_MODIFY e o deleta
		$willModifyFilesList_File = (Get-Content $willModifyFilesList_FilePath);
		$Null = (Remove-Item $willModifyFilesList_FilePath);
	}
	# Lista de a modificar e a remover
	$willModify = $False;
	$willModifyList = [System.Collections.ArrayList]::new();
	$willDeleteList = [System.Collections.ArrayList]::new();
	$willDeleteFolderList = [System.Collections.ArrayList]::new();
	# Regex
	$regexOfModifiedOrCreated = ("^(?<RootPath>" + [Regex]::Escape($origPath) + ")(?<FilePath>.*)$");
	$regexOfDeleted = ("^(?<RootPath>" + [Regex]::Escape($destPath) + ")(?<FilePath>.*)$");
	# Preenche as listas
	ForEach($willModifyFilePath In $willModifyFilesList_File) {
		If(-Not $willModifyFilePath) {
			Continue;
		}
		$willModifyFilePath = $willModifyFilePath.Trim();
		If($willModifyFilePath -match $regexOfModifiedOrCreated) {
			$oldFilePath = $willModifyFilePath;
			$newFilePath = (Join-Path -Path  $destPath -ChildPath $Matches.FilePath);
			# Arquivo a modificar
			If(Test-Path -LiteralPath $newFilePath -PathType "Leaf") {
				$newFile = (GetFileItem $willModifyFilePath);
				$newFile.Path = $newFilePath;
				$Null = $willModifyList.Add($newFile);
				$willModify = $True;
			# Arquivo a criar
			} ElseIf(Test-Path -LiteralPath $oldFilePath -PathType "Leaf") { # Pastas devem ser listadas pelas a-deletar, mas também lista as presentes
				# Não listar arquivos a criar
				$willModify = $True;
			}
		} ElseIf($willModifyFilePath -match $regexOfDeleted) {
			$newFilePath = (Join-Path -Path  $destPath -ChildPath $Matches.FilePath);
			$newFile = (GetFileItem $willModifyFilePath);
			$newFile.Path = $newFilePath;
			If($newFile.VersionIndex -eq -1 -And $newFile.RemotionCountdown -eq -1) {
				If(Test-Path -LiteralPath $newFilePath -PathType "Container") {
					$Null = $willDeleteFolderList.Add($newFile);
				} Else {
					$Null = $willDeleteList.Add($newFile);
				}
			}
			$willModify = $True;
		}
	}
	$orderedWillDeleteFolderList = [System.Collections.ArrayList]::new();
	ForEach($willDeleteFolder In ($willDeleteFolderList | Sort-Object -Descending)) {
		$Null = $orderedWillDeleteFolderList.Add($willDeleteFolder);
	}
	$willModifyLists = [PSCustomObject]@{
		WillModify = $willModify;
		WillModifyList = $willModifyList;
		WillDeleteList = $willDeleteList;
		WillDeleteFolderList = $orderedWillDeleteFolderList;
	};
	# Retorna a lista
	Return $willModifyLists;
}

# Ordena arquivos com mesmo nome em grupos, agrupando os versionados e os removidos
#   Ex.: Arquivos {
#     "C:/Folder/SubFolder/File.ext": {
#       3: {	# Versão 3
#         4: {		# Remoção em 4
#           "C:/Folder/SubFolder/File _version[3] _removeIn[4].ext"
#         },
#         -1: {		# Remoção inexistente
#           "C:/Folder/SubFolder/File _version[3].ext"
#         }
#       },
#       -1: {	# Versão inexistente
#         4: {		# Remoção em 4
#           "C:/Folder/SubFolder/File _removeIn[4].ext"
#         },
#         -1: {		# Remoção inexistente
#           "C:/Folder/SubFolder/File.ext"
#         }
#       }
#     }
#   }
#   Todos ficam listados em ordem numérica reversa
Function GetFileMap($filePathList) {
	$allFilesMap = [FileMap]::new();
	ForEach($filePath In $filePathList) {
		If(-Not $filePath) {
			Continue;
		}
		$filePath = $filePath.Trim();
		$newFile = (GetFileItem $filePath);
		If(-Not $newFile) {
			Continue;
		}
		$fileBasePath = (Split-Path -Path $filePath -Parent);
		$baseName = (Join-Path -Path $fileBasePath -ChildPath ($newFile.BaseName + $newFile.Extension));
		# Ex.:
		#   $filePath = "C:\Folder\SubFolder\File _version[v] _removeIn[r].ext"
		#   $fileBasePath = "C:\Folder\SubFolder"
		#   $baseName = "C:\Folder\SubFolder\Folder.ext"
		$allFilesMap.Get($baseName).Get($newFile.VersionIndex).Set($newFile.RemotionCountdown, $newFile);
	}
	# Ordena a lista
	$sortedFileMap = (GetSortedFileMap $allFilesMap);
	# Retorna o resultado
	Return $sortedFileMap;
}

# Retorna um objeto, dado um path
Function GetFileItem($filePath) {
	If(-Not $filePath) {
		Return $Null;
	}
	# Regex
	$regexOfBaseName = ("(?<BaseName>.*?)");
	$regexOfVersion = ("(?: ?" + ([Regex]::Escape($versionStart) + "(?<VersionIndex>[0-9]{1,5})" + [Regex]::Escape($versionEnd)) + ")?");
	$regexOfRemotion = ("(?: ?" + ([Regex]::Escape($remotionStart) + "(?<RemotionCountdown>[0-9]{1,5})" + [Regex]::Escape($remotionEnd)) + ")?");
	$regexOfExtension = ("(?<Extension>\.[^\.]*)?");
	$regexOfFile = ("^" + $regexOfBaseName + $regexOfVersion + $regexOfRemotion + $regexOfExtension + "$");
	$regexOfFolderRemotion = ("(?: ?" + [Regex]::Escape($remotionFolder) + ")");
	$regexOfFolder = ("^" + $regexOfBaseName + $regexOfFolderRemotion + $regexOfExtension + "$");
	# Novo File
	$fileName = (Split-Path -Path $filePath -Leaf);
	# Ex.:
	#   $filePath = "C:\Folder\SubFolder\File _version[v] _removeIn[r].ext"
	#   $fileName = "File _version[v] _removeIn[r].ext"
	If($fileName -Match $regexOfFolder) {
		# Ex.:
		#   BaseName = "Folder"
		#   RemotionCountdown = "r"
		#   Extension = ".ext"
		$versionIndex = -1;
		$remotionCountdown = 0;
		# Valor
		$newFolder = (NewFileItem $filePath $Matches.BaseName $versionIndex $remotionCountdown $Matches.Extension);
		Return $newFolder;
	} ElseIf($fileName -Match $regexOfFile) {
		# Ex.:
		#   BaseName = "File"
		#   VersionIndex = "v"
		#   RemotionCountdown = "r"
		#   Extension = ".ext"
		$versionIndex = -1;
		If($Matches.VersionIndex) {
			$versionIndex = [int]$Matches.VersionIndex;
		}
		$remotionCountdown = -1;
		If($Matches.RemotionCountdown) {
			$remotionCountdown = [int]$Matches.RemotionCountdown;
		}
		# Valor
		$newFile = (NewFileItem $filePath $Matches.BaseName $versionIndex $remotionCountdown $Matches.Extension);
		Return $newFile;
	}
	Return $Null;
}

# Retorna um objeto que pode ser inserido no fileMap
Function NewFileItem($filePath, $baseName, $versionIndex, $remotionCountdown, $extension) {
	Return [PSCustomObject]@{
		Path = $filePath;
		BaseName = $baseName;
		VersionIndex = $versionIndex;
		RemotionCountdown = $remotionCountdown;
		Extension = $extension;
	};
}

# Ordena um filemap dado
Function GetSortedFileMap($fileMap) {
	$sortedFileMap = [FileMap]::new();
	ForEach($nameKey In @($fileMap.List())) { # @() para "não modificar a lista original"(Como a lista original é modificada???)
		ForEach($versionKey In ($fileMap.Get($nameKey).List() | Sort-Object -Descending)) {
			ForEach($remotionKey In ($fileMap.Get($nameKey).Get($versionKey).List() | Sort-Object -Descending)) {
				$fileItem = $fileMap.Get($nameKey).Get($versionKey).Get($remotionKey);
				$sortedFileMap.Get($nameKey).Get($versionKey).Set($remotionKey, $fileItem);
			}
		}
	}
	Return $sortedFileMap;
}