# BranchMate

BranchMate is a powerful Git operations tool designed to streamline your workflow, especially during code reviews and branch management tasks. This user-friendly PowerShell script provides an intuitive interface for common Git actions, helping developers efficiently navigate and manipulate branches.

## Features

- Reset and clean the current branch
- Switch to the main branch (supports both 'main' and 'master')
- Switch to the latest updated branch
- Create a new branch from an updated main
- User-friendly GUI for easy interaction
- Detailed operation logs

## Prerequisites

- Windows operating system
- PowerShell
- Git installed and configured

## Installation

1. Save the BranchMate script file (e.g., `BranchMate.ps1`) to a convenient location on your local drive.

2. (Optional but recommended) Create a shortcut:
   - Right-click on the script file and select "Create shortcut"
   - Right-click on the newly created shortcut and select "Properties"
   - In the "Shortcut" tab, click on "Advanced..."
   - In the "Shortcut key" field, set a keyboard combination (e.g., Ctrl + Alt + G)

## Usage

1. Run BranchMate by double-clicking the file or using the shortcut you created.
2. The tool will open with a GUI displaying options for different Git operations.
3. The repository path field will be pre-filled with the content of your clipboard. You can modify this if needed.
4. Choose one of the following operations:
   - "Switch to Main": Switches to the main branch (or master if main doesn't exist) and pulls the latest changes.
   - "Switch to Latest": Switches to the most recently updated remote branch and pulls the latest changes.
   - "Create New Branch": Creates a new branch from an updated main branch.
5. After the operation completes, a log window will appear showing the details of the actions performed.

## Tips

- Before running any operation, make sure to copy the path of your Git repository to the clipboard for quick input.
- Always ensure you have committed or stashed your changes before using BranchMate, as it will reset and clean the working directory.

## Troubleshooting

If you encounter any issues:
- Ensure Git is properly installed and configured on your system.
- Check that you have the necessary permissions to access and modify the repository.
- Verify that the repository path is correct and accessible.

For any persistent problems, please check the error messages in the log window for more details.
