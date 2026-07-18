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

            if id "$username" &>/dev/null
            then
               echo
               echo "User '$username' already exists."
            else
               sudo useradd "$username"

               if [ $? -eq 0 ]
               then
                  echo
                  echo "User '$username' created successfully."

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

            if id "$username" &>/dev/null
            then
               sudo userdel "$username"

               if [ $? -eq 0 ]
               then
                  echo
                  echo "User '$username' deleted successfully."
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
            echo "Reset Password selected."
            ;;

        5)
            echo "Lock User selected."
            ;;

        6)
            echo "Unlock User selected."
            ;;

        7)
            echo "User Information selected."
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
