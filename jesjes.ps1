Add-Type -AssemblyName PresentationFramework

# Functions for button clicks

function Restart_Computer {
    Restart-Computer -Force
}

function Shutdown_Computer {
    Stop-Computer -Force
}

function Sleep_Computer {
    Start-Sleep -Seconds 10
}

function Clean_Temp_Folder {
    try {
        Get-ChildItem -Path $env:TEMP -Recurse | Remove-Item -Force
        $OutputText.AppendText("Temp kaust puhastatud.`n")
    } catch {
        $OutputText.AppendText("Viga temp kausta puhastamisel: $_`n")
    }
}

function Empty_Recycle_Bin {
    Clear-RecycleBin -Force
    $OutputText.AppendText("Prügikast tühjendatud.`n")
}

function Install_Spotify {
    try {
        $url = "https://download.spotify.com/SpotifySetup.exe"
        $outputPath = "C:\Users\Core\AppData\Local\SpotifySetup.exe"
        Start-BitsTransfer -Source $url -Destination $outputPath
        Start-Process -FilePath $outputPath -ArgumentList "/silent"
        Start-Sleep -Seconds 10
        Start-Process -FilePath "C:\Users\Core\AppData\Roaming\Spotify\spotify.exe"
        $OutputText.AppendText("Spotify installeeritud ja avatud.`n")
    } catch {
        $OutputText.AppendText("Viga Spotify installimisel: $_`n")
    }
}

function Install_Discord {
    try {
        $url = "https://discord.com/api/download?platform=win"
        $outputPath = "C:\Users\Core\AppData\Local\DiscordSetup.exe"
        Start-BitsTransfer -Source $url -Destination $outputPath
        Start-Process -FilePath $outputPath -ArgumentList "/silent"
        Start-Sleep -Seconds 10
        Start-Process -FilePath "C:\Users\Core\AppData\Local\Discord\app-1.0.9048\Discord.exe"
        $OutputText.AppendText("Discord installeeritud ja avatud.`n")
    } catch {
        $OutputText.AppendText("Viga Discordi installimisel: $_`n")
    }
}

function Uninstall_MicrosoftEdge {
    try {
        Start-Process -FilePath "winget" -ArgumentList "uninstall --force Microsoft.Edge"
        $OutputText.AppendText("Microsoft Edge eemaldatud.`n")
    } catch {
        $OutputText.AppendText("Viga Microsoft Edge eemaldamisel: $_`n")
    }
}

function Set_Volume_Max {
    (New-Object -ComObject WScript.Shell).SendKeys([char]0xAF)
    $OutputText.AppendText("Helitugevus maksimumile seadistatud.`n")
}

function Set_Volume_Min {
    (New-Object -ComObject WScript.Shell).SendKeys([char]0xAE)
    $OutputText.AppendText("Helitugevus miinimumile seadistatud.`n")
}

function Install_Browser {
    $checkedBoxes = @()
    foreach ($checkBox in $StackPanel2.Children) {
        if ($checkBox.IsChecked) {
            $checkedBoxes += $checkBox.Content
        }
    }

    foreach ($browser in $checkedBoxes) {
        switch ($browser) {
            "Google Chrome" {
                Start-Process -FilePath "winget" -ArgumentList "install --silent --accept-package-agreements Google.Chrome"
                $OutputText.AppendText("Google Chrome installeeritud.`n")
            }
           "Microsoft Edge" {
                Start-Process -FilePath "winget" -ArgumentList "install --silent --accept-package-agreements Microsoft.Edge"
                $OutputText.AppendText("Microsoft Edge installeeritud.`n")
            }
            "Mozilla Firefox" {
                Start-Process -FilePath "winget" -ArgumentList "install --silent --accept-package-agreements Mozilla.Firefox"
                $OutputText.AppendText("Firefox installeeritud.`n")
            }
            "Opera" {
                Start-Process -FilePath "winget" -ArgumentList "install --silent --accept-package-agreements Opera.Opera"
                $OutputText.AppendText("Opera installeeritud.`n")
            }
            "Brave" {
                Start-Process -FilePath "winget" -ArgumentList "install --silent --accept-package-agreements Brave.Brave"
                $OutputText.AppendText("Brave installeeritud.`n")
            }
        }
    }
}

