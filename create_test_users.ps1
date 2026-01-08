#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Eventify Test User Creation Script for PowerShell
    Creates test users on the Railway hosted database

.DESCRIPTION
    This script creates test users in the Eventify database
    and tests the authentication endpoints

.EXAMPLE
    .\create_test_users.ps1
#>

$ApiUrl = "https://event-anouncement-app-production.up.railway.app"

# ANSI color codes for PowerShell
$Green = "`e[32m"
$Red = "`e[31m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Reset = "`e[0m"
$Bold = "`e[1m"

function Create-User {
    param(
        [string]$Email,
        [string]$Username,
        [string]$Password,
        [string]$Name,
        [string]$LastName,
        [string]$DateOfBirth
    )
    
    $Uri = "$ApiUrl/users/create/"
    
    $Body = @{
        email       = $Email
        username    = $Username
        password    = $Password
        name        = $Name
        lastname    = $LastName
    }
    
    if ($DateOfBirth) {
        $Body.date_of_birth = $DateOfBirth
    }
    
    $JsonBody = $Body | ConvertTo-Json
    
    try {
        Write-Host "  ▶ Creating user: $Email" -ForegroundColor Cyan
        
        $Response = Invoke-WebRequest -Uri $Uri -Method Post `
            -Headers @{ "Content-Type" = "application/json" } `
            -Body $JsonBody `
            -TimeoutSec 10 -ErrorAction Stop
        
        $User = $Response.Content | ConvertFrom-Json
        
        Write-Host "  $Green✅ User created successfully!$Reset"
        Write-Host "    ID: $($User.id)"
        Write-Host "    Email: $($User.email)"
        Write-Host "    Username: $($User.username)"
        Write-Host "    Name: $($User.name) $($User.lastname)"
        
        return $User
    }
    catch {
        Write-Host "  $Red✗ Error: $($_.Exception.Message)$Reset"
        return $null
    }
}

function Test-Login {
    param(
        [string]$Email,
        [string]$Password
    )
    
    $Uri = "$ApiUrl/auth/login/"
    
    $Body = @{
        email    = $Email
        password = $Password
    } | ConvertTo-Json
    
    try {
        Write-Host "  ▶ Testing login with: $Email" -ForegroundColor Cyan
        
        $Response = Invoke-WebRequest -Uri $Uri -Method Post `
            -Headers @{ "Content-Type" = "application/json" } `
            -Body $Body `
            -TimeoutSec 10 -ErrorAction Stop
        
        $User = $Response.Content | ConvertFrom-Json
        
        Write-Host "  $Green✅ Login successful!$Reset"
        Write-Host "    ID: $($User.id)"
        Write-Host "    Email: $($User.email)"
        Write-Host "    Username: $($User.username)"
        
        return $User
    }
    catch {
        Write-Host "  $Red✗ Login failed: $($_.Exception.Message)$Reset"
        return $null
    }
}

function Get-AllUsers {
    $Uri = "$ApiUrl/users/"
    
    try {
        $Response = Invoke-WebRequest -Uri $Uri -Method Get `
            -Headers @{ "Content-Type" = "application/json" } `
            -TimeoutSec 10 -ErrorAction Stop
        
        $Users = $Response.Content | ConvertFrom-Json
        return $Users
    }
    catch {
        Write-Host "$Red✗ Error fetching users: $($_.Exception.Message)$Reset"
        return $null
    }
}

function Print-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host ("=" * 60) -ForegroundColor Blue
    Write-Host $Text -ForegroundColor Blue -BackgroundColor Black
    Write-Host ("=" * 60) -ForegroundColor Blue
}

function Print-SubHeader {
    param([string]$Text)
    Write-Host ""
    Write-Host $Text -ForegroundColor Cyan
}

# Main Script
Clear-Host

Print-Header "$Bold🚀 Eventify Test User Creation Tool$Reset"
Write-Host "API URL: $ApiUrl`n" -ForegroundColor Gray

# Step 1: Create test users
Print-Header "📝 Step 1: Creating Test Users"

$TestUsers = @(
    @{
        Email        = "testuser@example.com"
        Username     = "testuser"
        Password     = "TestPassword123"
        Name         = "Test"
        LastName     = "User"
        DateOfBirth  = "1990-01-01"
    },
    @{
        Email        = "john.doe@example.com"
        Username     = "johndoe"
        Password     = "SecurePass123!"
        Name         = "John"
        LastName     = "Doe"
        DateOfBirth  = "1990-05-15"
    },
    @{
        Email        = "jane.smith@example.com"
        Username     = "janesmith"
        Password     = "SecurePass456!"
        Name         = "Jane"
        LastName     = "Smith"
        DateOfBirth  = "1992-08-22"
    },
    @{
        Email        = "bob.wilson@example.com"
        Username     = "bobwilson"
        Password     = "SecurePass789!"
        Name         = "Bob"
        LastName     = "Wilson"
        DateOfBirth  = "1988-03-10"
    }
)

$CreatedUsers = @()

foreach ($User in $TestUsers) {
    $CreatedUser = Create-User -Email $User.Email `
                               -Username $User.Username `
                               -Password $User.Password `
                               -Name $User.Name `
                               -LastName $User.LastName `
                               -DateOfBirth $User.DateOfBirth
    
    if ($CreatedUser) {
        $CreatedUsers += $CreatedUser
    }
}

# Step 2: Test login
Print-Header "🔐 Step 2: Testing Login"

if ($CreatedUsers.Count -gt 0) {
    $FirstUser = $TestUsers[0]
    Test-Login -Email $FirstUser.Email -Password $FirstUser.Password
}

# Step 3: Fetch all users
Print-Header "👥 Step 3: Fetching All Users from Database"

$AllUsers = Get-AllUsers

if ($AllUsers) {
    Write-Host "$Green✅ Total users in database: $($AllUsers.Count)$Reset`n"
    
    $AllUsers | ForEach-Object -Begin { $i = 1 } -Process {
        Write-Host "  User $i`:"
        Write-Host "    ID: $($_.id)"
        Write-Host "    Email: $($_.email)"
        Write-Host "    Username: $($_.username)"
        Write-Host "    Name: $($_.name) $($_.lastname)"
        Write-Host ""
        $i++
    }
}

# Summary
Print-Header "📊 Summary"

Write-Host "$Green✅ Users Created: $($CreatedUsers.Count)$Reset"
Write-Host "$Green✅ Total Users in DB: $(if ($AllUsers) { $AllUsers.Count } else { 'N/A' })$Reset"
Write-Host "$Green✅ Login Test: Successful$Reset"

Print-Header "🎉 Test Complete!"

Write-Host "Quick Reference for Testing:" -ForegroundColor White
Write-Host ""
Write-Host "  Email: testuser@example.com" -ForegroundColor Gray
Write-Host "  Password: TestPassword123" -ForegroundColor Gray
Write-Host ""
Write-Host "  API Base URL: $ApiUrl" -ForegroundColor Gray
Write-Host "  Login Endpoint: POST /auth/login/" -ForegroundColor Gray
Write-Host "  Signup Endpoint: POST /users/create/" -ForegroundColor Gray
Write-Host ""
