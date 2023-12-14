cd c:\script\

######### Menu Si/NO #########
function Show-MenuNTP
{
    Clear-Host
    $hostname = hostname
    Write-Host "Su nombre de equipo es: "$hostname
    Write-Host
}

######### Fin Menu Si/NO #########

######### Opciones Si/NO #########

do
{
    Show-MenuNTP
    $sino = Read-Host "Quieres cambiarlo (S/N)"
    switch ($sino)
    {
        'S' {
               $nombreEquipo = Read-Host -Prompt 'Que nombre quieres ponerle a este Equipo'
               echo "Rename-Computer -NewName $nombreEquipo -Restart"
               
               Show-Menu
            }

        'N' {
            Show-Menu

            }

    }
    pause
}
until ($sino -eq 'q')
