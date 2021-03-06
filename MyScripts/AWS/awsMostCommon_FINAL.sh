#!/bin/bash
#AWS-CLI based script for checking all of the resourcess that work under all of the avilable services under an account. (v1.0.2.) by @VZlatkov (a.k.a. - Xerxes)

#1-st - input a usesrname (IAM usessr) - needs you to have a valid AWS-CLI configuration on the machine
#2-nd - input a type of output you want the results to be displayed in (Text/JSON/Table). Current versison is optimized for JSON and may break the output if other type of output is used).
#3-rd - input the region you want to make a resource check for (ex. - "US-Easst-1") or leave empty if you want to make a check for all of the regions.
#4-th - displays a pseudo "loading bar" and opens up the AWS Management Console website on completion. On error - it exits and clears the screen.
#5-th - in version 1.0.3 the text and table outputs hsould be patched sos they are working properly.





#													ACTUAL SCRSIPT STARTS HERE:



# THOSE ARE THE VARIABLES FOR THE COLORS:
	GREEN="\e[32m"
	RED="\e[31m"
	ENDCOLOR="\e[0m"

# Get a carriage return into `cr`
cr=`echo $'\n.'`
cr=${cr%.}

#echo the ">> insert here:"
st=`echo '>> insert here: '`
echo '**************************************************************************************************************************************************************************************************************'
echo '**************************************************************************************************************************************************************************************************************'
echo '**************************************************************************************************************************************************************************************************************'
read -p "Input your AWS user name  $cr $cr $cr $st " username
echo '**************************************************************************************************************************************************************************************************************'



#INPUT FOR THE AWS USER
	
#read -p username
echo '**************************************************************************************************************************************************************************************************************'
read -p "Select the desired output format (text/json/table)  $cr $cr $cr $st " output
echo '**************************************************************************************************************************************************************************************************************'



#INPUT OUTPUT

#read -p output
echo '**************************************************************************************************************************************************************************************************************'
read -p "Specify your desired regions (or leave empty for all regions) and press enter (Region ex.:us-east-1 / ap-south-2 / etc.) $cr $cr $cr $st " region
echo '**************************************************************************************************************************************************************************************************************'



#read region


#Break if mandatory arguments are not present

	if [ -z "$username" ];
	then
echo -e "	    														   ${RED}WRONG/MISSING USERNAME. TRY AGAIN.${ENDCOLOR}"
sleep 5
echo $cr
echo $cr
echo $cr
echo -ne '                                  										        (0%)\r'
sleep 1
       echo -ne '####################################                  							        (33%)\r'
sleep 1
	echo -ne '######################################################################### 			       	        (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
        echo -ne '\n'
	sleep 5
clear
		exit;



	elif [ -z $output ];
	then
		$cr
		$cr
		$cr
		echo -e " 				 										${RED}WRONG/MISSING OUTPUT TYPE. TRY AGAIN.${ENDCOLOR}"
	sleep 5
	echo $cr
	echo $cr
	echo $cr
	echo -ne '                                                                                                              (0%)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
	
		clear
		exit;
	fi
	
#This should read the 'read region' command input or go to the next "if statement" and read its declared variables.

	if [ $region -z ];
	then


#Declearing all of the regions out there 

	declare -a arr=("us-east-1" "us-east-2" "us-west-1" "us-west-2" "us-east-1" "ap-south-1" "ap-southeast-2" "ap-east-1" "ap-southeast-1" "ap-northeast-1" "ap-northeast-2" "ca-central-1" "eu-central-1" "eu-west-1" "eu-west-2" "eu-west-3" "eu-south-1" "eu-north-1" "me-south-1" "sa-east-1")



#For statement that outputs all of the resources that are in use by the top 10 services	for every single region depending on the declared/hard coded regions
	for i in "${arr[@]}"; do
	
		echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2 | grep -Eo "(:|,|/)".* | cut -f7 -d : && echo -e "${GREEN}RDS${ENDCOLOR}" && aws --region $i rds describe-db-instances --output $output --profile $username |jq '.[] |=sort_by(.DBInstanceIdentifier)' | grep -i 'DBInstanceIdentifier":' && echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $i ecs list-task-definitions --output $output --profile $username && echo -e "${GREEN}S3${ENDCOLOR}" && aws --region $i s3 ls --output $output --profile $username | awk '{print $3'}&& echo - "${GREEN}SQS${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs | grep -Eo "(:|,|/)".* | cut -f7 -d : && echo -e "${GREEN}ELB${ENDCOLOR}" &&  aws --region $i elb describe-load-balancers --output $output --profile $username| jq '.[] |=sort_by(.LoadBalancerName)' | grep -i loadbalancername | awk '{print $2}'&& echo -e "${GREEN}LAMBDA${ENDCOLOR}" && aws --region $i lambda list-functions --output $output --profile $username && echo -e "${GREEN}VPC${ENDCOLOR}" && aws --region $i resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc | grep -Eo "(:|,|/)".* | cut -f7 -d : 
	done



#If you have declared a region - it uses it

	else
		echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $region resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e ec2 && echo -e "${GREEN}RDS${ENDCOLOR}" && aws --region $region rds describe-db-instances --output $output --profile $username && echo -e "${GREEN}EC2${ENDCOLOR}" && aws --region $region ecs list-task-definitions --output $output --profile $username && echo -e "${GREEN}S3${ENDCOLOR}" && aws --region $region s3 ls --output $output --profile $username && echo - "${GREEN}SQS${ENDCOLOR}" && aws --region $region resourcegroupstaggingapi get-resources --output $output --profile $username |grep -e sqs && echo -e "${GREEN}ELB${ENDCOLOR}" &&  aws --region $region elb describe-load-balancers --output $output --profile $username && echo -e "${GREEN}LAMBDA${ENDCOLOR}" && aws --region $region lambda list-functions --output $output --profile $username && echo -e "${GREEN}VPC${ENDCOLOR}" && aws --region $region resourcegroupstaggingapi get-resources --output $output --profile $username | grep -e vpc
	fi


#Declares end of the script	
	
	echo '**********************************************************************************************************************************************************************************************************'

	echo -e "                                                                                               ${GREEN}DONE${ENDCOLOR}"
		
	echo '**********************************************************************************************************************************************************************************************************'
	
	sleep 3
	if [ "$USER" == root ];
		then 
	echo $cr
	echo $cr
	echo $cr	
	echo -ne '                                                                                                              (0%)\r'
        sleep 1
        echo -ne '####################################                                                                          (33%)\r'
        sleep 1
        echo -ne '#########################################################################                                     (66%)\r'
        sleep 1
        echo -ne '############################################################################################################# (100%)\r'
	sleep 1
		sudo -u $SUDO_USER firefox https://console.aws.amazon.com/console/home?region=us-east-1#;
	
	#elif 
	
	#echo -ne '                                                                                                              (0%)\r'
        #sleep 1
        #echo -ne '####################################                                                                          (33%)\r'
        #sleep 1
        #echo -ne '#########################################################################                                     (66%)\r'
        #sleep 1
        #echo -ne '############################################################################################################# (100%)\r'
        #sleep 1
	
	#firefox https://console.aws.amazon.com/console/home?region=us-east-1#; 
	#;
	fi
