<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.149
	 Created on:   	10/03/2018 10:06
	 Created by:   	k.calvert
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Functions AD pour des utilisateurs.
#>
$Global:AdOrdisType

Function GetAdOrdisType
{
    return $Global:AdOrdisType
}
Function SetAdOrdisType
{Param 
    ([String]$pType)

    $Global:AdOrdisType = $pType
}

Function AdOrdisCount 
{Param 
    ([String]$pQuery)

		if ($Global:Test)
		{
			switch ($pQuery)
			{
				'Nb'		{ Return 100 }
				'Inact'		{ Return 101 }
				'Desactif'	{ Return 102 }
				'Verouille'	{ Return 103 }
				'MdpExpire' { Return 104 }
				'JamaisXpire' { Return 105 }
			}
        }
		else
		{
			$Query = AdOrdisGetQuery($pQuery)
            $execute = "(get-adComputer -filter $Query).count"
            write-host $execute
			$RetVal =  Invoke-Expression $Execute
			return $RetVal				
		}
        
		return 999
}

Function AdOrdisGetQuery
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
                        
			'Desactif' 	{ $Query = " 'enabled -eq  "
                            $query += '$False '
                            $Query += "'"                             
                            $where = '' 
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
        $x = "$Query $Where"
		return $x
}	

Function GetAdOrdinateurs
{
		$Ordinateurs = @()
		if ($Global:Test)
		{
            $Ordinateurs += New-Object PSObject -prop @{oOrdi="C0125061";oActif=$False;}
            $Ordinateurs += New-Object PSObject -prop @{oOrdi="C0126061";oActif=$False;}
            $Ordinateurs += New-Object PSObject -prop @{oOrdi="C525A061";oActif=$True;}
            $Ordinateurs += New-Object PSObject -prop @{oOrdi="C5621061";oActif=$False;}			
		}
        else
        {
            $x = GetAdOrdisType
            $Query = 'get-adcomputer -filter '
			$Query += AdOrdisGetQuery($x)
            $query +=  ' | foreach {
                $Ordinateurs += New-Object PSObject -prop @{
                    oOrdi=$_.Name;
                    oActif=$_.Enabled;
                    }
               }'
               
        invoke-EXPRESSION $query
        }

		return $Ordinateurs
}

Function RemplielstOrdis
{
#try to fill up Ordinateurs grid
$OrdisInfo = GetAdOrdinateurs
$lview = [System.Windows.Data.ListCollectionView]$Ordisinfo
$fMain_lstOrdis.ItemsSource = $lview
}
