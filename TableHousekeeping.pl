#!/usr/bin/perl

###################### TableHousekeeping.pl ######################
#work        : Databases housekeeping
#user        : root
#location    : /home/TableHousekeeping/
#trigger     : cronjob
#schedule    : 0 1 * * * (01:00/day)
##################################################################
# Version 1.0 : 2023-07-10 House (house@acom-networks.com)
#               - init.
# Version 2.0 : 2023-07-11 House (house@acom-networks.com)
#               - added drop tables by time  function
# Version 2.1 : 2023-07-12 House (house@acom-networks.com)
#               - enhancing the performance of MySQL

use strict;
use warnings;
use Time::HiRes qw( usleep ualarm gettimeofday tv_interval nanosleep clock_gettime clock_getres clock_nanosleep clock stat );
use DBI;
use POSIX qw/strftime/;

##### START: Define some global variables
my $version = '2.0';
my $program_name = 'TableHousekeeping';
#my $configfile = '/home/TableHousekeeping/TableHousekeeping.ini';
my $configfile = '/home/house/project/TableHousekeeping/TableHousekeeping.ini';
my %cfg;

##### START: Bring in Configuration Parameters from INI file
if (-e $configfile) {
    %cfg = ();
    %cfg = &fill_ini($configfile);
} else {
    print "Error: Config file $configfile not found on system\n";
    print "Usage: $program_name\n";
    print "Copyright(C) 2023 Acom Networks\n";
    print "Version: $version\n";
    print "\n";
    exit();
}


####### System configuration #######
my $pidno = $$;
my $log_dir = $cfg{'system'}->{'log_dir'};
my $debug = $cfg{'system'}->{'debug'};
my $EnableMENU = $cfg{'system'}->{'EnableMENU'};
logger("START:Starting:$program_name:VERSION:$version:PID:$pidno");
logger("DEBUG:debug:$debug(off=0, on=1):log_dir:$log_dir:EnableMENU:$EnableMENU");


####### mysql configuration #######
my $db_host = $cfg{'mysql'}->{'db_host'};
my $db_user = $cfg{'mysql'}->{'db_user'};
my $db_pass = $cfg{'mysql'}->{'db_pass'};
my $db_name = $cfg{'mysql'}->{'db_name'};
logger("DEBUG:db_host:$db_host:db_user:$db_user:db_pass:$db_pass:db_name:$db_name");





