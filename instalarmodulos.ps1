do
{
    function Show-MenuAD
    {
        Clear-Host
        Write-Host "------------------------------------------------"
        Write-Host "                Instalar Modulos                "
        Write-Host "------------------------------------------------"
        Write-Host
        Write-Host "(1) Modulo de Active Directory."
        Write-Host
        Write-Host
        Write-Host "(Q) Presiona 'Q' para ir al menu anterior."
        Write-Host
    }

        Show-MenuAD
        $OpcionMenuAD = Read-Host "Por favor, haz una selección"
        switch ($OpcionMenuAD)
        {
            '1' # Modulo de Active Directory
                {
                    if (Get-WindowsFeature -Name "RSAT-AD-PowerShell") 
                        {
                            Write-Host "Este módulo ya lo tienes instalado."
                        } 
                       else
                        {
                            Write-Host "Instalando el módulo Active Directory..."
                            Install-WindowsFeature -Name "RSAT-AD-PowerShell" –IncludeAllSubFeature
                            Write-Host "El módulo Active Directory ha sido instalado."
                        }

                }

            '2' 
                {
                   'Elegiste la opción #2'
                }

            'q' {
                    .\menu.ps1

                }

            default {
                Write-Host "Opción no válida, por favor elige una opción del menú"
            }
        }
    
}while ($OpcionMenuAD -ne '3')