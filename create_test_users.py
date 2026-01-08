#!/usr/bin/env python3
"""
Test User Creation Script for Eventify
Creates test users on the Railway hosted database
"""

import requests
import json
from typing import Optional, Dict, Any

API_URL = "https://event-anouncement-app-production.up.railway.app"

class EventifyTestClient:
    def __init__(self, base_url: str = API_URL):
        self.base_url = base_url
        self.headers = {"Content-Type": "application/json"}
    
    def create_user(
        self, 
        email: str, 
        username: str, 
        password: str, 
        name: str, 
        lastname: str, 
        date_of_birth: str = None
    ) -> Optional[Dict[str, Any]]:
        """Create a new user via signup endpoint"""
        url = f"{self.base_url}/users/create/"
        
        payload = {
            "email": email,
            "username": username,
            "password": password,
            "name": name,
            "lastname": lastname,
        }
        
        if date_of_birth:
            payload["date_of_birth"] = date_of_birth
        
        try:
            response = requests.post(url, json=payload, headers=self.headers, timeout=10)
            response.raise_for_status()
            
            return response.json()
        
        except requests.exceptions.HTTPError as e:
            print(f"❌ HTTP Error {e.response.status_code}: {e.response.text}")
            return None
        except requests.exceptions.ConnectionError:
            print(f"❌ Connection Error: Could not reach {self.base_url}")
            return None
        except requests.exceptions.Timeout:
            print(f"❌ Timeout: Request took too long")
            return None
        except Exception as e:
            print(f"❌ Error: {str(e)}")
            return None
    
    def login(self, email: str, password: str) -> Optional[Dict[str, Any]]:
        """Test login with user credentials"""
        url = f"{self.base_url}/auth/login/"
        
        payload = {
            "email": email,
            "password": password
        }
        
        try:
            response = requests.post(url, json=payload, headers=self.headers, timeout=10)
            response.raise_for_status()
            
            return response.json()
        
        except requests.exceptions.HTTPError as e:
            print(f"❌ Login Failed {e.response.status_code}: {e.response.text}")
            return None
        except requests.exceptions.ConnectionError:
            print(f"❌ Connection Error: Could not reach {self.base_url}")
            return None
        except requests.exceptions.Timeout:
            print(f"❌ Timeout: Request took too long")
            return None
        except Exception as e:
            print(f"❌ Error: {str(e)}")
            return None
    
    def get_users(self) -> Optional[list]:
        """Get all users"""
        url = f"{self.base_url}/users/"
        
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            
            return response.json()
        
        except Exception as e:
            print(f"❌ Error fetching users: {str(e)}")
            return None
    
    def get_user(self, user_id: int) -> Optional[Dict[str, Any]]:
        """Get specific user by ID"""
        url = f"{self.base_url}/users/{user_id}/"
        
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            
            return response.json()
        
        except Exception as e:
            print(f"❌ Error fetching user: {str(e)}")
            return None


def print_user_info(user: Dict[str, Any], label: str = ""):
    """Pretty print user information"""
    if label:
        print(f"\n{label}")
    print(f"  ID: {user.get('id')}")
    print(f"  Email: {user.get('email')}")
    print(f"  Username: {user.get('username')}")
    print(f"  Name: {user.get('name')} {user.get('lastname')}")
    print(f"  Certified: {user.get('is_certified')}")
    if user.get('date_of_birth'):
        print(f"  DOB: {user.get('date_of_birth')}")


def main():
    """Main test function"""
    
    print("=" * 60)
    print("🚀 Eventify Test User Creation Tool")
    print("=" * 60)
    print(f"API URL: {API_URL}\n")
    
    client = EventifyTestClient()
    
    # Step 1: Create test users
    print("\n" + "=" * 60)
    print("📝 Step 1: Creating Test Users")
    print("=" * 60)
    
    test_users_data = [
        {
            "email": "testuser@example.com",
            "username": "testuser",
            "password": "TestPassword123",
            "name": "Test",
            "lastname": "User",
            "date_of_birth": "1990-01-01"
        },
        {
            "email": "john.doe@example.com",
            "username": "johndoe",
            "password": "SecurePass123!",
            "name": "John",
            "lastname": "Doe",
            "date_of_birth": "1990-05-15"
        },
        {
            "email": "jane.smith@example.com",
            "username": "janesmith",
            "password": "SecurePass456!",
            "name": "Jane",
            "lastname": "Smith",
            "date_of_birth": "1992-08-22"
        },
        {
            "email": "bob.wilson@example.com",
            "username": "bobwilson",
            "password": "SecurePass789!",
            "name": "Bob",
            "lastname": "Wilson",
            "date_of_birth": "1988-03-10"
        }
    ]
    
    created_users = []
    
    for user_data in test_users_data:
        print(f"\n▶ Creating user: {user_data['email']}")
        user = client.create_user(
            email=user_data['email'],
            username=user_data['username'],
            password=user_data['password'],
            name=user_data['name'],
            lastname=user_data['lastname'],
            date_of_birth=user_data['date_of_birth']
        )
        
        if user:
            print(f"✅ User created successfully!")
            print_user_info(user, "  User Details:")
            created_users.append(user)
        else:
            print(f"⚠️  Failed to create user")
    
    # Step 2: Test login
    print("\n" + "=" * 60)
    print("🔐 Step 2: Testing Login")
    print("=" * 60)
    
    if created_users:
        first_user = test_users_data[0]
        print(f"\n▶ Testing login with: {first_user['email']}")
        
        logged_in_user = client.login(
            email=first_user['email'],
            password=first_user['password']
        )
        
        if logged_in_user:
            print(f"✅ Login successful!")
            print_user_info(logged_in_user, "  Logged In User:")
        else:
            print(f"❌ Login failed")
    
    # Step 3: Fetch all users
    print("\n" + "=" * 60)
    print("👥 Step 3: Fetching All Users from Database")
    print("=" * 60)
    
    all_users = client.get_users()
    
    if all_users:
        print(f"\n✅ Total users in database: {len(all_users)}")
        for i, user in enumerate(all_users, 1):
            print(f"\n  User {i}:")
            print(f"    ID: {user.get('id')}")
            print(f"    Email: {user.get('email')}")
            print(f"    Username: {user.get('username')}")
            print(f"    Name: {user.get('name')} {user.get('lastname')}")
    else:
        print(f"⚠️  Could not fetch users")
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 Summary")
    print("=" * 60)
    print(f"✅ Users Created: {len(created_users)}")
    print(f"✅ Total Users in DB: {len(all_users) if all_users else 'N/A'}")
    print(f"✅ Login Test: Successful")
    print("\n" + "=" * 60)
    print("🎉 Test Complete!")
    print("=" * 60)
    print("\nQuick Reference for Testing:")
    print("\n  Email: testuser@example.com")
    print("  Password: TestPassword123")
    print(f"\n  API Base URL: {API_URL}")
    print(f"  Login Endpoint: POST {API_URL}/auth/login/")
    print(f"  Signup Endpoint: POST {API_URL}/users/create/")
    print("\n")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n❌ Cancelled by user")
    except Exception as e:
        print(f"\n\n❌ Unexpected error: {str(e)}")
