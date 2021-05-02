$CenterScreen = [System.Windows.Forms.FormStartPosition]::CenterScreen;
$form1.StartPosition = $CenterScreen;



$form1_Load={
	#Tittar om ordboken exiterar
	$Path1 = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
	$fileToCheck = "$Path1\ord.xml"
	if (Test-Path $fileToCheck -PathType leaf)
	{
		$Path1 = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
		$version = Get-Content 	$Path1\ord.xml | Select -Index 0
		$ordbokenversion.Text = $version.split(':')[1].split(' ')
	}
}

#Vilka filer och format som kan öppnas i programmet.
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
	#InitialDirectory = [Environment]::GetFolderPath('MyDocuments')
	Multiselect = $true
	Filter	    = 'Text (*.htm, *.html, *.txt)|*.html;*.htm;*.txt' # Specified file types
	Title	    = 'Välj fil...'
}

#Viktig då efter man packat ihop filen till en exe för att programmet ska hitta till sin ursprungsmapp, fungerar dock ej som "rå" ps1-fil.
$Path = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])

#Progress-baren med hur många steg m.m. den ska visa.
$progressbar1.Minimum = 0;
$progressbar1.Maximum = 100;
$progressbar1.Value = 0;
$progressbar1.Step = 0;

#Där konverteringen sker och ord byts ut med modernare ord.
$editButton_Click = {
	#Rensar powershell-rutan och lägger till namn på fil som du laddat in m.m.
	$powershellBox.Clear()
	
	$basicForm.UseWaitCursor = $true
	$progressbar1.Value = 0;
	$namn = Split-Path $FileBrowser.FileNames -Leaf
	$powershellBox.AppendText((('01. Skapar backup på filerna "') + ($namn) + ('"' + "`r`n")));
	Start-Sleep -Seconds 1
	$progressbar1.Value = 20;
	
	Get-ChildItem -Path $FileBrowser.FileNames | Copy-Item -Destination { "$($_.DirectoryName)\$($_.BaseName) $(get-date -f yyyMMddTHHmmssffff)$($_.extension)" }
	
	$powershellBox.AppendText(("02. Konverterar boken/böckerna, det kan ta flera minuter`r`n"));
	Start-Sleep -Seconds 1
	
	#Hämtar in orden ur ordböckerna, den "officiella" och din egna.	
	$ord = Get-Content $Path\ord.xml, $Path\egenordbok.xml -encoding utf8
	
	#Om oldify är iklickad så kan den föråldra modern text. Gör samma som ovan men tvärtom.
	if ($checkboxOldify.Checked -eq $true)
	{
		
		$paths = $FileBrowser.FileNames;
		If ($FileBrowser.FileNames -like "*\*")
		{
			
			foreach ($file in Get-ChildItem $paths)
			{
				
				Get-Content $Path\ord.xml, $Path\egenordbok.xml -encoding utf8 | foreach {
					$replace, $find = $_ -split ':'
					Write-Progress -Activity "Replacing Words" -CurrentOperation "Ersätter $($find) med $($replace)" -Status "Processing $($ord.IndexOf($_) + 1) of $($ord.Length)"
					((Get-Content $file -encoding utf8) -creplace "(\b)$find(\b)", $replace) | Set-Content $file -encoding utf8
					
					
				}
				
				
			}
			
			
		}
		
		
		
		
		
		#RADERA
		#		Get-Content $Path\ord.xml -encoding utf8 | foreach {
		#			$replace, $find = $_ -split ':'
		#			Write-Progress -Activity "Replacing Words" -CurrentOperation "Ersätter $($replace) med $($find)" -Status "Processing $($ord.IndexOf($_) + 1) of $($ord.Length)"
		#			((Get-Content $FileBrowser.FileNames -encoding utf8) -creplace "(\b)$replace(\b)", $find) | Set-Content $FileBrowser.FileNames -encoding utf8
		#		}
		#SLUT RADERA	
		
	}
	else
	{
		
		$paths = $FileBrowser.FileNames;
		If ($FileBrowser.FileNames -like "*\*")
		{
			
			foreach ($file in Get-ChildItem $paths)
			{
				
				Get-Content $Path\ord.xml, $Path\egenordbok.xml -encoding utf8 | foreach {
					$find, $replace = $_ -split ':'
					Write-Progress -Activity "Replacing Words" -CurrentOperation "Ersätter $($find) med $($replace)" -Status "Processing $($ord.IndexOf($_) + 1) of $($ord.Length)"
					((Get-Content $file -encoding utf8) -creplace "(\b)$find(\b)", $replace) | Set-Content $file -encoding utf8
					
					
				}
			}
			
		}
	}
	$powershellBox.AppendText(("03. Konvertering klar av " + ($FileBrowser.FileNames) + "`r`n"));
	$powershellBox.AppendText(("`r`n         Du finner den i:`r`n" + (Split-Path $FileBrowser.FileNames) + ("`r`n`r`n")));
	
	$basicForm.UseWaitCursor = $false
	Write-Progress -Activity "Klar..." -Completed
	$progressbar1.Value = 100;
	
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Nu är boken konverterad.")
}

$pathTextBox_TextChanged = {
	
	
}

$progressbar1_Click = {
	
	
}

