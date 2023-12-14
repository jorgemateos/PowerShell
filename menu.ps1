cd c:\script\

do
{
    function Show-Menu
    {
        Clear-Host
        Write-Host "------------------------------------------------"
        Write-Host "Asistente de configuracion de Administradores IT"
        Write-Host "------------------------------------------------"
        Write-Host
        Write-Host "(0) Instalar modulos de Powershell."
        Write-Host
        Write-Host "(1) Configuracion local."
        Write-Host "(2) Instalar Roles."
        Write-Host "(3) Active Directory."
        Write-Host
        Write-Host "(G) Generador de contraseña."
        Write-Host
        Write-Host "R: Reiniciar el sistemas."
        Write-Host "Q: Presiona 'Q' para salir."
        Write-Host
    }
        Show-Menu
        $OpcionMenu = Read-Host "Por favor, haz una selección"
        switch ($OpcionMenu)
        {
            '0' # Configuracion local
                {
                   .\configuracionlocal.ps1
                }

            '1' # Configuracion local
                {
                   .\configuracionlocal.ps1
                }

            '2' # Instalar Roles
                {
                   .\instalarroles.ps1
                }

            '3' # Active Directory
                {
                   .\activedirectory.ps1
                }

            '4' 
                {
                   'Elegiste la opción #4'
                }

            'g' # Generador de contraseña
                {
                   $Assembly = Add-Type -AssemblyName System.Web
                   [System.Web.Security.Membership]::GeneratePassword(10,3)
                }

            'r' # Reiniciar el sistemas
                {
                   Restart-Computer -Force
                }

            'q' 
                {
                   return
                }

            default 
                {
                    Write-Host "Opción no válida, por favor elige una opción del menú"
                }
        }
    
}while ($OpcionMenu -ne 'q')