cd c:\script\

do
{
    function Show-MenuConfiguracionLocal
    {
        Clear-Host
        Write-Host "------------------------------------------------"
        Write-Host "              Configuracion Local               "
        Write-Host "------------------------------------------------"
        Write-Host
        Write-Host "(1) Cambiar el nombre del equipo."
        Write-Host "(2) Cambiar servidor de NTP."
        Write-Host "(3) Redes."
        Write-Host
        Write-Host "(4) Activar antivirus."
        Write-Host "(5) Activar Firewall."
        Write-Host
        Write-Host
        Write-Host ">>>> Informes"
        Write-Host "------------------------------------------------"
        Write-Host "(6) Informe - Lista de procesos."
        Write-Host "(7) Informe - Conexiones TCP."
        Write-Host "(8) Informe - Servicios activos."
        Write-Host "(9) Informe - Aplicaciones Instaladas."
        Write-Host
        Write-Host
        Write-Host ">>>> Reparacion"
        Write-Host "------------------------------------------------"
        Write-Host "(10) Reparar - sfc /scannow."
        Write-Host "(11) Reparar - Reparación de imagen de Windows."
        Write-Host "(12) Reparar - Análisis de disco."
        Write-Host
        Write-Host
        Write-Host "(13) Restablecer la configuracion de seguridad."
        Write-Host
        Write-Host "(Q) Presiona 'Q' para ir al menu anterior."
        Write-Host
    }

        Show-MenuConfiguracionLocal
        $ValorConLocal = Read-Host "Por favor, haz una selección"
        switch ($ValorConLocal)
        {
            '1' # Cambiar el nombre del equipo
                {
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
                                        pause
                                      
                                        .\configuracionlocal.ps1
                                    }

                                'N' {
                                        .\configuracionlocal.ps1
                                    }

                                default {
                                    Write-Host "Opción no válida, por favor elige una opción del menú"
                                }
                            }
                        }while ($sino -ne 'N')
                       
                 ######### Fin Opciones Si/NO #########
                }

            '2' # Cambiar servidor de NTP
                {
                 ######### SubMenu Servidor NTP #########
                        function Show-MenuNTP
                        {
                            Clear-Host
                            $Valor = w32tm /query /source
                            Write-Host "------------------------------------------------"
                            Write-Host "                 Servidor NTP                   "
                            Write-Host "------------------------------------------------"
                            Write-Host
                            Write-Host "Servidor actual: $Valor"
                            Write-Host
                            Write-Host "(1) Spain - es.pool.ntp.org."
                            Write-Host "(2) Manual."
                            Write-Host
                            Write-Host "(C) Presiona 'C' para cancelar."
                            Write-Host
                        }
                 ######### Fin SubMenu Servidor NTP #########
                 ######### Opciones SubMenu Servidor NTP #########
                        do
                        {
                            Show-MenuNTP
                            $ValorSrvNTP = Read-Host "Por favor, haz una selección"
                            switch ($ValorSrvNTP)
                            {
                                '1' {
                                       echo w32tm /config /syncfromflags:manual /manualpeerlist:»0.es.pool.ntp.org 1.es.pool.ntp.org″ /update
                                        
                                        Stop-Service w32time
                                        Start-Service w32time
                                        
                                        .\configuracionlocal.ps1
                                    }

                                '2' {
                                        $servidorntp1 = Read-Host "Elige el Primer servidor"
                                        $servidorntp2 = Read-Host "Elige el Segundo servidor"

#                                       w32tm /config /syncfromflags:manual /manualpeerlist:"$servidorntp1 $servidorntp2" /update

                                        Stop-Service w32time
                                        Start-Service w32time

                                        .\configuracionlocal.ps1
                                    }

                                'C' {
                                        return
                                    }

                                default {
                                        Write-Host "Opción no válida, por favor elige una opción del menú"
                                    }
                            }

                        }while ($ValorSrvNTP -ne 'c')
                 ######### Fin SubMenu Servidor NTP #########
                }

            '3' # Redes
                {
                   .\redes.ps1
                }

            '4' # Activar antivirus
                {
                   Set-MpPreference -DisableRealtimeMonitoring $false
                }

            '5' # Activar Firewall
                {
                   Set-MpPreference -DisableRealtimeMonitoring $false
                }
            '6' # Informe - Lista de procesos
                {
                   Get-Process | Select-Object ProcessName, Path > "Informe - Lista de procesos.txt"
                }

            '7' # Informe - Conexiones TCP
                {
                   Get-NetTCPConnection -State Established > "Informe - Conexiones TCP.txt"
                }

            '8' # Informe - Servicios activos
                {
                   Get-Service | Where-Object {$_.status -eq "running"} > "Informe - Servicios Activos.txt"
                }

            '9' # Informe - Aplicaciones Instaladas
                {
                   Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Sort-Object InstallDate > "Informe - Aplicaciones Instaladas.txt"
                }

            '10' # Reparar - sfc /scannow
                {
                   sfc /scannow
                }

            '11' # Reparar - Reparación de imagen de Windows
                {
                   DISM /Online /Cleanup-Image /RestoreHealth
                }

            '12' # Reparar - Análisis de disco
                {
                   chkdsk /f
                }

            '13' # Restablecer la configuracion de seguridad
                {
                   Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Restricted
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

} while ($OpcionMenu -ne 'q')

