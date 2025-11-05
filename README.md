# AutoFreeRDP
Simple script to connect to a defined selection of hosts with specified credentials for a chosen period of time.

Built on Ubuntu 22.04, will likely work with other linux systems which have freerdp2-x11 available, as well as crontab or similar scheduling software

```bash
sudo apt-get update
sudo apt-get install freerdp2-x11
nano ~/Desktop/RDP.sh
```
Paste script contents in.
CTRL+X, Y, ENTER
```bash
crontab -e
```
Choose desired text editor if asked.
Add the following at the bottom of the file:
```bash
*/15 * * * * export DISPLAY:0; /home/$USER/Desktop/RDP.sh
```
Change `*/15` to `*/` and your desired period between connections in minutes
Save and Exit the editor and the script will now be scheduled to run every 15 minutes


Michael Madell 2025
