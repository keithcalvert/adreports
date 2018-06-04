<#	
	.NOTES
	===========================================================================
 	Created on:   	10/03/2018 10:04
	Created by:   	k.calvert
	Organization: 	
	Filename:     	
	===========================================================================
	.DESCRIPTION
		Powershell to extract information from AD.
		Users and Computers
		WPF presentation with various export methods. (XLS, CSV, Html)
		This Main file loads the screens/Forms via WPF
		Each screen/form has a xxxxxxCode.ps1 for it's specific actions
		There are some ADxxx.ps1 files that contain common functions. 

		With help from
http://www.wpf-tutorial.com
http://www.wpf-tutorial.com/datagrid-control/details-row/
http://notscott.blogspot.fr/2015/09/snazzy-up-your-powershell-with-gui.html
#>

[string]$Global:scriptPath = split-path $SCRIPT:MyInvocation.MyCommand.Path -parent
$Global:Test = $false
$Global:Societe = 'Griesser Fr'
$Global:Domaine = 'domaine.int'
$Global:Pays = 'Fr'
$Global:Ou = ''
$Global:AdParamsInactive = 90

$Global:AdOrdinateur = ''
$Global:AdUtilsRecherche = ''
$Global:AdUtilisateur = ''
$Global:Path = ''
$Global:Reports = "$Global:scriptPath\Reports"
$Global:Icons = "$Global:scriptPath\Icons"
$Global:Images = "$Global:scriptPath\Images"

Function Out_Excel
{
	$fMain_lstUtils | Export-Excel "$global:Reports\Adreports.xlsx" –Show
}
Function Out_Html
{
	$fMain_lstUtils.SelectAll

	#$fMain_lstUtils.Rows | $hash

	$fMain_lstUtils.SelectAll()
	$SelectedRows = $fMain_lstUtils.SelectedRows
 
    $SelectedRows | Select-Object -ExpandProperty DataBoundItem | Export-Csv "$global:Reports\Adreports.xlsx" -NoTypeInformation
 
       # Invoke-Item C:\$temp
 
        # ! later Remove-Item -Path C:\$temp -Recurse -Force

	<#$fMain_lstUtils.Rows | 
     select -expand DataBoundItem |
     export-csv -path c:\ext\music.html -NoType
	# 	 select -expand DataBoundItem |ConvertTo-HTML | Out-File c:\_docs\Adusers.html
	 
<#	$hash = @{}; #hash table to store field name-value pairs
	$fMain_lstUtils.Items | %{ 
		$item = $_; 
		#$fields | %{ $hash[$_.uId] = $item[$_.uPrenom]  }; 
		$hash += $item }

	$hash | ConvertTo-HTML | Out-File c:\_docs\Adusers.html
#>
	#Invoke-Item c:\ext\music.html
}
Function Out_Csc
{
	$fMain_lstUtils | Export-Csv -Path c:\_docs\music.csv -Encoding ascii -NoTypeInformation
}
Function Get_Header
{Param 
    ($pRepNom)

	return "Adreports - $Global:Societe - $pRepNom"
}

if ($Global:Test -Eq $False)
{
    import-module ActiveDirectory
}

Add-Type –assemblyName PresentationFramework
Add-Type –assemblyName PresentationCore
Add-Type –assemblyName WindowsBase

. "$Global:scriptPath\AdParams.ps1"
. "$Global:scriptPath\AdOrdisFunctions.ps1"
. "$Global:scriptPath\AdUtilsFunctions.ps1"
. "$Global:scriptPath\FrmParamsCode.ps1"
. "$Global:scriptPath\FrmOrdiCode.ps1"
. "$Global:scriptPath\FrmUtilCode.ps1"
. "$Global:scriptPath\FrmTestCode.ps1"

#Trouve parametres systeme (Si ils exist's. Sinon Appel Ecran de parametrage.
if(![System.IO.File]::Exists("$Global:scriptPath\AdReports.xml")){
	#AdParamsOuvrirFrm
}

<# Munge to remove what PowerShell doesn't like and cast as XML
#     Remove design-time ignorable tags
#     Convert "x:Name" nodes to "Name"
#     Remove Window classing
$inputXAML = (Get-Content "$Global:scriptPath\FrmMain.xaml")

[xml]$xaml = $inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
# Load WPF support and our XML into a form
#[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
try {
    $fMainXaml = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
    }
catch {
    Write-Host "Failed to load Windows.Markup.XamlReader. Invalid XML?"
    exit
    } 
#>
#----------------------------------------------------------------------------------------------------------------
# Get the content from the XAML file for the Form Main
#----------------------------------------------------------------------------------------------------------------
$fMainXaml = [XML](Get-Content "$Global:scriptPath\FrmMain.xaml")
# Create an object for the XML content
$fMainXamlReader = New-Object System.Xml.XmlNodeReader $fMainXaml
# Load the content so we can start to work with it
$fMain = [Windows.Markup.XamlReader]::Load($fMainXamlReader)
#Connect to Controls 
$fMainXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | 
	ForEach-Object {
	New-Variable -Name $_.Name -Value $fMain.FindName($_.Name) -Force
}
<# Load XAML Objects into variables
$fMainXaml.SelectNodes("//*[@Name]") | 
    Where-Object { $_.Name -notlike "label_*" } |
    ForEach-Object { Set-Variable -Name $_.Name -Value $fMainXaml.FindName($_.Name) }
