#!/bin/bash

# Colors

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

validate_username()
{
    if [[ -z "$username" ]]
    then
        echo
        echo -e "${RED}Username cannot be empty.${NC}"
        return 1

    elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
    then
        echo
        echo -e "${RED}Invalid username.${NC}"
        return 1
    fi

    return 0
}

create_user()
{
    echo
    read -p "Enter username: " username

    validate_username || return

    if id "$username" &>/dev/null
    then
        echo
        echo -e "${RED}User '$username' already exists.${NC}"

    else
        sudo useradd "$username"

        if [ $? -eq 0 ]
        then
            echo
            echo -e "${GREEN}User '$username' created successfully.${NC}"

            echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' created successfully." >> Logs/activity.log

            echo
            echo -e "${YELLOW}Set password for $username${NC}"

            sudo passwd "$username"
        else
            echo
            echo -e "${RED}Failed to create user.${NC}"
        fi
    fi
}

delete_user()
{
    echo
    read -p "Enter username to delete: " username

    validate_username || return

    if id "$username" &>/dev/null
    then
        sudo userdel "$username"

        if [ $? -eq 0 ]
        then
            echo
            echo -e "${GREEN}User '$username' deleted successfully.${NC}"
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' deleted successfully." >> Logs/activity.log
        else
            echo
            echo -e "${RED}Failed to delete user.${NC}"
        fi

    else
        echo
        echo -e "${RED}User '$username' does not exist.${NC}"
    fi
}

list_users()
{
    echo
    echo "========================================="
    echo "          Registered Users"
    echo "========================================="
    printf "%-20s %-10s\n" "Username" "UID"
    echo "-----------------------------------------"

    awk -F: '$3 >= 1000 {printf "%-20s %-10s\n", $1, $3}' /etc/passwd

    echo "========================================="
}

reset_password()
{
    echo
    read -p "Enter username: " username

    validate_username || return

    if id "$username" &>/dev/null
    then
        echo
        sudo passwd "$username"

        if [ $? -eq 0 ]
        then
            echo
            echo -e "${GREEN}Password reset successfully for '$username'.${NC}"
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] Password reset for '$username'." >> Logs/activity.log
        else
            echo
            echo -e "${RED}Failed to reset password.${NC}"
        fi

    else
        echo
        echo -e "${RED}User '$username' does not exist.${NC}"
    fi
}

lock_user()
{
    echo
    read -p "Enter username to lock: " username

    validate_username || return

    if id "$username" &>/dev/null
    then
        sudo passwd -l "$username"

        if [ $? -eq 0 ]
        then
            echo
            echo -e "${GREEN}User '$username' has been locked successfully.${NC}"
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' locked." >> Logs/activity.log
        else
            echo
            echo -e "${RED}Failed to lock user.${NC}"
        fi

    else
        echo
        echo -e "${RED}User '$username' does not exist.${NC}"
    fi
}

unlock_user()
{
    echo
    read -p "Enter username to unlock: " username

    validate_username || return

    if id "$username" &>/dev/null
    then
        sudo passwd -u "$username"

        if [ $? -eq 0 ]
        then
            echo
            echo -e "${GREEN}User '$username' has been unlocked successfully.${NC}"
            echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' unlocked." >> Logs/activity.log
        else
            echo
            echo -e "${RED}Failed to unlock user.${NC}"
        fi

    else
        echo
        echo -e "${RED}User '$username' does not exist.${NC}"
    fi
}

user_information()
{
    echo
    echo "========================================="
    echo "         User Information"
    echo "========================================="

    read -p "Enter username: " username

    validate_username || return

    if id "$username" &>/dev/null
    then
        user_info=$(getent passwd "$username")

        echo
        echo "Username       : $(echo "$user_info" | cut -d: -f1)"
        echo "UID            : $(echo "$user_info" | cut -d: -f3)"
        echo "GID            : $(echo "$user_info" | cut -d: -f4)"
        echo "Home Directory : $(echo "$user_info" | cut -d: -f6)"
        echo "Shell          : $(echo "$user_info" | cut -d: -f7)"

    else
        echo
        echo -e "${RED}User '$username' does not exist.${NC}"
    fi

    echo "========================================="
}

while true
do
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BLUE}     Linux User Management Toolkit${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo
    echo "1. Create User"
    echo "2. Delete User"
    echo "3. List Users"
    echo "4. Reset Password"
    echo "5. Lock User"
    echo "6. Unlock User"
    echo "7. User Information"
    echo "8. Exit"
    echo
    echo "========================================="

    read -p "Enter your choice: " choice

    case $choice in

	1) create_user ;;

        2) delete_user ;;

   	3) list_users ;;

	4) reset_password ;;
	 
	5) lock_user ;;

	6) unlock_user ;;

	7) user_information ;;
           
        8)
            echo "Thank you for using Linux User Management Toolkit!"
            exit
            ;;

        *)
            echo "Invalid option. Please try again."
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
done
