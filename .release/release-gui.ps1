Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$releaseScript = Join-Path $scriptDir "release.py"
$logPath = Join-Path $scriptDir "release-last.log"
$errPath = Join-Path $scriptDir "release-last.err.log"

# Set AppUserModelID to separate from standard PowerShell taskbar grouping
try {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class AppId {
        [DllImport("shell32.dll", SetLastError = true)]
        public static extern void SetCurrentProcessExplicitAppUserModelID([MarshalAs(UnmanagedType.LPWStr)] string AppID);
    }
"@
    [AppId]::SetCurrentProcessExplicitAppUserModelID("ContextStatus.ReleaseGUI.1")
} catch {}

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Context Status Release" Height="450" Width="550" MinHeight="350" MinWidth="450"
        WindowStartupLocation="CenterScreen" ResizeMode="CanResizeWithGrip"
        FontFamily="Segoe UI" Background="#F3F4F6">
    <Window.Resources>
        <Style x:Key="ModernButton" TargetType="Button">
            <Setter Property="Background" Value="#2563EB"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Padding" Value="15,8"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="6" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#1D4ED8"/>
                            </Trigger>
                            <Trigger Property="IsEnabled" Value="False">
                                <Setter Property="Background" Value="#9CA3AF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
        <Style x:Key="OutlineButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="White"/>
            <Setter Property="Foreground" Value="#374151"/>
            <Setter Property="BorderBrush" Value="#D1D5DB"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" CornerRadius="6" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center" Margin="{TemplateBinding Padding}"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#F9FAFB"/>
                                <Setter Property="BorderBrush" Value="#9CA3AF"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid Margin="25">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <TextBlock Text="Vers&#xE3;o da Release" FontWeight="SemiBold" FontSize="14" Foreground="#374151" Margin="0,0,0,5"/>
        <TextBox Name="txtVersion" Grid.Row="1" Margin="0,0,0,15" Padding="8,6" FontSize="14" BorderBrush="#D1D5DB" BorderThickness="1"/>

        <TextBlock Grid.Row="2" Text="T&#xED;tulo da Release" FontWeight="SemiBold" FontSize="14" Foreground="#374151" Margin="0,0,0,5"/>
        <TextBox Name="txtTitle" Grid.Row="3" Margin="0,0,0,15" Padding="8,6" FontSize="14" BorderBrush="#D1D5DB" BorderThickness="1"/>

        <TextBlock Grid.Row="4" Text="Notas da Release (Opcional)" FontWeight="SemiBold" FontSize="14" Foreground="#374151" Margin="0,0,0,5"/>
        <TextBox Name="txtDescription" Grid.Row="5" Margin="0,0,0,20" Padding="8,6" FontSize="14" BorderBrush="#D1D5DB" BorderThickness="1" TextWrapping="Wrap" AcceptsReturn="True" VerticalScrollBarVisibility="Auto"/>

        <StackPanel Grid.Row="6" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,0,0,0">
            <Button Name="btnCancel" Content="Cancelar" Style="{StaticResource OutlineButton}" Margin="0,0,10,0"/>
            <Button Name="btnPublish" Content="Publicar" Style="{StaticResource ModernButton}"/>
        </StackPanel>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$iconPath = Join-Path $scriptDir "github.ico"
if (Test-Path $iconPath) {
    try {
        $window.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create([Uri]::new($iconPath, [UriKind]::Absolute))
    } catch {}
}

$txtVersion = $window.FindName("txtVersion")
$txtTitle = $window.FindName("txtTitle")
$txtDescription = $window.FindName("txtDescription")
$btnPublish = $window.FindName("btnPublish")
$btnCancel = $window.FindName("btnCancel")

function DoEvents {
    $dispatcher = [System.Windows.Threading.Dispatcher]::CurrentDispatcher
    $dispatcher.Invoke([Action]{}, [System.Windows.Threading.DispatcherPriority]::Background)
}

