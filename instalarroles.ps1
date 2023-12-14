cd c:\script\

do
{
    function Show-MenuAD
    {
        Clear-Host
        Write-Host "------------------------------------------------"
        Write-Host "                 Instalar Roles                 "
        Write-Host "------------------------------------------------"
        Write-Host
        Write-Host "(1) Rol de Active Directory."
        Write-Host "(2) Instalar Rol de Active Directory."
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
            '1' # Rol de Active Directory
                {
                   
                }

            '2' 
                {
                   .\activedirectory.ps1
                }

            '3' 
                {
                   'Elegiste la opción #3'
                }

            'q' 
                {
                    .\menu.ps1
                }

            default 
                {
                    Write-Host "Opción no válida, por favor elige una opción del menú"
                }
        }
    
}while ($OpcionMenuAD -ne '3')