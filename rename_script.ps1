#SOURCE AND DESTINATION FOLDER PASSED AS SCRIPT CALL ARGUMENTS
$soucreFolder = $args[0]

Write-Host "THIS SCRIPT WOULD CLASSIFY PDF AND XML FILES ACCORDING TO THE FILE'S METADATA CONTAINED IN THE XML FILES `n `n"

#Add all files in source folder to array
$xmlfiles = [System.Collections.ArrayList](Get-ChildItem -Path $soucreFolder\* -Include *.xml -Name)

# perform the following operations if the xmlfiles array is not empty
while ($xmlfiles[-1] -ne $null) {

    #take the last element in xmlfiles array
    $currentXmlFile = $xmlfiles[-1]
    Write-Host "current filename $currentXmlFile"

    if($currentXmlFile.Length -gt 70) {
	#convert the xml file into a dotnet xml object
        [xml]$currentXmlObject = Get-Content -Path .\$soucreFolder\$currentXmlFile

        #extract the classification field
        $nameContainer =  $CurrentXmlObject.FOLDER.SHEET.IMAGE[0] | %{$_.innerText}

        $originalName = $nameContainer.Split('\')[4]

        $pdffilename = $currentXmlFile.Split('.')[0] + '.pdf'

        $newxmlname = $originalName + '.xml'

        $newpdfname = $originalName + '.pdf'

        #rename xml file
        Rename-Item -Path .\$soucreFolder\$currentXmlFile -NewName $newxmlname

        #rename pdf file
        Rename-Item -Path .\$soucreFolder\$pdffilename -Newname $newpdfname
    }

    
    #remove last element from array
    $xmlfiles.Remove($xmlfiles[-1])
}
