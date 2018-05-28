<<<<<<< HEAD
Function AdUtilOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Utilisateur
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file
    $fUtilXaml = [XML](Get-Content "$scriptPath\frmUtil.xaml")
    # Create an object for the XML content
    $fUtilXamlReader = New-Object System.Xml.XmlNodeReader $fUtilXaml
    # Load the content so we can start to work with it
    $fUtil = [Windows.Markup.XamlReader]::Load($fUtilXamlReader)
    #Connect to Controls 
    $fUtilXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fUtil.FindName($_.Name) -Force
    }

    $fUtil.Title= Get_Header "Utilisateur"

    AdUtilRemplieFrm

    $fUtil_BtnQuit.Add_Click({
        $fUtil.Close()
	})

    $fUtil.ShowDialog()
}
Function AdUtilRemplieFrm
{
    $txt = $fMain_Lstutils.selecteditem.uPrenom
    $txt += $fMain_Lstutils.selecteditem.uInitiales
    $txt += $fMain_Lstutils.selecteditem.uNom

    $fUtil_Prenom.Text      = $fMain_Lstutils.selecteditem.uPrenom
    $fUtil_Initiales.Text   = $fMain_Lstutils.selecteditem.uInitiales
    $fUtil_Nom.Text         = $fMain_Lstutils.selecteditem.uNom
    $fUtil_NomConx.Text     = $fMain_Lstutils.selecteditem.uNomConx
    $fUtil_NomComplet.Text  = $txt
    $fUtil_NomAff.Text      = $fMain_Lstutils.selecteditem.uNomAff
    $fUtil_ID.Text          = $fMain_Lstutils.selecteditem.uID 
    $fUtil_Desc.Text        = $fMain_Lstutils.selecteditem.uDesc
    $fUtil_Bureau.Text      = $fMain_Lstutils.selecteditem.uBureau
    $fUtil_NumTel.Text      = $fMain_Lstutils.selecteditem.uNumTel
    $fUtil_Email.Text       = $fMain_Lstutils.selecteditem.uEmail
    $fUtil_PageWeb.Text     = $fMain_Lstutils.selecteditem.uPageWeb

}
=======
Function AdUtilOuvrirFrm
{
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file for the Form Utilisateur
    #----------------------------------------------------------------------------------------------------------------
    # Get the content from the XAML file
    $fUtilXaml = [XML](Get-Content "$scriptPath\frmUtil.xaml")
    # Create an object for the XML content
    $fUtilXamlReader = New-Object System.Xml.XmlNodeReader $fUtilXaml
    # Load the content so we can start to work with it
    $fUtil = [Windows.Markup.XamlReader]::Load($fUtilXamlReader)
    #Connect to Controls 
    $fUtilXaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object {
        
        New-Variable -Name $_.Name -Value $fUtil.FindName($_.Name) -Force
    }

    $fUtil.Title= Get_Header "Utilisateur"

    AdUtilRemplieFrm

    $fUtil_BtnQuit.Add_Click({
        $fUtil.Close()
	})

    $fUtil.ShowDialog()
}
Function AdUtilRemplieFrm
{Param 
    ($pUtilisateur)
    $txt = $fMain_Lstutils.selecteditem.uPrenom
    $txt += $fMain_Lstutils.selecteditem.uInitiales
    $txt += $fMain_Lstutils.selecteditem.uNom

    $fUtil_Prenom.Text      = $fMain_Lstutils.selecteditem.uPrenom
    $fUtil_Initiales.Text   = $fMain_Lstutils.selecteditem.uInitiales
    $fUtil_Nom.Text         = $fMain_Lstutils.selecteditem.uNom
    $fUtil_NomConx.Text     = $fMain_Lstutils.selecteditem.uNomConx
    $fUtil_NomComplet.Text  = $txt
    $fUtil_NomAff.Text      = $fMain_Lstutils.selecteditem.uNomAff
    $fUtil_ID.Text          = $fMain_Lstutils.selecteditem.uID 
    $fUtil_Desc.Text        = $fMain_Lstutils.selecteditem.uDesc
    $fUtil_Bureau.Text      = $fMain_Lstutils.selecteditem.uBureau
    $fUtil_NumTel.Text      = $fMain_Lstutils.selecteditem.uNumTel
    $fUtil_Email.Text       = $fMain_Lstutils.selecteditem.uEmail
    $fUtil_PageWeb.Text     = $fMain_Lstutils.selecteditem.uPageWeb

}
>>>>>>> 8713df83f41947b1cfb8f404a1284f7f6ea94e33
