Function AdParamsOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Utilisateur
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file
    $fParamsXaml = [XML](Get-Content "$scriptPath\frmParams.xaml")
    # Create an object for the XML content
    $fParamsXamlReader = New-Object System.Xml.XmlNodeReader $fParamsXaml
    # Load the content so we can start to work with it
    $fParams = [Windows.Markup.XamlReader]::Load($fParamsXamlReader)
    #Connect to Controls 
    $fParamsXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fParams.FindName($_.Name) -Force
    }

    AdParamsRemplieFrm
    $fParams_BtnOk.Add_Click({
        $Global:Societe             = $fParams_Societe.Text
        $Global:Pays                = $fParams_Pays.Text
        $Global:Domaine             = $fParams_Domaine.Text
        $Global:Ou                  = $fParams_Ou.Text
        $Global:AdParamsInactive    = $fParams_Xpire.Text
    })

    $fParams_BtnCancel.Add_Click({
        AdParamsRemplieFrm
        $fParams.Close()
    })
    $fParams_BtnQuit.Add_Click({
        $fParams.Close()
	})
    $fParams.ShowDialog()
}
Function AdParamsRemplieFrm
{
    $fParams_Societe.Text   = $Global:Societe 
    $fParams_Pays.Text      = $Global:Pays
    $fParams_Domaine.Text   = $Global:Domaine 
    $fParams_Ou.Text        = $Global:Ou
    $fParams_Xpire.Text     = $Global:AdParamsInactive

}
