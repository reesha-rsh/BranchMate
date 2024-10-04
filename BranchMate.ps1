# BranchMate.ps1
# Version: 1.0.0
# PowerShell script to automate Git operations
# Author: https://github.com/reesha-rsh


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName Microsoft.VisualBasic

# Function to get the clipboard content
function Get-ClipboardText {
    Add-Type -AssemblyName System.Windows.Forms
    return [System.Windows.Forms.Clipboard]::GetText()
}

# Function to create and show the initial form
function Show-Form {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "BranchMate: Git Operations"
    $form.Size = New-Object System.Drawing.Size(400,250)
    $form.StartPosition = "CenterScreen"

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Repository path:"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10,20)
    $form.Controls.Add($label)

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Size = New-Object System.Drawing.Size(360,20)
    $textbox.Location = New-Object System.Drawing.Point(10,50)
    $textbox.Text = Get-ClipboardText  # Pre-fill with clipboard content
    $form.Controls.Add($textbox)

    $buttonMain = New-Object System.Windows.Forms.Button
    $buttonMain.Text = "Switch to Main"
    $buttonMain.Location = New-Object System.Drawing.Point(10,80)
    $buttonMain.Size = New-Object System.Drawing.Size(120,30)
    $buttonMain.Add_Click({ Process-GitOperations -operation "main" })
    $form.Controls.Add($buttonMain)

    $buttonLatest = New-Object System.Windows.Forms.Button
    $buttonLatest.Text = "Switch to Latest"
    $buttonLatest.Location = New-Object System.Drawing.Point(140,80)
    $buttonLatest.Size = New-Object System.Drawing.Size(120,30)
    $buttonLatest.Add_Click({ Process-GitOperations -operation "latest" })
    $form.Controls.Add($buttonLatest)

    $buttonNew = New-Object System.Windows.Forms.Button
    $buttonNew.Text = "Create New Branch"
    $buttonNew.Location = New-Object System.Drawing.Point(270,80)
    $buttonNew.Size = New-Object System.Drawing.Size(120,30)
    $buttonNew.Add_Click({ Process-GitOperations -operation "new" })
    $form.Controls.Add($buttonNew)

    $form.ShowDialog()
}


# Function to show the output log form
function Show-LogForm {
    param ($logContent)
    $logForm = New-Object System.Windows.Forms.Form
    $logForm.Text = "Operation Log"
    $logForm.Size = New-Object System.Drawing.Size(700,500)  # Increased size for better visibility
    $logForm.StartPosition = "CenterScreen"

    $textbox = New-Object System.Windows.Forms.TextBox
    $textbox.Multiline = $true
    $textbox.ReadOnly = $true
    $textbox.ScrollBars = "Vertical"
    $textbox.Size = New-Object System.Drawing.Size(660,400)  # Adjusted size
    $textbox.Location = New-Object System.Drawing.Point(10,10)
    
    # Add line breaks for readability
    $formattedLogContent = $logContent -replace "(?m)^([A-Z][^:]+:)", "`n`n`$1"
    $textbox.Text = $formattedLogContent.Trim()
    
    $logForm.Controls.Add($textbox)

    $closeButton = New-Object System.Windows.Forms.Button
    $closeButton.Text = "Close"
    $closeButton.Location = New-Object System.Drawing.Point(300,420)  # Adjusted position
    $closeButton.Add_Click({ 
        $logForm.Close()
        [System.Windows.Forms.Application]::Exit()
    })
    $logForm.Controls.Add($closeButton)

    $logForm.ShowDialog()
}

# Function to switch to main branch
function SwitchToMainBranch {
    $output = "Checking if 'main' branch exists:`n"
    if (git show-ref --verify refs/heads/main) {
        $output += "Switching to 'main' branch:`n"
        $output += (git checkout main) + "`n"
    } elseif (git show-ref --verify refs/heads/master) {
        $output += "Switching to 'master' branch:`n"
        $output += (git checkout master) + "`n"
    } else {
        $output += "Error: Neither 'main' nor 'master' branch exists.`n"
    }
    return $output
}

# Function to process Git operations
function Process-GitOperations {
    param ($operation)

    $global:repoPath = $textbox.Text
    if (-not $repoPath) {
        [System.Windows.Forms.MessageBox]::Show("No repository path provided.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    try {
        Set-Location -Path $repoPath
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Invalid repository path provided.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $logContent = "Repository Path: $repoPath`n"
    $logContent += "Resetting uncommitted changes:`n"
    $logContent += (git reset --hard HEAD) + "`n"
    $logContent += "Removing untracked files and directories:`n"
    $logContent += (git clean -fd) + "`n"
    $logContent += "Fetching latest changes:`n"
    $logContent += (git fetch --all) + "`n"

    switch ($operation) {
        "main" {
            $logContent += SwitchToMainBranch
        }
        "latest" {
            $logContent += "Finding the branch with the most recent commit on remote:`n"
            $latestBranch = git for-each-ref --sort=-committerdate refs/remotes --format='%(refname:short)' | Select-Object -First 1
            if ($latestBranch) {
                $localBranch = $latestBranch -replace 'origin/', ''
                $logContent += "Switching to the latest updated branch: $localBranch`n"
                $logContent += (git checkout -B $localBranch $latestBranch) + "`n"
            } else {
                $logContent += "No remote branches found.`n"
            }
        }
        "new" {
            $logContent += SwitchToMainBranch
            $logContent += "Pulling latest changes:`n"
            $logContent += (git pull) + "`n"

            $newBranchName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter new branch name:", "New Branch")
            if ($newBranchName) {
                $newBranchName = $newBranchName -replace '[^\w\-]', ''  # Remove illegal characters
                $logContent += "Creating new branch '$newBranchName' from updated main:`n"
                $logContent += (git checkout -b $newBranchName) + "`n"
            } else {
                $logContent += "New branch creation cancelled.`n"
            }
        }
    }

    if ($operation -ne "new") {
        $logContent += "Pulling latest changes:`n"
        $logContent += (git pull) + "`n"
    }

    Show-LogForm -logContent $logContent
}


# Show the initial form
Show-Form