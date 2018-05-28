<<<<<<< HEAD
Function AdOrdiOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Utilisateur
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file
    $fOrdiXaml = [XML](Get-Content "$scriptPath\frmOrdi.xaml")
    # Create an object for the XML content
    $fOrdiXamlReader = New-Object System.Xml.XmlNodeReader $fOrdiXaml
    # Load the content so we can start to work with it
    $fOrdi = [Windows.Markup.XamlReader]::Load($fOrdiXamlReader)
    #Connect to Controls 
    $fOrdiXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fOrdi.FindName($_.Name) -Force
    }

    $fOrdi.Title= Get_Header "Ordinateur"

    AdOrdiRemplieFrm 

    $fOrdi_BtnQuit.Add_Click({
        $fOrdi.Close()
	})

    $fOrdi.ShowDialog()
}
Function AdOrdiRemplieFrm
{

    $mOrdinateur =  Get-ADComputer "$Global:AdOrdinateur" -properties * 

    $fOrdi_Ordinateur.Text      = $mOrdinateur.Name
    $fOrdi_OS.Text              = $mOrdinateur.OperatingSystem
    $fOrdi_OSSp.Text            = $mOrdinateur.OperatingSystemServicePack
    $fOrdi_OSVer.Text           = $mOrdinateur.OperatingSystemVersion
    $fOrdi_Description.Text     = $mOrdinateur.Description
    $fOrdi_Location.Text        = $mOrdinateur.Location

}
=======
Function AdOrdiOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Utilisateur
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file
    $fOrdiXaml = [XML](Get-Content "$scriptPath\frmOrdi.xaml")
    # Create an object for the XML content
    $fOrdiXamlReader = New-Object System.Xml.XmlNodeReader $fOrdiXaml
    # Load the content so we can start to work with it
    $fOrdi = [Windows.Markup.XamlReader]::Load($fOrdiXamlReader)
    #Connect to Controls 
    $fOrdiXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fOrdi.FindName($_.Name) -Force
    }

    $fOrdi.Title= Get_Header "Ordinateur"

    AdOrdiRemplieFrm

    $fOrdi_BtnQuit.Add_Click({
        $fOrdi.Close()
	})

    $fOrdi.ShowDialog()
}
Function AdOrdiRemplieFrm
{Param 
    ($pOrdinateur)
    $mtxt = "Name -like '$pOrdinateur'"
    $mOrdinateur =  Get-ADComputer -Filter "$mTxt" -properties * 

    $fOrdi_Ordinateur.Text      = $mOrdinateur.Name
    $fOrdi_OS.Text              = $mOrdinateur.OperatingSystem
    $fOrdi_OSSp.Text            = $mOrdinateur.OperatingSystemServicePack
    $fOrdi_OSVer.Text           = $mOrdinateur.OperatingSystemVersion
    $fOrdi_Description.Text     = $mOrdinateur.Description
    $fOrdi_Location.Text        = $mOrdinateur.Location
   

}
>>>>>>> 8713df83f41947b1cfb8f404a1284f7f6ea94e33
