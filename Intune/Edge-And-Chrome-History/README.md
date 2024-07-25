# Retrieving user's browsing history from Edge and Chrome
The scripts in this section were designed to be used in Microsoft Intune as Remediations, 2 options were created and they work in different ways. This solution was have been used in an enviroment where resources are limited so no Web Filtering is in place and there is a need of carry out investigations on what users are browsing sporadically.

By the way, users shall be aware that you are collecting this type of information from the devices.

## Option 1 - Basic data collection
This option detect if the CSV files exist, and if the existing CSV file is older than a specific number of days (script has this set to every 1 day).  If the conditions are met the remediation script will run and collect a basic list of websites the user has visited, it will only display the top domain URL, not the full URL, and emails a copy of the generated CSV file to a defiened email address, to email the files, the script used Outlook (assuming this is email client) to create the email object and send it.

**Note:** This option leaves a trace on user's mailbox, this is because we are using outlook to send the email, I am not deleting the message from Sent Items for transparency and because don't want to mess around deleting messages from user's mailbox.

Scripts to use:

[https://github.com/subseven-oax/itclickpro-public/blob/main/Intune/Edge-And-Chrome-History/Detect_Edge_And_Chrome_Browsing_History-Option1.ps1](url)

[https://github.com/subseven-oax/itclickpro-public/blob/main/Intune/Edge-And-Chrome-History/Remediate_Edge_And_Chrome_Browsing_History-Option1.ps1](url)

## Option 2 - Full DataBase collection
This option creates copies of the "history" files and send them by email using Brevo's SMTP service (this could be substituted with another SMTP service), this option does not leave a trace in users mailbox, history files can be analysed using a SQLite Browser app, I am using this one [https://sqlitebrowser.org/dl/](url), again users shall be aware that you are collecting this type of information from the devices.

**Note:** This option assumes you already have a SMTP service configured and that you have the details to use it, including username and password.

Scripts to use:

[https://github.com/subseven-oax/itclickpro-public/blob/main/Intune/Edge-And-Chrome-History/Detect_Edge_And_Chrome_Browsing_History-Option2.ps1](url)

[https://github.com/subseven-oax/itclickpro-public/blob/main/Intune/Edge-And-Chrome-History/Remediate_Edge_And_Chrome_Browsing_History-Option2.ps1](url)


## Deploying the Remediation with Intune
Start by downloading a copy of the two files to use depending on what option you are going to use, and make the necessary adjustments according to your needs.

Now, in Intune:

1.- While in Intune, go to **Devices > Windows > Scripts and Remediations**.

2.- Click on **Create**, and enter the **Name** and **Description** for this remediation.

3.- Specify the **Detection** and **Remediation** scripts in the relevant box.

4.- Under **Run this script using the logged-on credentials** select **Yes**. And leave the remaining options as No.

5.- Click on **Next**.

6.- Select **Scope tags** if using. And click on **Next**.

7.- **Assing** the remediation to a Group of users or to All users. And any **exclusions** if you need to. And click on **Next**.

8.- **Review** the information provided and if you are happy click on **Create**.

I hope this helps.