function Uninstall_Browser {
    $checkedBoxes = @()
    foreach ($checkBox in $StackPanel2.Children) {
        if ($checkBox.IsChecked) {
            $checkedBoxes += $checkBox.Content
        }
    }

    foreach ($browser in $checkedBoxes) {
        switch ($browser) {
            "Google Chrome" {
                Start-Process -FilePath "winget" -ArgumentList "uninstall --force Google.Chrome"
                $OutputText.AppendText("Google Chrome eemaldatud.`n")
            }
            "Microsoft Edge" {
                Start-Process -FilePath "winget" -ArgumentList "uninstall --force Microsoft.Edge"
                $OutputText.AppendText("Microsoft Edge eemaldatud.`n")
            }
            "Mozilla Firefox" {
                Start-Process -FilePath "winget" -ArgumentList "uninstall --force Mozilla.Firefox"
                $OutputText.AppendText("Firefox eemaldatud.`n")
            }
            "Opera" {
                Start-Process -FilePath "winget" -ArgumentList "uninstall --force Opera.Opera"
                $OutputText.AppendText("Opera eemaldatud.`n")
            }
            "Brave" {
                Start-Process -FilePath "winget" -ArgumentList "uninstall --force Brave.Brave"
                $OutputText.AppendText("Brave eemaldatud.`n")
            }
        }
    }
}

function Change_GUI_Color {
    param ($color)
    $MainWindow.Background = (New-Object System.Windows.Media.SolidColorBrush (New-Object System.Windows.Media.ColorConverter).ConvertFromString($color))
}

# Main window
$MainWindow = New-Object System.Windows.Window
$MainWindow.Title = "PowerShell GUI - Süsteemitoimingud ja rakenduste installimine"
$MainWindow.Width = 600
$MainWindow.Height = 600

# TabControl
$TabControl = New-Object System.Windows.Controls.TabControl

# Tab1
$Tab1 = New-Object System.Windows.Controls.TabItem
$Tab1.Header = "Süsteemitoimingud"
$TabControl.Items.Add($Tab1)

# StackPanel for Tab1
$StackPanel1 = New-Object System.Windows.Controls.StackPanel
$Tab1.Content = $StackPanel1

# Button names and corresponding functions
$ButtonNames = @(
    "Taaskäivita",
    "Sulge",
    "Unerežiim",
    "Puhasta Temp Kaust",
    "Tühjenda Prügikast",
    "Installi Spotify",
    "Installi Discord",
    "Eemalda Microsoft Edge",
    "Helitugevus +",
    "Helitugevus -"
)

# Create and add buttons to StackPanel
foreach ($name in $ButtonNames) {
    $Button = New-Object System.Windows.Controls.Button
    $Button.Content = $name
    $Button.Width = 200
    $Button.Height = 30
    $Button.Margin = [System.Windows.Thickness]::new(5)
    
    switch ($name) {
        "Taaskäivita" { $Button.Add_Click({ Restart_Computer }) }
        "Sulge" { $Button.Add_Click({ Shutdown_Computer }) }
        "Unerežiim" { $Button.Add_Click({ Sleep_Computer }) }
        "Puhasta Temp Kaust" { $Button.Add_Click({ Clean_Temp_Folder }) }
        "Tühjenda Prügikast" { $Button.Add_Click({ Empty_Recycle_Bin }) }
        "Installi Spotify" { $Button.Add_Click({ Install_Spotify }) }
        "Installi Discord" { $Button.Add_Click({ Install_Discord }) }
        "Eemalda Microsoft Edge" { $Button.Add_Click({ Uninstall_MicrosoftEdge }) }
        "Helitugevus +" { $Button.Add_Click({ Set_Volume_Max }) }
        "Helitugevus -" { $Button.Add_Click({ Set_Volume_Min }) }
    }
    
    $StackPanel1.Children.Add($Button)
}

# Create text box for output
$OutputText = New-Object System.Windows.Controls.TextBox
$OutputText.Width = 500
$OutputText.Height = 400
$OutputText.VerticalScrollBarVisibility = "Auto"
$StackPanel1.Children.Add($OutputText)

# Tab2
$Tab2 = New-Object System.Windows.Controls.TabItem
$Tab2.Header = "Brauseri Installer"
$TabControl.Items.Add($Tab2)

