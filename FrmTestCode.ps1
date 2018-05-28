<<<<<<< HEAD
Function AdTestOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Testisateur
    #----------------------------------------------------------------------------------------------------------------
    $Fichxaml = "frmTestisateur.xaml"
    # Get the content from the XAML file
    $fTestXaml = [XML](Get-Content "$scriptPath\frmTest.xaml")
    # Create an object for the XML content
    $fTestXamlReader = New-Object System.Xml.XmlNodeReader $fTestXaml
    # Load the content so we can start to work with it
    $fTest = [Windows.Markup.XamlReader]::Load($fTestXamlReader)
    #Connect to Controls 
    $fTestXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fTest.FindName($_.Name) -Force
    }

    $fTest.ShowDialog()
=======
Function AdTestOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Testisateur
    #----------------------------------------------------------------------------------------------------------------
    $Fichxaml = "frmTestisateur.xaml"
    # Get the content from the XAML file
    $fTestXaml = [XML](Get-Content "$scriptPath\frmTest.xaml")
    # Create an object for the XML content
    $fTestXamlReader = New-Object System.Xml.XmlNodeReader $fTestXaml
    # Load the content so we can start to work with it
    $fTest = [Windows.Markup.XamlReader]::Load($fTestXamlReader)
    #Connect to Controls 
    $fTestXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fTest.FindName($_.Name) -Force
    }

    $fTest.ShowDialog()
>>>>>>> 8713df83f41947b1cfb8f404a1284f7f6ea94e33
}