$btnPublish.Add_Click({
    $rawVersion = $txtVersion.Text.Trim()
    
    # Extrai a versão usando regex caso o usuário digite texto extra
    $version = ""
    if ($rawVersion -match '(\d+(\.\d+)+)') {
        $version = $matches[1]
    } else {
        $version = $rawVersion -replace '[^\d\.]', ''
        $version = $version.Trim('.')
    }
    
    $title = $txtTitle.Text.Trim()
    $description = $txtDescription.Text.Trim()
    
    # Safely replace double quotes with single quotes
    $title = $title.Replace('"', "'")
    $description = $description.Replace('"', "'")

    if ([string]::IsNullOrWhiteSpace($version) -or [string]::IsNullOrWhiteSpace($title)) {
        [System.Windows.MessageBox]::Show("Por favor, preencha a versao e o titulo.", "Aviso", 0, 48)
        return
    }

    if (!($version -match '^\d+(\.\d+)+$')) {
        [System.Windows.MessageBox]::Show("A versao informada nao e valida. O campo Versao deve conter apenas numeros e pontos, ex: 1.0 ou 1.4.1", "Erro de Validacao", 0, 48)
        return
    }

    $btnPublish.IsEnabled = $false
    $btnPublish.Content = "Publicando..."
    $btnCancel.IsEnabled = $false
    $txtVersion.IsEnabled = $false
    $txtTitle.IsEnabled = $false
    $txtDescription.IsEnabled = $false
    $window.Cursor = [System.Windows.Input.Cursors]::Wait
    DoEvents

    try {
        Set-Location $repoRoot

        # 1. Verifica arquivos sensíveis
        $sensitive = @(".github_config", "github.txt", "secrets.txt")
        foreach ($f in $sensitive) {
            $tracked = git ls-files $f
            if (![string]::IsNullOrWhiteSpace($tracked)) {
                [System.Windows.MessageBox]::Show("Arquivo sensivel $f esta sendo rastreado pelo git. Cancele e remova-o.", "Erro de Seguranca", 0, 16)
                $window.Close()
                return
            }
        }

        # 2. Adiciona os arquivos ao git
        git add -A "status" 2>&1 | Out-Null
        git add "README.md" "CHANGELOG.md" ".gitignore" ".release" 2>&1 | Out-Null

        # 3. Commita se houver alterações
        git diff --cached --quiet
        if ($LASTEXITCODE -ne 0) {
            $commitMsg = "release: v{0} - {1}" -f $version, $description
            git commit -m $commitMsg 2>&1 | Out-Null
        }

        # 4. Faz o push
        git push 2>&1 | Out-Null

        # 5. Executa release.py para criar o ZIP e publicar a release no GitHub
        $pythonCmd = "python"
        try { python --version 2>&1 | Out-Null } catch {
            try { $pythonCmd = "py"; py -3 --version 2>&1 | Out-Null } catch {
                [System.Windows.MessageBox]::Show("Python nao encontrado. Instale o Python.", "Erro", 0, 16)
                $window.Close()
                return
            }
        }

        # Usa variável de ambiente para não quebrar a linha de comando com textos grandes
        $env:RELEASE_DESC_GUI = $description
        $argsList = @($releaseScript, $version, $title)
        
        # O uso do mesmo arquivo para Output e Error pode causar conflito de Lock de arquivo no Start-Process
        $process = Start-Process -FilePath $pythonCmd -ArgumentList $argsList -NoNewWindow -Wait -PassThru -RedirectStandardOutput $logPath -RedirectStandardError $errPath

        if ($process.ExitCode -eq 0) {
            [System.Windows.MessageBox]::Show("Release v$version publicada com sucesso no GitHub!", "Context Status Release", 0, 64)
        } else {
            [System.Windows.MessageBox]::Show("Falha ao publicar a release no GitHub. Consulte o log.", "Erro", 0, 16)
            if (Test-Path $errPath) {
                if ((Get-Item $errPath).length -gt 0) {
                    Start-Process "notepad.exe" $errPath
                    return
                }
            }
            Start-Process "notepad.exe" $logPath
        }
    } catch {
        [System.Windows.MessageBox]::Show("Ocorreu um erro inesperado: $_", "Erro Critico", 0, 16)
    } finally {
        $window.Close()
    }
})

$btnCancel.Add_Click({
    $window.Close()
})

$window.ShowDialog() | Out-Null