$editButton1_Click = {
	#Här sparas din egna ordlista.
	Add-Content $Path\egenordbok.xml -encoding utf8 ($gammalTextBox.Text + ":" + $nyTextBox.Text).ToLower()
	Add-Content $Path\egenordbok.xml -encoding utf8 (($gammalTextBox.Text.Substring(0, 1)).toupper() + ($gammalTextBox.Text.Substring(1, ($gammalTextBox.Text.length - 1)).ToLower()) + ":" + ($nyTextBox.Text.Substring(0, 1)).toupper() + ($nyTextBox.Text.Substring(1, ($nyTextBox.Text.length - 1)).ToLower()))
	#Detta sorterar ordboken i bokstavsordning, onödig så inaktiverad.
	#Get-Content $Path\egenordbok.xml | sort | Set-Content $Path\egenordbok.xml
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Ordet är nu tillagd i ordlistan.")
}

$sok_ny_version_fraga_Click = {
	#TODO: Place custom script here
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Visar vilken version av ordboken du har.")
	
}

$buttonLaddaNerSenasteOrdbo_Click = {
	#Laddar ner ny bok, skriver dock över senaste, ska skriva om kod.
	#TODO: Ladda ner ny bok, jämför med gamla om det ligger nya ord tillagda utöver de som är nya.
	$Path1 = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
	Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/starinspace/18BOK-OLD2NEW/main/ord.xml' -OutFile $Path1\ord.xml
	
	
	
	#Fyller i version-numret
	$Path1 = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
	$fileToCheck = "$Path1\ord.xml"
	if (Test-Path $fileToCheck -PathType leaf)
	{
		$Path1 = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0])
		$version = Get-Content 	$Path1\ord.xml | Select -Index 0
		$ordbokenversion.Text = $version.split(':')[1].split(' ')
	}
	#Fyller i numret om den existerar, annars låter den texten "ordboken saknas" stå
	
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Nu är senaste ordboken nedladdad.")
	
}

$internetbok_TextChanged = {
	#Hämtar versionen från ordboken från internet/Github
	$WebResponse = Invoke-WebRequest https://raw.githubusercontent.com/starinspace/18BOK-OLD2NEW/main/ord.xml
	$webversion = $WebResponse.Content.split(':')[1].split('') -replace "[^0-9-]", ''
	$internetbok.text = $webversion
}

$buttonTittaNyVersion_Click = {
	#TODO: Place custom script here
	$WebResponse = Invoke-WebRequest https://raw.githubusercontent.com/starinspace/18BOK-OLD2NEW/main/ord.xml
	$webversion = $WebResponse.Content.split(':')[1].split('') -replace "[^0-9-]", ''
	$internetbok.text = $webversion
	
	
}

$updatefraga_Click = {
	#TODO: Place custom script here
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Titta om ny version finns, kräver internet.")
}

$fragadublett_Click = {
	#TODO: Place custom script here
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Det här kan ta upp till någon minut.

Avbryt inte uan vänta tills filen är klar.

Det skapas dock en backup på filen, byt bara tillbaka namnet till ord.xml om något skulle gå fel.")
}

$fraganysvensk_Click = {
	#TODO: Place custom script here
	$oReturn = [System.Windows.Forms.Messagebox]::Show("Högst upp skriver du in det gamla ordet, längst ned skriver du in det nya ordet.

Det spelar ingen roll om du använder stora eller små bokstäver då ordboken som bildas automatiskt rättar till detta.

Glöm inte lägga till eventuella böjningar på ordet.")	
}

$fragaoldify_Click = {
	#TODO: Place custom script here
	[System.Windows.Forms.Messagebox]::Show("För att föråldra en ny text.")
}

$exit_Click = {
	#TODO: Place custom script here
	$form1.Close()
}

$Konvert_Click={
	#TODO: Place custom script here
			$tabKonvertera.Visible = $true
			$tabOrdbok.Visible = $false
			$tabHjalp.Visible = $false
			$tabOm.Visible = $false
}

$Words_Click={
	#TODO: Place custom script here
			$tabKonvertera.Visible = $false
			$tabOrdbok.Visible = $true
			$tabHjalp.Visible = $false
			$tabOm.Visible = $false
}

$Help_Click={
	#TODO: Place custom script here
			$tabKonvertera.Visible = $false
			$tabOrdbok.Visible = $false
			$tabHjalp.Visible = $true
			$tabOm.Visible = $false
}

$Om_Click={
	#TODO: Place custom script here
			$tabKonvertera.Visible = $false
			$tabOrdbok.Visible = $false
			$tabHjalp.Visible = $false
			$tabOm.Visible = $true
}

$panel2_Paint=[System.Windows.Forms.PaintEventHandler]{
#Event Argument: $_ = [System.Windows.Forms.PaintEventArgs]
	#TODO: Place custom script here
	
}

$selectButton_Click = {
	$progressbar1.Value = 0;
	#TODO: Place custom script here
	if ($FileBrowser.ShowDialog() -eq "Cancel")
	{
		[System.Windows.Forms.Messagebox]::Show("Du glömde välja en fil.")
	}
	else
	{
		$pathTextBox.Text = Split-Path $FileBrowser.FileNames -Leaf
		$mapp = Split-Path $FileBrowser.FileNames
	}
}



