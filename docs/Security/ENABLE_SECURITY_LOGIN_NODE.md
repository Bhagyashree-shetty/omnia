# Enabling Security on the Login Node 

>> __Note:__ For 389ds/SSSD to work, an external LDAP server has to be set up in your environment as Omnia does not configure LDAP.

## Prerequisites Before Enabling Security:

* Verify that the login node host name has been set. If not, use the following steps to set it.
	* Set hostname of the login node to hostname.domainname format using the below command:
	`hostnamectl set-hostname <hostname>.<domainname>`
	>>Eg: `hostnamectl set-hostname login-node.omnia.test`
	* Add the set hostname in `/etc/hosts` using vi editor.

	`vi /etc/hosts`

    * Add the IP of the login node with the above hostname using `hostnamectl` command in last line of the file.
  
	__Eg:__  xx.xx.xx.xx <hostname>
	
>> __Note:__ 
>>	* The Hostname should not contain the following characters: , (comma), \. (period) or _ (underscore). However, the **domain name** is allowed commas and periods. 
>>	* The Hostname cannot start or end with a hyphen (-).
>>	* No upper case characters are allowed in the hostname.
>>	* The hostname cannot start with a number.

* Set the following parameters in `omnia_security_config.yml`

|  Variables    [Required/ Optional]	                                                   |  **Default**,   Accepted values                       |  Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|--------------------------------------------------------------------------------------|-------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| domain_name                                                                          | **omnia.test**                                        | The domain name should not contain   an underscore ( _ )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| realm_name                                                                           | **OMNIA.TEST**                                        | The realm name should follow the   following rules per   https://www.freeipa.org/page/Deployment_Recommendations   <br> * The realm name must not   conflict with any other existing     Kerberos realm name (e.g. name used by Active Directory). <br> *   The   realm name should be upper-case   (EXAMPLE.COM) version of primary DNS domain name (example.com).                                                                                                                                                                                                                                                                                                                                                |
| max_failures                                                                         | **3**                                                 | Failures allowed before lockout.   <br> This value cannot currently     be changed.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| failure_reset_interval                                                               | **60**                                                | Period (in seconds) after which the   number of failed login attempts is     reset <br> Accepted Values: 30-60                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| lockout_duration                                                                     | **10**                                                | Period (in seconds) for which users are   locked out. <br> Accepted     Values: 5-10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| session_timeout                                                                      | **180**                                               | Period (in seconds) after which idle   users get logged out automatically     <br> Accepted Values: 30-90                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| alert_email_address                                                                  |                                                       | Email address used for sending alerts in   case of authentication failure. Currently, only one email address is   supported in this field.   <br>   If this variable is left blank, authentication failure alerts will   be disabled.                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| user                                                                                 |                                                       | Array of users that are allowed or   denied based on the `allow_deny`     value. Multiple users must be separated by a space. Accepted user value formats are: root root@xx.xx.xx.xx. <br> __Note:__ If IPs are to be specified in the user value, ensure that every IP associated with the host (often 2 or more) in question is listed in the user list. <br> __Eg:__ For a host with IPs xx.xx.xx.xx and yy.yy.yy.yy where root is to be restricted, the user array will contain root@xx.xx.xx.xx root@yy.yy.yy.yy                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| allow_deny                                                                           | **Allow**                                             | This variable sets whether the user list   is Allowed or Denied. <br>     Accepted Values: Allow, Deny                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| restrict_program_support                                                             | **false**                                             | This variable sets whether the network   services/protocols listed in `restrict_softwares` are to be blocked.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| restrict_softwares                                                                   |                                                       | Array of services/protocols to be   blocked by Omnia. Values are to be separated by commas. <br> Accepted   values: telnet,lpd,bluetooth,rlogin,rexec <br> Non Accepted values:   ftp,smbd,nmbd,automount,portmap                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |

* Ensure that `enable_secure_login_node` is set to **true** in `omnia_config.yml`

## Limiting User Authentication over sshd

Users logging into this host can be __optionally__ allowed or denied using an access control list. All users to be allowed or denied are to be listed in the variable `user` in `omnia_security_vars.yml`. 

>> __Note:__ All users on the server will have to be defined manually. Omnia does not create any users by default.

## Session Timeout

To encourage security, users who have been idle over 3 minutes will be logged out automatically. To adjust this value, update the `session_timeout` variable in `omnia_security_vars.yml`. This variable is mandatory. 

## Restricting Program Support

Optionally, different communication protocols can be disabled on the management station using the `restrict_program_support` and `restrict_softwares` variables in `omnia_security_vars.yml. These protocols include: telnet,lpd,bluetooth,rlogin and rexec. Features that cannot be disabled include: ftp,smbd,nmbd,automount and portmap. 

## Logging Program Executions using Snoopy

Omnia installs Snoopy to log all program executions on Linux/BSD systems. For more information on Snoopy, click [here](https://github.com/a2o/snoopy).

## Logging User activity using PSACCT/ACCT

Using PSACCT on Rocky and Acct on LeapOS, admins can monitor activity. For more information, click [here](https://www.redhat.com/sysadmin/linux-system-monitoring-acct).

## Configuring Email Alerts for Authentication Failures

If the `alert_email_address` variable in `omnia_security_config.yml` is populated with a single, valid email ID, all authentication failures will trigger an email notification. A cron job is set up to verify failures and send emails every hour.

>> __Note:__ The `alert_email_address` variable is __optional__. If it is not populated, authentication failure email alerts will be disabled.

## Kernel Lockdown

* RockyOS has Kernel Lockdown mode (Integrity) enabled by default
* SUSE/Leap allows users to set Kernel Lockdown mode to Confidentiality or Integrity.
