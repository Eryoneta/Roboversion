# Deleta arquivos e atualiza um filemap dado
Function DeleteFilesList($modifiedFilesMap, $filesToDelete, $listOnly) {
	If($filesToDelete.Count -eq 0) {
		Return;
	}
	# Da lista, deleta arquivos
	ForEach($fileToDelete In $filesToDelete) {
		# Deleta arquivo
		PrintText ("`tDeleted`t" + $fileToDelete.Path);
		If(-Not $listOnly) {
			Remove-Item -LiteralPath $fileToDelete.Path -Force;
		}
		# Deleta no fileMap
		$fileBasePath = (Split-Path -Path $fileToDelete.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToDelete.BaseName + $fileToDelete.Extension));
		$versionKey = $fileToDelete.VersionIndex;
		$remotionKey = $fileToDelete.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Remove($remotionKey);
	}
}

# Renomeia arquivos e atualiza um filemap dado
Function RenameRemovedFilesList($modifiedFilesMap, $filesToRename, $listOnly) {
	If($filesToRename.Count -eq 0) {
		Return;
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
		PrintText ("`tRenamed`t" + $fileToRename.Path + " ---> " + $newName);
		If(-Not $listOnly) {
			Rename-Item -LiteralPath $fileToRename.Path -NewName $newName -Force;
		}
		# Renomeia no fileMap
		$fileBasePath = (Split-Path -Path $fileToRename.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToRename.BaseName + $fileToRename.Extension));
		$versionKey = $fileToRename.VersionIndex;
		$remotionKey = $fileToRename.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Remove($remotionKey);
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Set($newRemotionCountdown, $fileToRename);
		$fileToRename.Path = (Join-Path -Path $fileBasePath -ChildPath $newName);
		$fileToRename.RemotionCountdown = $newRemotionCountdown;
	}
}

# Renomeia arquivos e atualiza um filemap dado
Function RenameVersionedFilesList($modifiedFilesMap, $filesToRename, $listOnly) {
	If($filesToRename.Count -eq 0) {
		Return;
	}
	# Da lista, renomeia arquivos
	ForEach($fileToRename In $filesToRename | Sort-Object -Property NewVersion) {
		$newVersion = $fileToRename.NewVersion;
		$fileToRename = $fileToRename.File;
		# Renomeia arquivo
		$version = (" " + $versionStart + $newVersion + $versionEnd);
		$remotion = "";
		If($fileToRename.RemotionCountdown -gt -1) {
			$remotion = (" " + $remotionStart + $fileToRename.RemotionCountdown + $remotionEnd);
		}
		$newName = ($fileToRename.BaseName + $version + $remotion + $fileToRename.Extension);
		PrintText ("`tRenamed`t" + $fileToRename.Path + " ---> " + $newName);
		If(-Not $listOnly) {
			Rename-Item -LiteralPath $fileToRename.Path -NewName $newName -Force;
		}
		# Renomeia no fileMap
		$fileBasePath = (Split-Path -Path $fileToRename.Path -Parent);
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToRename.BaseName + $fileToRename.Extension));
		$versionKey = $fileToRename.VersionIndex;
		$remotionKey = $fileToRename.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Remove($remotionKey);
		$modifiedFilesMap.Get($nameKey).Get($newVersion).Set($remotionKey, $fileToRename);
		$fileToRename.Path = (Join-Path -Path $fileBasePath -ChildPath $newName);
		$fileToRename.VersionIndex = $newVersion;
	}
}

# Copia arquivos e atualiza um filemap dado
Function CopyVersionedFilesList($modifiedFilesMap, $filesToCopy, $listOnly) {
	If($filesToCopy.Count -eq 0) {
		Return;
	}
	# Da lista, copia arquivos
	ForEach($fileToCopy In $filesToCopy) {
		$newVersion = $fileToCopy.NewVersion;
		$fileToCopy = $fileToCopy.File;
		# Copia arquivo
		$version = (" " + $versionStart + $newVersion + $versionEnd);
		$remotion = "";
		If($fileToCopy.RemotionCountdown -gt -1) {
			$remotion = (" " + $remotionStart + $fileToCopy.RemotionCountdown + $remotionEnd);
		}
		$fileBasePath = (Split-Path -Path $fileToCopy.Path -Parent);
		$newName = ($fileToCopy.BaseName + $version + $remotion + $fileToCopy.Extension);
		$newPath = (Join-Path -Path $fileBasePath -ChildPath $newName);
		PrintText ("`tCopied`t" + $fileToCopy.Path + " ---> " + $newPath);
		If(-Not $listOnly) {
			Copy-Item -LiteralPath $fileToCopy.Path -Destination $newPath -Force;
		}
		# Copia no fileMap
		$nameKey = (Join-Path -Path $fileBasePath -ChildPath ($fileToCopy.BaseName + $fileToCopy.Extension));
		$versionKey = $newVersion;
		$remotionKey = $fileToCopy.RemotionCountdown;
		$modifiedFilesMap.Get($nameKey).Get($versionKey).Set($remotionKey, ([PSCustomObject]@{
			Path = $newPath;
			BaseName = $fileToCopy.BaseName;
			VersionIndex = $newVersion;
			RemotionCountdown = $fileToCopy.RemotionCountdown;
			Extension = $fileToCopy.Extension;
		}));
	}
}

# Copia arquivos e atualiza um filemap dado
Function CopyRemovedFilesList($modifiedFilesMap, $filesToCopy, $listOnly) {
	If($filesToCopy.Count -eq 0) {
		Return;
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
		PrintText ("`tCopied`t" + $fileToCopy.Path + " ---> " + $newPath);
		If(-Not $listOnly) {
			Copy-Item -LiteralPath $fileToCopy.Path -Destination $newPath -Force;
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
}