#### Databases housekeeping
if($EnableMENU =~ /NMOSS4VoWiFi_3G/)
{
    ####### EnableMENU configuration #######
    my $NMOSS3G_tablename = $cfg{'NMOSS4VoWiFi_3G'}->{'TableName'};
    my $NMOSS3G_keep_type = $cfg{'NMOSS4VoWiFi_3G'}->{'Keep_Type'};
    my $NMOSS3G_keep_value = $cfg{'NMOSS4VoWiFi_3G'}->{'Keep_Value'};
    $NMOSS3G_keep_value = &keep_value_check($NMOSS3G_tablename,$NMOSS3G_keep_value);

    my $db_backup;
    # print('NMOSS4VoWiFi_3G'.'\n');
    if($NMOSS3G_keep_type =~ /DAY/)
    {
        $db_backup = $NMOSS3G_keep_value * 3600 * 24;

        my $Clean_backup_tablename = $NMOSS3G_tablename . strftime('%Y%m%d', localtime(time()-$db_backup));
        logger("INFO:START DROP TABLES BY DAY (Keeping Day: $NMOSS3G_keep_value)");

        &drop_table_byday($NMOSS3G_tablename,$Clean_backup_tablename,$db_name,$db_host,$db_user,$db_pass);
    }
    if($NMOSS3G_keep_type =~ /COUNT/)
    {
        my $Clean_backup_tablename = $NMOSS3G_tablename;
        logger("INFO:START DROP TABLES BY COUNT (Keeping Count: $NMOSS3G_keep_value)");

        &drop_table_bycount($Clean_backup_tablename,$db_name,$db_host,$db_user,$db_pass,$NMOSS3G_keep_value);
    }
    
    

}
if($EnableMENU =~ /NMOSS4VoWiFi_4G/)
{
    ####### EnableMENU configuration #######
    my $NMOSS4G_tablename = $cfg{'NMOSS4VoWiFi_4G'}->{'TableName'};
    my $NMOSS4G_keep_type = $cfg{'NMOSS4VoWiFi_4G'}->{'Keep_Type'};
    my $NMOSS4G_keep_value = $cfg{'NMOSS4VoWiFi_4G'}->{'Keep_Value'};
    $NMOSS4G_keep_value = &keep_value_check($NMOSS4G_tablename,$NMOSS4G_keep_value);
    
    my $db_backup;

    if($NMOSS4G_keep_type =~ /DAY/)
    {
        $db_backup = $NMOSS4G_keep_value * 3600 * 24;

        my $Clean_backup_tablename = $NMOSS4G_tablename . strftime('%Y%m%d', localtime(time()-$db_backup));
        logger("INFO:START DROP TABLES BY DAY (Keeping Day: $NMOSS4G_keep_value)");

        &drop_table_byday($NMOSS4G_tablename,$Clean_backup_tablename,$db_name,$db_host,$db_user,$db_pass);
    }
    if($NMOSS4G_keep_type =~ /COUNT/)
    {
        my $Clean_backup_tablename = $NMOSS4G_tablename;
        logger("INFO:START DROP TABLES BY COUNT (Keeping Count: $NMOSS4G_keep_value)");

        &drop_table_bycount($Clean_backup_tablename,$db_name,$db_host,$db_user,$db_pass,$NMOSS4G_keep_value);
    }
    
    
    
}
if($EnableMENU =~ /HinetIPTable/)
{
    ####### EnableMENU configuration #######
    my $HinetIPTable_tablename = $cfg{'HinetIPTable'}->{'TableName'};
    my $HinetIPTable_keep_type = $cfg{'HinetIPTable'}->{'Keep_Type'};
    my $HinetIPTable_keep_value = $cfg{'HinetIPTable'}->{'Keep_Value'};
    $HinetIPTable_keep_value = &keep_value_check($HinetIPTable_tablename,$HinetIPTable_keep_value);

    my $db_backup;

    if($HinetIPTable_keep_type =~ /DAY/)
    {

        $db_backup = $HinetIPTable_keep_value * 3600 * 24;

        my $Clean_backup_tablename = $HinetIPTable_tablename . strftime('%Y%m%d', localtime(time()-$db_backup));
        logger("INFO:START DROP TABLES BY DAY (Keeping Day: $HinetIPTable_keep_value)");

        &drop_table_byday($HinetIPTable_tablename,$Clean_backup_tablename,$db_name,$db_host,$db_user,$db_pass);
    }
    if($HinetIPTable_keep_type =~ /COUNT/)
    {
        my $Clean_backup_tablename = $HinetIPTable_tablename;
        logger("INFO:START DROP TABLES BY COUNT (Keeping Count: $HinetIPTable_keep_value)");

        &drop_table_bycount($Clean_backup_tablename,$db_name,$db_host,$db_user,$db_pass,$HinetIPTable_keep_value);
    }

    
}
#######
# $db_connection->disconnect;
exit();
#######

sub keep_value_check
{
    my ($t_name,$k_value) = @_;
    my $keep_value_default = 1;

    chomp($k_value);
    if( $k_value =~ /^\d+$/ )
    { 
        if($k_value == 0)
        {
            &logger("WARNING:Keep Value of $t_name is not positive integer (Automatically converting to default values $keep_value_default)");
            return $keep_value_default;   
        }
        else
        {
            # &logger("DEBUG:Cardinal Number(k_value = $k_value)");
            return $k_value;
        }
    }
    else
    { 
        &logger("WARNING:Keep Value of $t_name is not positive integer (Automatically converting to default values $keep_value_default)");
        return $keep_value_default;
    }
}

