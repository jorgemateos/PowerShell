function Show-tablainterfaces
{
    # Crea un array vacío para almacenar los objetos de resultado
    $resultados = @()

    # Obtén todas las interfaces de red
    $interfaces = Get-NetAdapter

    # Para cada interfaz de red
    foreach ($interfaz in $interfaces) 
        {
            # Crea un objeto vacío para almacenar la información de esta interfaz
            $resultado = New-Object PSObject

            # Añade el nombre de la interfaz al objeto
            $resultado | Add-Member -MemberType NoteProperty -Name "Interfaz" -Value $interfaz.InterfaceAlias

        # Añade si DHCP está habilitado al objeto
            if ($interfaz.DhcpEnabled) 
                {
                    $resultado | Add-Member -MemberType NoteProperty -Name "DHCP" -Value "True"
                }
            else 
                {
                    $resultado | Add-Member -MemberType NoteProperty -Name "DHCP" -Value "False"
                }

        # Obtén la configuración IP de la interfaz
        $configuracionIP = Get-NetIPAddress -InterfaceIndex $interfaz.ifIndex | Where-Object { $_.AddressFamily -eq 'IPv4' }

        # Para cada configuración IP
        foreach ($config in $configuracionIP) 
            {
                # Añade la dirección IP, la máscara de subred y la puerta de enlace predeterminada al objeto
                $resultado | Add-Member -MemberType NoteProperty -Name "Dirección IP" -Value $config.IPAddress
                $resultado | Add-Member -MemberType NoteProperty -Name "Subnet mask" -Value $config.PrefixLength
                $resultado | Add-Member -MemberType NoteProperty -Name "Gateway" -Value (Get-NetRoute -InterfaceIndex $config.ifIndex | Where-Object { $_.DestinationPrefix -eq '0.0.0.0/0' } | Select-Object -ExpandProperty NextHop)
            }

        # Añade los servidores DNS al objeto
        $resultado | Add-Member -MemberType NoteProperty -Name "Servidores DNS" -Value (Get-DnsClientServerAddress -InterfaceIndex $interfaz.ifIndex | Where-Object { $_.AddressFamily -eq 'IPv4' } | Select-Object -ExpandProperty ServerAddresses)

        # Añade el objeto de resultado al array de resultados
        $resultados += $resultado
        }

    # Muestra los resultados en formato de tabla
    $resultados | Format-Table
}

function Show-MenuIP
{
    Clear-Host
    Write-Host "------------------------------------------------"
    Write-Host "             Configuracion de Red               "
    Write-Host "------------------------------------------------"
    Show-tablainterfaces
    Write-Host "(1) Cambiar a IP estatica."
    Write-Host "(2) Cambiar los servidores DNS."
    Write-Host "(3) Habilitar DCHP."
    Write-Host "(4) Hacer Ping."
#    Write-Host "(5) Hacer Tracerouter."
    Write-Host
    Write-Host "(Q) Presiona 'Q' para ir al menu anterior."
    Write-Host
}

do
{

    Show-MenuIP
    $input = Read-Host "Por favor, haz una selección"
    switch ($input)
    {
        '1' # Cambiar a IP estatica
            {
                Clear-Host
                Show-tablainterfaces

                $interfaz = Read-Host "Escribe el nombre de la interfaz"
                do 
                {
                    $ip = Read-Host -Prompt 'Introduce una dirección IP'
                    $ipLibre = -not (Test-Connection -ComputerName $ip -Count 1 -Quiet)
                    if (-not $ipLibre) 
                    {
                        Write-Output "La dirección IP $ip está en uso. Por favor, introduce otra."
                    }
                } while (-not $ipLibre)

                $mask = Read-Host "Introduce la Mascara de Subred (24)(32)"
                $gateway = Read-Host "Introduce la puerta de Enlace"
                $dns = Read-Host "Escribe el DNS"


                # Deshabilitar DHCP
                echo Set-NetIPInterface -InterfaceAlias $interfaz -Dhcp Disabled

                # Configurar dirección IP estática
                echo New-NetIPAddress -InterfaceAlias $interfaz -IPAddress $ip -PrefixLength $mask -DefaultGateway $gateway

                # Configurar servidor DNS
                echo Set-DnsClientServerAddress -InterfaceAlias $interfaz -ServerAddresses "$dns"
            }

        '2' # Cambiar los servidores DNS
            {
                $interfaz = Read-Host "Escribe el nombre de la interfaz"
                $dns = Read-Host "Escribe el DNS"

                # Configurar servidor DNS
                Set-DnsClientServerAddress -InterfaceAlias $interfaz -ServerAddresses $dns
            }

        '3' # Habilitar DCHP
            {
                $interfaz = Read-Host "Escribe el nombre de la interfaz"

                # Habilitar DHCP
                Set-NetIPInterface -InterfaceAlias $interfaz -Dhcp Enabled
            }

        '4' # Hacer Ping
            {
                do {
                    $ip = Read-Host -Prompt 'Introduce una dirección IP'
                    $ipLibre = (Test-Connection -ComputerName $ip -Count 1 -Quiet)
                    if (-not $ipLibre) {
                        Write-Output "No hace ping."
                    }
                } while (-not $ipLibre)

                Write-Output "OK - Hay conexion."
            }

        '5' 
            {
                Clear-Host

                $ip = Read-Host -Prompt 'Introduce la URL, IP, Nombre de Equipo'

                Test-NetConnection -ComputerName "$ip" -TraceRoute
            }

        'q' 
            {
               .\configuracionlocal.ps1
            }

        default 
            {
                Write-Host "Opción no válida, por favor elige una opción del menú"
            }

    }
}while ($OpcionMenu -ne 'q')

