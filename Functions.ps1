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

# Retorna uma lista ordenada de arquivos modificados no $destPath
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

# Retorna uma lista ordenada de arquivos que serão modificados no $destPath para refletir $origPath
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
	# INC
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
#   Todos ficam listados em ordem numérica reversa
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
	$orderedFilesMap = [FileMap]::new();
	ForEach($nameKey In $allFilesMap.List()) {
		ForEach($versionKey In ($allFilesMap.Get($nameKey).List() | Sort-Object -Descending)) {
			ForEach($remotionKey In ($allFilesMap.Get($nameKey).Get($versionKey).List() | Sort-Object -Descending)) {
				$fileItem = $allFilesMap.Get($nameKey).Get($versionKey).Get($remotionKey);
				$orderedFilesMap.Get($nameKey).Get($versionKey).Set($remotionKey, $fileItem);
			}
		}
	}
	# Retorna o resultado
	Return $orderedFilesMap;
}