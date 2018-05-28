<#	
	.NOTES
	===========================================================================
	 Created on:   	10/03/2018 10:06
	 Created by:   	k.calvert
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Functions AD pour des utilisateurs.
#>
$Global:AdUtilsType

Function GetAdUtilsType
{
    return $Global:AdUtilsType
}
Function SetAdUtilsType
{Param 
    ([String]$pType)

    $Global:AdUtilsType = $pType
}

Function AdUtilsCount 
{Param 
    ([String]$pQuery)

		if ($Global:Test)
		{
			switch ($pQuery)
			{
				'Nb'			{ Return 100 }
				'Inact'			{ Return 5 }
				'Desactif'		{ Return 2 }
				'Verouille'		{ Return 3 }
				'MdpExpire' 	{ Return 5 }
				'JamaisXpire' 	{ Return 18 }
			}
        }
		else
		{
			$Query = AdUtilsGetQuery($pQuery)
            $execute = "(get-aduser -filter $Query).count"
            write-host $execute
			$RetVal =  Invoke-Expression $Execute
			return $RetVal				
		}
		return 999
}
Function AdUtilsGetQuery
{Param 
    ([String]$pQuery)

		$time = (Get-Date).Adddays(- ($Global:AdUtilsInactive))
		$Query = ''
		switch ($pQuery)
		{
			'Nb' 		{ $Query = ' *'
                            $Where = ''
                        }
            
			'Inact' 	{ $Query = ' *'
                            $Where = ' | where {$_.LastLogonDate -le (Get-Date).AddDays(-60) -and $_.enabled -eq $true }' 
                        }
                        
			'Desactif' 	{ $Query = ' *'
                            $where = ' | where { $_.Enabled -eq $False }' 
                        }
                        
			'Verouille'	{ $Query = ' *'
                            $Where = ' | Where { $_.LockedOut -Eq $True }' 
                        }
                        
			'MdpExpire' { $Query = ' *' 
                            $Where = ''
                        }
                        
			'JamaisXpire' { $Query = '  *'
                            $Where = ' | Where { $_.PasswordNeverExpires -eq $True}' 
                          }
		}
        $x = "$Query -properties Name, GivenName, Surname, Enabled, PasswordExpired, PasswordNeverExpires $Where"
		return $x
}	

<#-------------------------------------------------------------------------------------
	Create fictious names for test or when no AD is available
-------------------------------------------------------------------------------------#>
Function GetAdFictious
{
	$Fictious = @()
	$Fictious += New-Object PSObject -prop @{
		uPrenom='James';
		uInitiales = 'L';
		uNom='Dupont';
		uNomConx='DPS006';
		uNomComp= 'l';
		uNomAff= 'James L Dupont';
		uID='JDUPO061';
		uDesc= 'Service backoffice';
		uBureau='004428645589'
		uNumTel= '0044l9868226';
		uEmail= 'jams.dupont@griesser.fr';
		uPageWeb= 'www.griesser.fr';
		uActif=$False;}
	$Fictious += New-Object PSObject -prop @{
		uPrenom='John';
		uInitiales = 'l';
		uNom='Blanc';
		uNomComp= 'l';
		uNomAff= 'l';
		uID='JBLAN061';
		uDesc= 'l';
		uNumTel= 'l';
		uEmail= 'l';
		uPageWeb= 'l';
		uNomConx='DPS006';
		uBureau='004428645589'
		uActif=$False;}
	$Fictious += New-Object PSObject -prop @{
		uPrenom='gina';
		uInitiales = 'l';
		uNom='Dupont';
		uNomComp= 'l';
		uNomAff= 'l';
		uID='GDUPO061';
		uDesc= 'l';
		uNumTel= 'l';
		uEmail= 'l';
		uPageWeb= 'l';
		uNomConx='DPS006';
		uBureau='004428645589'
		uActif=$False;}
	$Fictious += New-Object PSObject -prop @{
		uPrenom='Tyler';
		uInitiales = 'l';
		uNom='Leclerc';
		uNomComp= 'l';
		uNomAff= 'l';
		uID='JDUPO061';
		uDesc= 'l';
		uNumTel= 'l';
		uEmail= 'l';
		uPageWeb= 'l';
		uNomConx='DPS006';
		uBureau='004428645589'
		uActif=$False;}

	return $Fictious
}
Function GetAdUtilisateurs
{
		$Utilsateurs = @()
		if ($Global:Test)
		{
		
			foreach ($x in GetAdFictious)
			{
                $Utilsateurs += [pscustomobject]@{
                    uID=$x.uID;
					uPrenom=$x.uPrenom
					uNom=$x.uNom; 
                    uActif=$_.uActif;
                    uMdpExpired=$_.uMdpExpired;
                    uPeJ=$_.uPeJ;}
			}
		}
        else
        {
            $x = GetAdUtilsType
            $Query = 'get-aduser -filter '
			$Query += AdUtilsGetQuery($x)
            $query +=  ' | foreach {
                $Utilsateurs += [pscustomobject]@{
                    uID=$_.SamAccountName;
                    uPrenom=$_.GivenName;
                    uNom=$_.Surname;
                    uActif=$_.Enabled;
                    uMdpExpired=$_.PasswordExpired;
                    uPeJ=$_.PasswordNeverExpires;
                    }
               }'
               
        invoke-EXPRESSION $query
        }
		return $Utilsateurs
}

Function RemplieLstUtils
{
#try to fill up Utilisateurs grid
$userInfo = GetAdUtilisateurs
$lview = [System.Windows.Data.ListCollectionView]$Userinfo
$fMain_Lstutils.ItemsSource = $lview
}
