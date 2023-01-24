# ROS_setup
A simple setup Bash script that simplifies repetitive commands with ROS when opening a new terminal.

## How to proceed without this script
When using ROS, you must enter the following commands in every new terminal:
Source the ROS setup file (replace <distro> by your distro name)
`source /opt/ros/<distro>/setup.bash`
`export ROS_DOMAIN_ID=<int>`
`export ROS_LOCALHOST_ONLY=<bool>`
Then, verify that ROS environment variables are successfully set with the correct values with the following command :
`env | grep ROS`

## Purpose of this script
Doing this is a **loss of time**. That's why I wrote this simple script that does all this actions.

## Syntax
The script can be launched with both `.` and `source` commands.

### Examples
  `source setup.bash --domain 18 --localhost-only 0`
  `./setup.bash -v -d 18`
  `source setup.bash --help`