# sub drop_table
# {
#     my($tablename,$name,$host,$user,$pass) = @_;
#     my $query = "DROP TABLE IF EXISTS `$tablename`;";

#     ## connect to database
#     logger("INFO:START:Connect to database");
#     my $db_connection = DBI->connect("DBI:mysql:database=$name;host=$host",$user,$pass);
#     if ($db_connection)
#     {
#         logger("INFO:Connect:Database Connection Successful");
#         $db_connection->{mysql_auto_reconnect} = 1;
#         $db_connection->do( "set names utf8" );

#         for(my $i=0; $i <= 24; $i++)
#         {
#             $query="DROP TABLE IF EXISTS `$tablename".sprintf("%02d",$i)."`";
#             my $db_result = $db_connection->prepare($query);            
#             $db_result->execute or logger("ERROR:DROP TABLE $tablename :$DBI::errstr");

#             # logger("INFO:Housekeeping DB TABLE:query=$query");
#         }   
#         $db_connection->disconnect;
#     }
#     else
#     {
#         logger("INFO:Connect:Database Connection ERROR");
#     }
# }


# sub drop_table_list
# {
#     my($tablename,$name,$host,$user,$pass) = @_;
#     my $query = "select table_name, create_time from information_schema.TABLES where table_name like '$tablename%';";
#     # print("$query");
    
#     my $db_connection = DBI->connect("DBI:mysql:database=$name;host=$host",$user,$pass);

#     if ($db_connection)
#     {
#         $db_connection->{mysql_auto_reconnect} = 1;
#         $db_connection->do( "set names utf8" );

#         my $db_result = $db_connection->prepare($query);            
#         $db_result->execute or logger("ERROR:DROP TABLE $tablename :$DBI::errstr");
#         # DBI::dump_results($db_result);

#         # logger("DEBUG:Housekeeping DB TABLE:query=$query");
#         while(my @row = $db_result->fetchrow_array()){
#             # printf("test: %s\n",$row[0],$row[1]);
#             $query="DROP TABLE IF EXISTS `$row[0]`";
#             my $rm_result = $db_connection->prepare($query);            
#             $rm_result->execute or logger("ERROR:DROP TABLE $row[0] :$DBI::errstr");
#             logger("DEBUG:Delete Table:Table Name = $row[0], Creat Time = $row[1]");
#         }   
  
#         $db_connection->disconnect;
#     }
#     else
#     {
#         logger("INFO:Connect:Database Connection ERROR");
#     }
# }

sub drop_table_byhistory
{
    my($title_tablename,$tablename,$name,$host,$user,$pass) = @_;
    my $target_tablename = $tablename."24";
    # print("tablename: $target_tablename\n");

    my $query = "select table_name, create_time from information_schema.TABLES where table_name like '$title_tablename%' order by create_time DESC;";
    logger("INFO:START DROP TABLES (Target Table: $tablename%)");
    my $db_connection = DBI->connect("DBI:mysql:database=$name;host=$host",$user,$pass);
    if ($db_connection)
    {
        $db_connection->{mysql_auto_reconnect} = 1;
        $db_connection->do( "set names utf8" );

        my $db_result = $db_connection->prepare($query);            
        $db_result->execute or logger("ERROR:DROP TABLE $tablename :$DBI::errstr");

        while(my @row = $db_result->fetchrow_array()){
            # printf("test: %s,%s\n",$target_tablename,$row[0]);
            # printf("score: %f %f\n",ord($target_tablename),ord($row[0]));
            # printf("score: %f\n",ord($target_tablename)-ord($row[0]));
            if($target_tablename ge $row[0])
            {
                # print(">\n");
                $query="DROP TABLE IF EXISTS `$row[0]`";
                my $rm_result = $db_connection->prepare($query);            
                $rm_result->execute or logger("ERROR:DROP TABLE $row[0] :$DBI::errstr");
                logger("DEBUG:Delete Table:Table Name = $row[0], Creat Time = $row[1]");
                
            }
            else
            {
                # print("<\n")
            }
        }   


        $db_connection->disconnect;
    }
    else
    {
        logger("INFO:Connect:Database Connection ERROR");
    }
    
}