# StackPanel for Tab2
$StackPanel2 = New-Object System.Windows.Controls.StackPanel
$Tab2.Content = $StackPanel2

# Checkboxes for Tab2
$CheckBoxNames = @(
    "Google Chrome",
    "Microsoft Edge",
    "Mozilla Firefox",
    "Opera",
    "Brave"
)

foreach ($name in $CheckBoxNames) {
    $CheckBox = New-Object System.Windows.Controls.CheckBox
    $CheckBox.Content = $name
    $CheckBox.Width = 200
    $CheckBox.Height = 30
    $CheckBox.Margin = [System.Windows.Thickness]::new(5)
    $StackPanel2.Children.Add($CheckBox)
}

# Uninstall button
$UninstallButton = New-Object System.Windows.Controls.Button
$UninstallButton.Content = "Eemalda Valitud Brauserid"
$UninstallButton.Width = 200
$UninstallButton.Height = 30
$UninstallButton.Margin = [System.Windows.Thickness]::new(5)
$UninstallButton.Add_Click({ Uninstall_Browser })
$StackPanel2.Children.Add($UninstallButton)

# Install button
$InstallButton = New-Object System.Windows.Controls.Button
$InstallButton.Content = "Installi Valitud Brauserid"
$InstallButton.Width = 200
$InstallButton.Height = 30
$InstallButton.Margin = [System.Windows.Thickness]::new(5)
$InstallButton.Add_Click({ Install_Browser })
$StackPanel2.Children.Add($InstallButton)

# Tab3
$Tab3 = New-Object System.Windows.Controls.TabItem
$Tab3.Header = "Värvivahetaja & Skripti Sisend"
$TabControl.Items.Add($Tab3)

# StackPanel for Tab3
$StackPanel3 = New-Object System.Windows.Controls.StackPanel
$Tab3.Content = $StackPanel3

# Textbox for script input
$ScriptInputLabel = New-Object System.Windows.Controls.Label
$ScriptInputLabel.Content = "Sisesta skript:"
$StackPanel3.Children.Add($ScriptInputLabel)

$ScriptInputTextBox = New-Object System.Windows.Controls.TextBox
$ScriptInputTextBox.Width = 500
$ScriptInputTextBox.Height = 100
$ScriptInputTextBox.Margin = [System.Windows.Thickness]::new(5)
$StackPanel3.Children.Add($ScriptInputTextBox)

# Textbox for CLI output
$CLIOutputLabel = New-Object System.Windows.Controls.Label
$CLIOutputLabel.Content = "CLI väljund:"
$StackPanel3.Children.Add($CLIOutputLabel)

$CLIOutputTextBox = New-Object System.Windows.Controls.TextBox
$CLIOutputTextBox.Width = 500
$CLIOutputTextBox.Height = 300
$CLIOutputTextBox.Margin = [System.Windows.Thickness]::new(5)
$CLIOutputTextBox.VerticalScrollBarVisibility = "Auto"
$StackPanel3.Children.Add($CLIOutputTextBox)

# Combobox for color selection
$ColorComboBox = New-Object System.Windows.Controls.ComboBox
$ColorComboBox.Width = 200
$ColorComboBox.Height = 30
$ColorComboBox.Margin = [System.Windows.Thickness]::new(5)
$ColorComboBox.Items.Add("Red")
$ColorComboBox.Items.Add("Green")
$ColorComboBox.Items.Add("Blue")
$ColorComboBox.Items.Add("Yellow")
$ColorComboBox.Items.Add("Purple")
$StackPanel3.Children.Add($ColorComboBox)

# Apply button for color change
$ApplyColorButton = New-Object System.Windows.Controls.Button
$ApplyColorButton.Content = "Rakenda Värv"
$ApplyColorButton.Width = 200
$ApplyColorButton.Height = 30
$ApplyColorButton.Margin = [System.Windows.Thickness]::new(5)
$ApplyColorButton.Add_Click({
    $selectedColor = $ColorComboBox.SelectedItem
    Change_GUI_Color -color $selectedColor
})
$StackPanel3.Children.Add($ApplyColorButton)

# Add StackPanel to main window
$MainWindow.Content = $TabControl

# Show main window
$MainWindow.ShowDialog() | Out-Null