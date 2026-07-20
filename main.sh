#!/bin/bash

while true
do
    clear

    echo "========================================="
    echo "     Linux User Management Toolkit"
    echo "========================================="
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

	1)
            echo
            read -p "Enter username: " username

            if [[ -z "$username" ]]
            then
                echo
                echo "Username cannot be empty."

            elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
            then
                echo
                echo "Invalid username."

            elif id "$username" &>/dev/null
            then
                echo
                echo "User '$username' already exists."

            else
                sudo useradd "$username"

                if [ $? -eq 0 ]
                then
                    echo
                    echo "User '$username' created successfully."

                    echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' created successfully." >> logs/activity.log

                    echo
                    echo "Set password for $username"

                    sudo passwd "$username"
                else
                    echo
                    echo "Failed to create user."
                fi
            fi
            ;;

        2)
   	    echo
            read -p "Enter username to delete: " username

            if [[ -z "$username" ]]
            then
                echo
                echo "Username cannot be empty."

            elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
            then
                echo
                echo "Invalid username."

            elif id "$username" &>/dev/null
            then
                sudo userdel "$username"

                if [ $? -eq 0 ]
                then
                    echo
                    echo "User '$username' deleted successfully."
                    echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' deleted successfully." >> Logs/activity.log
                else
                    echo
                    echo "Failed to delete user."
                fi

            else
                echo
                echo "User '$username' does not exist."
            fi
            ;; 
        3)
            echo
            echo "========================================="
            echo "          Registered Users"
            echo "========================================="
            printf "%-20s %-10s\n" "Username" "UID"
            echo "-----------------------------------------"

            awk -F: '$3 >= 1000 {printf "%-20s %-10s\n", $1, $3}' /etc/passwd

            echo "========================================="
            ;;

        4)
            echo
            read -p "Enter username: " username

            if [[ -z "$username" ]]
            then
                echo
                echo "Username cannot be empty."

            elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
            then
                echo
                echo "Invalid username."

            elif id "$username" &>/dev/null
            then
                echo
                echo "Resetting password for '$username'..."
                echo

                sudo passwd "$username"

                if [ $? -eq 0 ]
                then
                    echo
                    echo "Password updated successfully."
                    echo "[$(date "+%Y-%m-%d %H:%M:%S")] Password reset for '$username'." >> Logs/activity.log
                else
                    echo
                    echo "Failed to update password."
                fi

            else
                echo
                echo "User '$username' does not exist."
            fi
            ;;
 
        5)
            echo
            read -p "Enter username to lock: " username

            if [[ -z "$username" ]]
            then
                echo
                echo "Username cannot be empty."

            elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
            then
                echo
                echo "Invalid username."

            elif id "$username" &>/dev/null
            then
                sudo passwd -l "$username"

                if [ $? -eq 0 ]
                then
                    echo
                    echo "User '$username' has been locked successfully."
                    echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' locked." >> Logs/activity.log
                else
                    echo
                    echo "Failed to lock user."
                fi

            else
                echo
                echo "User '$username' does not exist."
            fi
            ;;

        6)
            echo
            read -p "Enter username to unlock: " username

            if [[ -z "$username" ]]
            then
                echo
                echo "Username cannot be empty."

            elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
            then
                echo
                echo "Invalid username."

            elif id "$username" &>/dev/null
            then
                sudo passwd -u "$username"

                if [ $? -eq 0 ]
                then
                    echo
                    echo "User '$username' has been unlocked successfully."
                    echo "[$(date "+%Y-%m-%d %H:%M:%S")] User '$username' unlocked." >> Logs/activity.log
                else
                    echo
                    echo "Failed to unlock user."
                fi

            else
                echo
                echo "User '$username' does not exist."
            fi
            ;;

        7)
            echo
            echo "========================================="
            echo "         User Information"
            echo "========================================="

            read -p "Enter username: " username

            if [[ -z "$username" ]]
            then
                echo
                echo "Username cannot be empty."

            elif [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]
            then
                echo
                echo "Invalid username."

            elif id "$username" &>/dev/null
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
                echo "User '$username' does not exist."
            fi

            echo "========================================="
            ;;

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