sub drop_table_byday
{
    my($title_tablename,$tablename,$name,$host,$user,$pass) = @_;
    my $target_tablename = $tablename."24";
    # print("tablename: $target_tablename\n");

    my $query = "select table_name from information_schema.TABLES where table_name like '$title_tablename%' and table_name <= '$target_tablename' order by table_name;";
    logger("INFO:START DROP TABLES (Target Table: $tablename%)");
    my $db_connection = DBI->connect("DBI:mysql:database=$name;host=$host",$user,$pass);
    if ($db_connection)
    {
        $db_connection->{mysql_auto_reconnect} = 1;
        $db_connection->do( "set names utf8" );

        my $db_result = $db_connection->prepare($query);            
        $db_result->execute or logger("ERROR:DROP TABLE $tablename :$DBI::errstr");

        while(my @row = $db_result->fetchrow_array()){
            # printf("test: %s,%s\n",$target_tablename,$row[0]);
            # printf("score: %f %f\n",ord($target_tablename),ord($row[0]));
            # printf("score: %f\n",ord($target_tablename)-ord($row[0]));

            $query="DROP TABLE IF EXISTS `$row[0]`";
            my $rm_result = $db_connection->prepare($query);            
            $rm_result->execute or logger("ERROR:DROP TABLE $row[0] :$DBI::errstr");
            logger("DEBUG:Delete Table:Table Name = $row[0]");
                

        }   


        $db_connection->disconnect;
    }
    else
    {
        logger("INFO:Connect:Database Connection ERROR");
    }
    
}

sub drop_table_bycount
{
    my($tablename,$name,$host,$user,$pass,$keep_count) = @_;
    my $table_count = &get_count($tablename,$name,$host,$user,$pass);

    if($keep_count < $table_count)
    {
        my $offset_tmp = $table_count-$keep_count;
        print("offset_tmp: $offset_tmp");

        my $query = "select table_name from information_schema.TABLES where table_name like '$tablename%' order by table_name limit $offset_tmp;";
        logger("INFO:START DROP TABLES BY COUNT (Table count: $table_count, Keeping count: $keep_count)");
        my $db_connection = DBI->connect("DBI:mysql:database=$name;host=$host",$user,$pass);
        # print("keep_count: $keep_count table_count: $table_count \n");

        if ($db_connection)
        {
            # logger("INFO:Connect:Database Connection Successful");
            $db_connection->{mysql_auto_reconnect} = 1;
            $db_connection->do( "set names utf8" );

            my $db_result = $db_connection->prepare($query);            
            $db_result->execute or logger("ERROR:DROP TABLE $tablename :$DBI::errstr");

            # logger("INFO:Housekeeping DB TABLE:query=$query");
            my $tmp_count=0;
            while(my @row = $db_result->fetchrow_array()){
                # printf("test: %s,%s\n",$row[0],$row[1]);
                $query="DROP TABLE IF EXISTS `$row[0]`";
                my $rm_result = $db_connection->prepare($query);      
                $rm_result->execute or logger("ERROR:DROP TABLE $row[0] :$DBI::errstr");
                logger("DEBUG:Delete Table:Table Name = $row[0]");
            }   
            $db_connection->disconnect;
        }
        else
        {
            logger("INFO:Connect:Database Connection ERROR");
        }
    }
    else
    {
        # print("nothing to do"."\n")
        logger("INFO:Nothing To Do:The total number of $tablename% Tables <= keeping count. (Table count: $table_count, Keeping count: $keep_count)");
    }
    

    
}