#$fMain_LstSortie =('Excel','Html','Pdf','Excel')
#>
$fmain_IconXl.Source = "$Global:Icons\iconxl.png" 
$fmain_IconHtml.Source = "$Global:Icons\iconxl.png" 
$fmain_IconCsv.Source = "$Global:Icons\iconxl.png" 

$Fmain.Title= Get_Header "AD Reports"
# Entete
$fMain_Domaine.Text = $Global:Domaine
$fMain_Ou.Text = $Global:Ou

# Tab1 - Utilisateur
$fMain_T1_TxAdUtilsNb.Content 			= AdUtilsCount('Nb')
$fMain_T1_TxAdUtilsInactif.Content 		= AdUtilsCount('Inact')
$fMain_T1_TxAdUtilsDesactif.content 	= AdUtilsCount('Desactif')
$fMain_T1_TxAdUtilsVerouille.Content 	= AdUtilsCount('Verouille')
$fMain_T1_TxAdUtilsMdpExpire.Content 	= AdUtilsCount('MdpExpire')
$fMain_T1_TxAdUtilsMdpJamaisxpire.Content = AdUtilsCount('JamaisXpire')

# Tab1 - Ordinateur
$fMain_T1_TxAdOrdisNb.Content 			= AdOrdisCount('Nb')
$fMain_T1_TxAdOrdisDesactif.content 	= AdOrdisCount('Desactif')

# Event Handlers - Utilisateurs
	$mnuParam.Add_Click({
		Write-Host 'test click'
		AdParamsOuvrirFrm
	})
	$mnuTest.Add_Click({
		Write-Host 'test click'
		AdTestOuvrirFrm
	})

$fMain_T1_TxAdUtilsNb.Add_Click({
        $TabCtr.SelectedIndex = 2
		SetAdUtilsType 'Nb'
		RemplieLstUtils 
	})
$fMain_T1_TxAdUtilsInactif.Add_Click({
        $TabCtr.SelectedIndex = 2
		SetAdUtilsType 'Inact'
		RemplieLstUtils 
	})
$fMain_T1_TxAdUtilsDesactif.Add_Click({
        $TabCtr.SelectedIndex = 2
		SetAdUtilsType 'Desactif'
		RemplieLstUtils 
	})
$fMain_T1_TxAdUtilsVerouille.Add_Click({
        $TabCtr.SelectedIndex = 2
		SetAdUtilsType 'Verouille'
		RemplieLstUtils 
	})
$fMain_T1_TxAdUtilsMdpExpire.Add_Click({
        $TabCtr.SelectedIndex = 2
		SetAdUtilsType 'MdpExpire'
		RemplieLstUtils 
	})
$fMain_T1_TxAdUtilsMdpJamaisxpire.Add_Click({
        $TabCtr.SelectedIndex = 2
		SetAdUtilsType 'JamaisXpire'
		RemplieLstUtils 
	})

# Event Handlers - Utilisateur
$fMain_T1_TxAdOrdisNb.Add_Click({
        $TabCtr.SelectedIndex = 1
		SetAdOrdisType 'Nb'
		RemplieLstOrdis 
	})

$fMain_T1_TxAdOrdisDesactif.Add_Click({
        $TabCtr.SelectedIndex = 1
		SetAdOrdisType 'Desactif'
		RemplieLstOrdis 
	})

$fMain_BtnSelection.Add_Click({
	Switch ($TabCtr.SelectedIndex)
	{
		1	{If ($fMain_LstOrdis.Items.Count -gt 0)
				{		
					$Global:AdOrdinateur = $fMain_lstOrdis.SelectedItem.oOrdi
					AdOrdiOuvrirFrm 
				}
	}
		2	{If ($fMain_LstUtils.Items.Count -gt 0)
				{		
					$Global:AdUtilisateur = 6 #$fMain_lstUtils.SelectedItem
					AdUtilOuvrirFrm
				}
			}
	}
	
})

$fMain_CmbSortie.Add_SelectionChanged({
    #If (Add_SelectionChanged(.Items.Count -gt 0)
    #{
		Out_Html
		Switch ($fMain_CmbSortie.text)
		{
#			'Excel' 	{Out_Excel}
#			'Csv' 		{Out_Csv}
			'Html' 		{Out_Html}
		}
 <#   }
	else
	{
		msgbox "Pas d'enregistrements"
	}
	#>
})

	<#
$fMain_Lstutils.AddHandler({
    $x=1
    If ($fMain_Lstutils.Items.Count -gt 0)
    {
		$Global:AdUtilisateur = 6 #$lstUtils.SelectedItem
		AdUtilRemplieFrm
		$fUtil.ShowDialog()
    }
})
#>

# Show the form
$fMain.ShowDialog()
