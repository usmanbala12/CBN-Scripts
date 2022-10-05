#SOURCE AND DESTINATION FOLDER PASSED AS SCRIPT CALL ARGUMENTS
$soucreFolder = $args[0]
$destinationFolder = $args[1]

Write-Host "THIS SCRIPT WOULD CLASSIFY PDF AND XML FILES ACCORDING TO THE FILE'S METADATA CONTAINED IN THE XML FILES `n `n"

#Add all files in source folder to array
$xmlfiles = [System.Collections.ArrayList](Get-ChildItem -Path $soucreFolder\* -Include *.xml -Name)

# perform the following operations if the xmlfiles array is not empty
while ($xmlfiles[-1] -ne $null) {

    #take the last element in xmlfiles array
    $currentXmlFile = $xmlfiles[-1]
    Write-Host "current filename $currentXmlFile"

    #convert the xml file into a dotnet xml object
    [xml]$currentXmlObject = Get-Content -Path .\$soucreFolder\$currentXmlFile

    #extract the classification field
    $classification = $currentXmlObject.FOLDER.SHEET.FIELD | Where-object TYPE  -eq 'CLASSIFICATION' | %{$_.innerText}

    #split the string using a regex pattern
    $classification = $classification -split '([A-Z]{3})\/([A-Z]{3})\/([123])\/([A-Z]{3})\/(\d*)\/(\d*)'

    #save the second element of the array as folder name
    $foldername = $classification[1]

    #remove the .xml extension from the xml filename and add a pdf extension
    $pdffilename = $currentXmlFile -split '([A-Za-z0-9_]+)\.([a-z]{3})'

    $pdffilename = $pdffilename[1] + '.pdf'

    #create destination folder if it does not exist 
    if(-not (Test-Path -Path $destinationFolder\$foldername))  {
        Write-Host 'Destination folder not available ------ creating folder'
        New-Item $destinationFolder\$foldername -Type Directory
    }

    #move xml file to destination folder
    Write-Host "Moving $currentXmlFile to $foldername ---------"
    Move-Item -Path .\$soucreFolder\$currentXmlFile -Destination $destinationFolder\$foldername

    #move pdf file to destination folder
    Write-Host "Moving $pdffilename to $foldername ---------"
    Move-Item -Path .\$soucreFolder\$pdffilename -Destination $destinationFolder\$foldername

    #remove last element from array
    $xmlfiles.Remove($xmlfiles[-1])
}