sub get_count
{
    my($tablename,$name,$host,$user,$pass) = @_;
    my $query = "select count(*) from information_schema.TABLES where table_name like '$tablename%';";
    
    my $db_connection = DBI->connect("DBI:mysql:database=$name;host=$host",$user,$pass);
    if ($db_connection)
    {
        # logger("INFO:Connect:Database Connection Successful");
        $db_connection->{mysql_auto_reconnect} = 1;
        $db_connection->do( "set names utf8" );

        my $db_result = $db_connection->prepare($query);            
        $db_result->execute or logger("ERROR:DROP TABLE $tablename :$DBI::errstr");
        # DBI::dump_results($db_result);

        # logger("INFO:Housekeeping DB TABLE:query=$query");
        # while(my @row = $db_result->fetchrow_array()){
        #     printf("test count: %s\n",$row[0]);
        # }   
        my $row = $db_result->fetchrow_array();
        # printf("test count: %s\n",$row);
        return $row;
  
        # $db_connection->disconnect;
    }
    else
    {
        logger("INFO:Connect:Database Connection ERROR");
    }
}


#fill_ini    
#in  :    ini config file full path
#out :    %hash_ref, config hash
#work:    get config from ini file
sub fill_ini (\$){
    my ($array_ref) = @_;
    my $configfile = $array_ref;

    my %hash_ref;

    # print "SUB:CONFIGFILE:$configfile\n";
    open(CONFIGFILE,"< $configfile");
    my $main_section = 'main';
    my ($line,$copy_line);

    while ($line=<CONFIGFILE>) {
        chomp($line);
        $line =~ s/\n//g;
        $line =~ s/\r//g;
        $copy_line = $line;
        if ($line =~ /^#/) {
            # Ignore starting hash
        } else {
            if ($line =~ /\[(.*)\]/) {
                # print "SUB:FOUNDSECTION:$1\n";
                $main_section = $1;
            }
            if ($line eq "") {
                # print "SUB:BLANKLINE\n";
            }
            if ($line =~ /(.*)=(.*)/) {
                my ($key,$value) = split('=', $copy_line);
                $key =~ s/ //g;
                $key =~ s/\t//g;
                $value =~ s/^\s+//g;
                $value =~ s/\s+$//g;
                # print "SUB:KEYPAIR:$main_section -> $key -> $value\n";
                $hash_ref{"$main_section"}->{"$key"} = $value;
            }

        }
    }
    close(CONFIGFILE);
    return %hash_ref;
}

#logger    
#in  :    string
#out :    n/a
#work:    logging
sub logger 
{

    my @log_array = @_;
    my $log_line = $log_array[0];
    
    if ( (!($debug)) && ($log_line =~ /^DEBUG/i)) {
        return;
    }

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    $year += 1900; $mon++; $mon = sprintf("%02d", $mon); $mday = sprintf("%02d", $mday);
    $sec = sprintf("%02d", $sec); $min = sprintf("%02d", $min); $hour = sprintf("%02d", $hour);
    my ($seconds, $usec) = gettimeofday();
    $usec = sprintf("%06d", $usec);
    my $timestring;
    my $datestring = $year . '-' . $mon . '-' . $mday;
    $timestring = $datestring . ' ' . $hour . ':' . $min . ':' . $sec  . '.' . $usec;

    print "[$timestring] $log_line\n";
    
    #return;
    
    if ($log_dir =~ /\/$/) {
        # Do nothing
    } else {
        $log_dir = $log_dir . '/';
    }

    my $logfile = $log_dir . $program_name . '-' . $datestring . '-' . $hour . '.log';

    open(LOGFILE,">> $logfile");
    print LOGFILE "[$timestring] $log_line\n";
    close(LOGFILE);
    return;

}
