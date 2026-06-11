# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Environment

This project runs under **XAMPP on Windows**. The web root is `C:\xampp\htdocs\claude\`, served at `http://localhost/claude/`.

- PHP is available via `C:\xampp\php\php.exe`
- MySQL is available via XAMPP's phpMyAdmin at `http://localhost/phpmyadmin/`
- Apache and MySQL services are managed through the XAMPP Control Panel

## Common Commands

Run a PHP file from the terminal:
```powershell
C:\xampp\php\php.exe <file.php>
```

Check PHP syntax:
```powershell
C:\xampp\php\php.exe -l <file.php>
```

Run PHP's built-in linter across all PHP files:
```powershell
Get-ChildItem -Recurse -Filter *.php | ForEach-Object { C:\xampp\php\php.exe -l $_.FullName }
```
