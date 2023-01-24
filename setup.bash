#! /bin/bash

#    ROS setup : executes repetitive command needed when opening a new ROS terminal.
#    Copyright (C) 2023 Amazir CHAOUCHI
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#    Author      : Amazir CHAOUCHI (amazir.chaouchi@gmail.com)
#    Version     : 0.7
#    Licence     : GNU GPLv3
#    Last update : 2023-01-23
#
#    Purpose of this program :
#    This is a simple script intended to reduce the number of ROS setup commands 
#    one has to enter when opening a new terminal.
#

SUCCESS=0
FAILURE=1

domain_id=0
localhost_only=1
verbose=0
valueErr=0

syntaxErrMsg="ERROR : Missing or wrong arguments. The correct syntax is \"source setup.bash [-v|--verbose] -d|--domain <ROS_DOMAIN_ID> -l|--localhost_only <ROS_LOCALHOST_ONLY>\nEnter ./setup.bash --help for more information."
helpFile="./help"

POSITIONAL_ARGS=()

# −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− GET : ARGUMENTS −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
while [[ $# -gt 0 ]]; do
	case $1 in
	-h|--help)
		cat $helpFile
		exit $SUCCESS
		shift,
		;;
	-d|--domain)
		domain_id="$2"
		shift
		shift
		;;
	-l|--localhost-only)
		localhost_only="$2"
		shift # past arg
		shift # past value
		;;
	-v|--verbose)
		verbose=1
		shift
		;;
	-*|--*)
		echo $syntaxErrMsg;
		exit $FAILURE
		;;
	*)
		POSITIONAL_ARGS+=("$1")
		shift
		;;
	esac
done

# −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− TESTS : CORRECT SYNTAX −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
# Testing if the variables are empty

# These lines aren't necessary since -d and -l are not mandatory anymore.
if [[ -z "$domain_id" ]] || [[ -z "$localhost_only" ]]; then
	echo -e $syntaxErrMsg;
	exit $FAILURE

# −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− TESTS : ARGUMENTS VALUES −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
#Testing : 1 <= ROS_DOMAIN_NAME <= 101
if [[ $domain_id -lt 0 ]] || [[ $domain_id -gt 101 ]]; then
	echo "ROS_DOMAIN_ID must be a number between 1 and 101 included."
	valueErr=1
fi
if [[ $localhost_only -lt 0 ]] || [[ $localhost_only -gt 1 ]]; then
	echo "ROS_LOCALHOST_ONLY must be equal to True(0) or False(1)"
	valueErr=1
fi

if [[ $valueErr -eq 1 ]]; then
	exit $FAILURE	
fi

# −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−− MAIN SCRIPT −−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−	
else
	#Sourcing ROS setup file
	if [[ $verbose -eq 1 ]]; then
		echo -ne "Sourcing /opt/ros/humble/setup.bash..."
	fi
	source /opt/ros/humble/setup.bash
	status_code=$?
	if [[ $verbose -eq 1 ]]; then
		if [[ $status_code -ne 0 ]]; then
			echo "exited with error : $status_code"
		else
			echo "OK"
		fi
	fi

	#exporting ROS_DOMAIN_ID
	if [[ $verbose -eq 1 ]]; then
		echo -ne "Exporting ROS_DOMAIN_ID=$domain_id..."
	fi
	export ROS_DOMAIN_ID=$domain_id
	status_code=$?
	if [[ $verbose -eq 1 ]]; then
		if [[ $status_code -ne 0 ]]; then
			echo "exited with error : $status_code"
		else
			echo "OK"
		fi
	fi

	#exporting ROS_LOCALHOST_ONLY
	if [[ $verbose -eq 1 ]]; then
		echo -ne "Exporting ROS_LOCALHOST_ONLY=$localhost_only..."
	fi
	export ROS_LOCALHOST_ONLY=$localhost_only
	if [[ $verbose -eq 1 ]]; then
		if [[ $status_code -ne 0 ]]; then
			echo "exited with error : $status_code"
		else
			echo "OK"
		fi
	fi
	
	#Printing environment variables so the user can check them before using ROS
	echo "−−−−−−−−−−−−−−−− ROS ENVIRONMENT VARIABLES −−−−−−−−−−−−−−−−"
	env | grep ROS
	echo "−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−"
	
	if [[ $verbose -eq 1 ]]; then
		echo -e "Copyright  © Amazir Chaouchi.  License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>. This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.\n"
	fi
fi

