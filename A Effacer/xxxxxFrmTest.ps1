
<#
http://www.wpf-tutorial.com
http://www.wpf-tutorial.com/datagrid-control/details-row/
http://notscott.blogspot.fr/2015/09/snazzy-up-your-powershell-with-gui.html
#>
Function Details
{
        return 'hello'
Write-host 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh'
return 'hello'
}
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase


<# Munge to remove what PowerShell doesn't like and cast as XML
#     Remove design-time ignorable tags
#     Convert "x:Name" nodes to "Name"
#     Remove Window classing
[xml]$xaml = $inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
# Load WPF support and our XML into a form
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
try {
    $Form = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
    }
catch {
    Write-Host "Failed to load Windows.Markup.XamlReader. Invalid XML?"
    exit
    } 
#>
#----------------------------------------------------------------------------------------------------------------
# Get the content from the XAML file for the Form Main
#----------------------------------------------------------------------------------------------------------------
$fMainXaml = [XML](Get-Content 'c:\_scripts\adreports\FrmTest.xaml')
# Create an object for the XML content
$fMainXamlReader = New-Object System.Xml.XmlNodeReader $fMainXaml
# Load the content so we can start to work with it
$fMain = [Windows.Markup.XamlReader]::Load($fMainXamlReader)
#Connect to Controls 
$fMainXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
	
	New-Variable -Name $_.Name -Value $fMain.FindName($_.Name) -Force
}
$users = @()
$users += New-Object PSObject -prop @{ Id = 1; Name = 'John Doe'; Birthday =  '23/7/23'; ImageUrl = "http://www.wpf-tutorial.com/images/misc/john_doe.jpg" ;}
$users += New-Object PSObject -prop @{ Id = 2; Name = 'Jane Doe'; Birthday =  '17/1/1974' ;}
$users += New-Object PSObject -prop @{ Id = 3; Name = 'Sammy Doe'; Birthday = '02/09/1991' ;}

$lview = [System.Windows.Data.ListCollectionView]$Users
$dgUsers.ItemsSource = $lview

[System.Windows.RoutedEventHandler]$clickEvent = {
    param ($sender,$e)
        Write-Host "Clicked row $($dgUsers.SelectedItem.Row.Name)"
    }

# Show the form
$fMain.ShowDialog()

