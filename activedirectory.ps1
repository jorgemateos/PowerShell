cd c:\script\

do
{
    function Show-MenuAD
    {
        Clear-Host
        Write-Host "------------------------------------------------"
        Write-Host "                Active Directory                "
        Write-Host "------------------------------------------------"
        Write-Host
        Write-Host "(1) Información básica del dominio."
        Write-Host "(2) Controladores de dominio por nombre de host y funcionamiento."
        Write-Host
        Write-Host "2: Presiona '2' para esta opción."
        Write-Host "3: Presiona '3' para esta opción."
        Write-Host
        Write-Host "(Q) Presiona 'Q' para ir al menu anterior."
        Write-Host
    }

        Show-MenuAD
        $OpcionMenuAD = Read-Host "Por favor, haz una selección"
        switch ($OpcionMenuAD)
        {
            '1' # Información básica del dominio
                {
                   Get-ADDomain
                }

            '2' # Controladores de dominio por nombre de host y funcionamiento
                {
                   Get-ADDomainController -filter * | select hostname, operatingsystem
                }

            '3' 
                {
                   'Elegiste la opción #3'
                }

            'q' {
                    .\menu.ps1

                }

            default {
                Write-Host "Opción no válida, por favor elige una opción del menú"
            }
        }
    
}while ($OpcionMenuAD -ne '3')