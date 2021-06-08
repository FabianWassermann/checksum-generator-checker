# Load required assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
# EnableVisualStyles
[System.Windows.Forms.Application]::EnableVisualStyles()


Function OpenFile($FILE_FILTER) {
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.Filter = $FILE_FILTER
    try {
        If ($OpenFileDialog.ShowDialog() -eq "OK" -and $comboBox_ChooseVariant.Text -eq "File to Hash") {
            $textbox_OpenFile.Text = $OpenFileDialog.FileName
            $textbox_Generated_Hash.Text = ""
        } Else {$textbox_OpenFile.Text = Get-Content -path $OpenFileDialog.FileName}
    } catch {
        
    }
    
}

Function Get-MD5($CONTENT_TYPE) {
    If ($textbox_OpenFile.Text -ne "") {
        $MD5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

        If ($CONTENT_TYPE -eq "String") {
            $utf8 = New-Object -TypeName System.Text.UTF8Encoding
            $Hash = [System.BitConverter]::ToString($MD5.ComputeHash($utf8.GetBytes($textbox_OpenFile.Text)))
        } Else {
            $Stream = [System.IO.File]::Open($textbox_OpenFile.Text, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
            $Hash = [System.BitConverter]::ToString($MD5.ComputeHash($Stream))
            $Stream.Close()
        }
        
        $textbox_Generated_Hash.Text = $Hash
    }
}

Function Get-SHA1($CONTENT_TYPE) {
    If ($textbox_OpenFile.Text -ne "") {
        $SHA1 = New-Object -TypeName System.Security.Cryptography.SHA1CryptoServiceProvider

        If ($CONTENT_TYPE -eq "String") {
            $utf8 = New-Object -TypeName System.Text.UTF8Encoding
            $Hash = [System.BitConverter]::ToString($SHA1.ComputeHash($utf8.GetBytes($textbox_OpenFile.Text)))
        } Else {
            $Stream = [System.IO.File]::Open($textbox_OpenFile.Text, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
            $Hash = [System.BitConverter]::ToString($SHA1.ComputeHash($Stream))
            $Stream.Close()
        }

        $textbox_Generated_Hash.Text = $Hash
    }
}

Function Get-SHA256($CONTENT_TYPE) {
    If ($textbox_OpenFile.Text -ne "") {
        $SHA256 = New-Object -TypeName System.Security.Cryptography.SHA256CryptoServiceProvider

        If ($CONTENT_TYPE -eq "String") {
            $utf8 = New-Object -TypeName System.Text.UTF8Encoding
            $Hash = [System.BitConverter]::ToString($SHA256.ComputeHash($utf8.GetBytes($textbox_OpenFile.Text)))
        } Else {
            $Stream = [System.IO.File]::Open($textbox_OpenFile.Text, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
            $Hash = [System.BitConverter]::ToString($SHA256.ComputeHash($Stream))
            $Stream.Close()
        }
        
        $textbox_Generated_Hash.Text = $Hash
    }
}

Function Set-ValuesHash {
    If ($comboBox_ChooseHash.Text -ne "") {
        $Form_hasher.Text = $comboBox_ChooseHash.Text + " Hash Checker"
        $textbox_Expected_Hash.Mask = $masks[$comboBox_ChooseHash.Text]
        $button_Generated_Hash.Text = "Generate " + $comboBox_ChooseHash.Text
        $label_GenerateChoose.Text = "Generated " + $comboBox_ChooseHash.Text
        $label_Expected_Hash.Text = "Expected " + $comboBox_ChooseHash.Text
        $textbox_Generated_Hash.Text = ""
        $textbox_Expected_Hash.Text = ""
        Switch ($comboBox_ChooseHash.Text) {
            "SHA1" {$button_Generated_Hash.Add_Click({If ($comboBox_ChooseVariant.Text -eq "File to Hash") {Get-SHA1} Else {Get-SHA1("String")}})}
            "SHA256" {$button_Generated_Hash.Add_Click({If ($comboBox_ChooseVariant.Text -eq "File to Hash") {Get-SHA256} Else {Get-SHA256("String")}})}
            "MD5" {$button_Generated_Hash.Add_Click({If ($comboBox_ChooseVariant.Text -eq "File to Hash") {Get-MD5} Else {Get-MD5("String")}})}
        }
    }
}

Function Set-ValuesVariant {
    If ($comboBox_ChooseVariant.Text -ne "") {
        switch ($comboBox_ChooseVariant.Text) {
            "File to Hash" {
                $textbox_Expected_Hash.Visible = $true
                $label_Expected_Hash.Visible = $true
            }
            "String to Hash" {
                $textbox_Expected_Hash.Visible = $false
                $label_Expected_Hash.Visible = $false
            }
        }
        $textbox_Generated_Hash.Text = ""
        $textbox_Expected_Hash.Text = ""
        $textbox_OpenFile.Text = ""
    }
}

Function Checker {
    If ($textbox_Expected_Hash.Text.Replace(" ", "").toUpper() -eq $textbox_Generated_Hash.Text) {
        $textbox_Expected_Hash.BackColor = "#37B548"
    } Elseif ($textbox_Expected_Hash.Text.Replace(" ", "").Replace("-", "") -eq "") {
        $textbox_Expected_Hash.BackColor = "white"
    } Else {$textbox_Expected_Hash.BackColor = "#BA5B46"}
}


# Drawing GUI
$Form_hasher = New-Object System.Windows.Forms.Form
    $Form_hasher.Text = "SHA1 Hash Checker"
    $Form_hasher.Size = New-Object System.Drawing.Size(576,208)
    $Form_hasher.FormBorderStyle = "FixedDialog"
    $Form_hasher.TopMost = $false
    $Form_hasher.MaximizeBox = $false
    $Form_hasher.MinimizeBox = $true
    $Form_hasher.ControlBox = $true
    $Form_hasher.StartPosition = "CenterScreen"
    $Form_hasher.Font = "Segoe UI"

$labelSize = New-Object System.Drawing.Size(130,20)
$buttonSize = New-Object System.Drawing.Size(110,23)
$textboxSize = New-Object System.Drawing.Size(280,20)

$Y = 8
$Yspacer = 32

$LabelTextAlign = "MiddleCenter"


# Drawing Choose-Variant-ComboBox
$comboBox_ChooseVariant = New-Object System.Windows.Forms.ComboBox
    $comboBox_ChooseVariant.Location = New-Object System.Drawing.Size(20,$Y)
    $comboBox_ChooseVariant.Size = $buttonSize
    $comboBox_ChooseVariant.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $Null = $comboBox_ChooseVariant.Items.Add("File to Hash")
    $Null = $comboBox_ChooseVariant.Items.Add("String to Hash")
    $comboBox_ChooseVariant.SelectedItem = "File to Hash"
    $comboBox_ChooseVariant.Add_SelectedIndexChanged({Set-ValuesVariant})
        $Form_hasher.Controls.Add($comboBox_ChooseVariant)

$textbox_OpenFile = New-Object System.Windows.Forms.TextBox
    $textbox_OpenFile.Location = New-Object System.Drawing.Size(150,$Y)
    $textbox_OpenFile.Size = $textboxSize
        $Form_hasher.Controls.Add($textbox_OpenFile)


$buttonSize = New-Object System.Drawing.Size(96,23)


# Drawing Browse-Button
$button_OpenFile = New-Object System.Windows.Forms.Button
    $button_OpenFile.Location = New-Object System.Drawing.Size(448,$Y)
    $button_OpenFile.FlatStyle = "Standard"
    $button_OpenFile.Size = $buttonSize
    $button_OpenFile.Text = "Browse..."
    $button_OpenFile.Add_Click({ 
            If ($comboBox_ChooseVariant.Text -eq "File to Hash") {
                OpenFile("All files (*.*)|*.*")
            } Else {OpenFile("All files (*.txt)|*.txt")}
        })
        $Form_hasher.Controls.Add($button_OpenFile)


$Y += $Yspacer


# Drawing lable GENERATED-SHA1
$label_GenerateChoose = New-Object System.Windows.Forms.Label
    $label_GenerateChoose.Location = New-Object System.Drawing.Size(8,$Y)
    $label_GenerateChoose.Size = $labelSize
    $label_GenerateChoose.TextAlign = $LabelTextAlign
    $label_GenerateChoose.Text = "Generated SHA1"
        $Form_hasher.Controls.Add($label_GenerateChoose)

$textboxSize = New-Object System.Drawing.Size(395,20)

$textbox_Generated_Hash = New-Object System.Windows.Forms.TextBox
    $textbox_Generated_Hash.Location = New-Object System.Drawing.Size(150,$Y)
    $textbox_Generated_Hash.Size = $textboxSize
    $textbox_Generated_Hash.Add_TextChanged({Checker})
        $Form_hasher.Controls.Add($textbox_Generated_Hash)


$Y += $Yspacer


# Drawing lable EXPECTED-SHA1
$label_Expected_Hash = New-Object System.Windows.Forms.Label
    $label_Expected_Hash.Location = New-Object System.Drawing.Size(8,$Y)
    $label_Expected_Hash.Size = $labelSize
    $label_Expected_Hash.TextAlign = $LabelTextAlign
    $label_Expected_Hash.Text = "Expected SHA1"
        $Form_hasher.Controls.Add($label_Expected_Hash)

$textboxSize = New-Object System.Drawing.Size(395,20)
$masks =@{SHA1="AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA"; 
          SHA256="AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA";
          MD5="AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA-AA"}

$textbox_Expected_Hash = New-Object System.Windows.Forms.MaskedTextBox
    $textbox_Expected_Hash.Location = New-Object System.Drawing.Size(150,$Y)
    $textbox_Expected_Hash.Size = $textboxSize
    $textbox_Expected_Hash.Mask = $masks["SHA1"]
    $textbox_Expected_Hash.Add_TextChanged({Checker})
        $Form_hasher.Controls.Add($textbox_Expected_Hash)

$Y += $Yspacer*2

$buttonSize = New-Object System.Drawing.Size(110,23)

# Drawing Generate-Button
$button_Generated_Hash = New-Object System.Windows.Forms.Button
    $button_Generated_Hash.Location = New-Object System.Drawing.Size(434,$Y)
    $button_Generated_Hash.Size = $buttonSize
    $button_Generated_Hash.Text = "Generate SHA1"
    $button_Generated_Hash.Add_Click({If ($comboBox_ChooseVariant.Text -eq "File to Hash") {Get-SHA1} Else {Get-SHA1("String")}})
        $Form_hasher.Controls.Add($button_Generated_Hash)
        
# Drawing Choose-Hash-ComboBox
$comboBox_ChooseHash = New-Object System.Windows.Forms.ComboBox
    $comboBox_ChooseHash.Location = New-Object System.Drawing.Size(20,$Y)
    $comboBox_ChooseHash.Size = $buttonSize
    $comboBox_ChooseHash.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $Null = $comboBox_ChooseHash.Items.Add("SHA1")
    $Null = $comboBox_ChooseHash.Items.Add("SHA256")
    $Null = $comboBox_ChooseHash.Items.Add("MD5")
    $comboBox_ChooseHash.SelectedItem = "SHA1"
    $comboBox_ChooseHash.Add_SelectedIndexChanged({Set-ValuesHash})
        $Form_hasher.Controls.Add($comboBox_ChooseHash)
        

# show form
$Form_hasher.Add_Shown({$Form_hasher.Activate()})
[void] $Form_hasher.ShowDialog()