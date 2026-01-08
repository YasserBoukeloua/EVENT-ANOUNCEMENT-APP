#!/usr/bin/env pwsh

$ApiUrl = "https://event-anouncement-app-production.up.railway.app"

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
        Write-Host "  > Creating user: $Email" -ForegroundColor Cyan
        
        $Response = Invoke-WebRequest -Uri $Uri -Method Post `
            -Headers @{ "Content-Type" = "application/json" } `
            -Body $JsonBody `
            -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        
        $User = $Response.Content | ConvertFrom-Json
        
        Write-Host "  [OK] User created! ID: $($User.id)" -ForegroundColor Green
        return $User
    }
    catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
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
        Write-Host "  > Testing login: $Email" -ForegroundColor Cyan
        
        $Response = Invoke-WebRequest -Uri $Uri -Method Post `
            -Headers @{ "Content-Type" = "application/json" } `
            -Body $Body `
            -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        
        $User = $Response.Content | ConvertFrom-Json
        
        Write-Host "  [OK] Login successful! ID: $($User.id)" -ForegroundColor Green
        return $User
    }
    catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Get-AllUsers {
    $Uri = "$ApiUrl/users/"
    
    try {
        $Response = Invoke-WebRequest -Uri $Uri -Method Get `
            -Headers @{ "Content-Type" = "application/json" } `
            -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        
        $Users = $Response.Content | ConvertFrom-Json
        return $Users
    }
    catch {
        Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Main Script
Clear-Host

Write-Host "=======================================================" -ForegroundColor Blue
Write-Host "   Eventify Test User Creation Tool" -ForegroundColor Blue
Write-Host "=======================================================" -ForegroundColor Blue
Write-Host "API: $ApiUrl" -ForegroundColor Gray
Write-Host ""

Write-Host "Step 1: Creating Test Users" -ForegroundColor Yellow
Write-Host "-------------------------------------------------------" -ForegroundColor Gray

$TestUsers = @(
    @{ Email = "testuser@example.com"; Username = "testuser"; Password = "TestPassword123"; Name = "Test"; LastName = "User"; DOB = "1990-01-01" },
    @{ Email = "john.doe@example.com"; Username = "johndoe"; Password = "SecurePass123!"; Name = "John"; LastName = "Doe"; DOB = "1990-05-15" },
    @{ Email = "jane.smith@example.com"; Username = "janesmith"; Password = "SecurePass456!"; Name = "Jane"; LastName = "Smith"; DOB = "1992-08-22" },
    @{ Email = "bob.wilson@example.com"; Username = "bobwilson"; Password = "SecurePass789!"; Name = "Bob"; LastName = "Wilson"; DOB = "1988-03-10" }
)

$CreatedUsers = @()

foreach ($User in $TestUsers) {
    $CreatedUser = Create-User -Email $User.Email `
                               -Username $User.Username `
                               -Password $User.Password `
                               -Name $User.Name `
                               -LastName $User.LastName `
                               -DateOfBirth $User.DOB
    
    if ($CreatedUser) {
        $CreatedUsers += $CreatedUser
    }
}

Write-Host ""
Write-Host "Step 2: Testing Login" -ForegroundColor Yellow
Write-Host "-------------------------------------------------------" -ForegroundColor Gray

if ($CreatedUsers.Count -gt 0) {
    $FirstUser = $TestUsers[0]
    Test-Login -Email $FirstUser.Email -Password $FirstUser.Password
}

Write-Host ""
Write-Host "Step 3: Fetching Database" -ForegroundColor Yellow
Write-Host "-------------------------------------------------------" -ForegroundColor Gray

$AllUsers = Get-AllUsers

if ($AllUsers) {
    Write-Host "Total users in database: $($AllUsers.Count)" -ForegroundColor Green
    Write-Host ""
    $AllUsers | ForEach-Object -Begin { $i = 1 } -Process {
        Write-Host "  $i. $($_.email) (ID: $($_.id))" -ForegroundColor Gray
        $i++
    }
}

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Blue
Write-Host "   Test Complete!" -ForegroundColor Green
Write-Host "=======================================================" -ForegroundColor Blue
Write-Host ""
Write-Host "Quick Reference:" -ForegroundColor White
Write-Host "  Email: testuser@example.com" -ForegroundColor Gray
Write-Host "  Password: TestPassword123" -ForegroundColor Gray
Write-Host ""
Write-Host "Users Created: $($CreatedUsers.Count)" -ForegroundColor Green
Write-Host "Total in DB: $(if ($AllUsers) { $AllUsers.Count } else { 'N/A' })" -ForegroundColor Green
Write-Host ""
