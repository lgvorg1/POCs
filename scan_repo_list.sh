#!/bin/bash


helpFunction()
{
   echo ""
   echo "Usage: $0 -d scanner_dir -x xygeni_token -c cicd -p cicd_token -z repo_list"
   echo -e "\t-d scanner_dir"
   echo -e "\t-x xygeni_token"
   echo -e "\t-c cicd system"
   echo -e "\t-p cicd token"
   echo -e "\t-z arraylist of repos"
   exit 1 # Exit script after printing help
}


downloadXYscanner()
{
    echo 1: $1
    echo 2: $2

    rm -rf $2/scanner_pro
    curl -L https://get.xygeni.io/latest/scanner/install.sh | /bin/bash -s -- -t $1 -d $2
}

executeXYscanner()
{
    #./scanner_pro/xygeni scan  --include-collaborators --run="inventory,misconf,codetamper,deps,suspectdeps,secrets,compliance,iac" -n $1 --dir $1 -e **/scanner_pro/**
    #./scanner_pro/xygeni scan  --include-collaborators --run="inventory,misconf,codetamper,deps,suspectdeps,secrets,compliance,iac" -repo=$1 -e **/scanner_pro/**
    $2/xygeni scan  --no-conf-download --include-collaborators --run="inventory" -repo=$1 -e **/$2/**
}


updateConfJenkins()
{
    #export JENKINS_MASTER=127.0.0.1:8080
    env | grep JENKINS_MASTER
    env | grep JENKINS_PROTO
    env | grep JENKINS_USER
    env | grep JENKINS_TOKEN
    
    echo yyyyyyyyyyyyyyyyyyyyyyyyyy
    grep url  $1/conf/xygeni.yml
    ls -l $1/conf/xygeni.yml
    rm -rf $1/kk.txt
    #cat ./scanner_pro/conf/xygeni.yml | tr '\n' '\r' | sed -e "s/kind: jenkins\r    # Jenkins base URL\r    url: ''/kind: jenkins\r    # Jenkins base URL\r    url: 'http:\/\/$JENKINS_MASTER'"/g  | tr '\r' '\n' > ./scanner_pro/conf/xygeni.yml 
    # cat ./scanner_pro/conf/xygeni.yml | tr '\n' '\r' | sed -e "s/kind: jenkins\r    # Jenkins base URL\r    url: ''/kind: jenkins\r    # Jenkins base URL\r    url: '$JENKINS_PROTO\/\/$JENKINS_MASTER'"/g  | tr '\r' '\n' > ./kk.txt
    #TXT1="kind: jenkins\r    # Jenkins base URL\r    url: ''\r    # Which projects use this CI\/CD system?\r    # Use a regex pattern, like 'project1|project2|project3' or 'prefix_.*'\r    # Leave empty for matching any project for the given jenkins kind\r    usedBy: ''\r    # The username to connect to the CI\/CD API.\r    user: null" 
    #TXT2="kind: jenkins\r    # Jenkins base URL\r    url: '$JENKINS_PROTO\/\/$JENKINS_MASTER'\r    # Which projects use this CI\/CD system?\r    # Use a regex pattern, like 'project1|project2|project3' or 'prefix_.*'\r    # Leave empty for matching any project for the given jenkins kind\r    usedBy: ''\r    # The username to connect to the CI\/CD API.\r    user: $JENKINS_USER"
    #TXT1="url: '$JENKINS_PROTO\/\/$JENKINS_MASTER'"
    #echo TXT1 $TXT1
    #cat $1/conf/xygeni.yml | tr '\n' '\r' | grep "url"
    #cat $1/conf/xygeni.yml | tr '\n' '\r' | grep "$TXT1" 
    #grep "$TXT1" $1/conf/xygeni.yml
    #exit 1
    cat $1/conf/xygeni.yml | tr '\n' '\r' | sed -e "s/kind: jenkins\r    # Jenkins base URL\r    url: ''\r    # Which projects use this CI\/CD system?\r    # Use a regex pattern, like 'project1|project2|project3' or 'prefix_.*'\r    # Leave empty for matching any project for the given jenkins kind\r    usedBy: ''\r    # The username to connect to the CI\/CD API.\r    user: null/kind: jenkins\r    # Jenkins base URL\r    url: '$JENKINS_PROTO\/\/$JENKINS_MASTER'\r    # Which projects use this CI\/CD system?\r    # Use a regex pattern, like 'project1|project2|project3' or 'prefix_.*'\r    # Leave empty for matching any project for the given jenkins kind\r    usedBy: ''\r    # The username to connect to the CI\/CD API.\r    user: $JENKINS_USER"/g   | tr '\r' '\n' > $1/kk.txt 

     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
     stat -c %s $1/kk.txt
     
     ls -l $1/kk.txt
     #cat ./kk.txt
     cp $1/kk.txt $1/conf/xygeni.yml
     grep url  $1/conf/xygeni.yml
     diff $1/kk.txt $1/conf/xygeni.yml
     exit 1

}


while getopts "d:x:c:p:j:z:" opt
do
   case "$opt" in
      d ) parameterD="${OPTARG}" ;;
      x ) parameterX="${OPTARG}" ;;
      c ) parameterC="${OPTARG}" ;;
      p ) parameterP="${OPTARG}" ;;
      z ) parameterZ="${OPTARG}" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterD" ] || [ -z "$parameterX" ] || [ -z "$parameterC" ] || [ -z "$parameterP" ] || [ -z "$parameterZ" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi


echo src_dir: "$parameterD"
export XY_INST_DIR="$parameterD/scanner_pro"
echo xygeni_token: "$parameterX"
export XY_C_TOKEN="$parameterX"

downloadXYscanner  "$XY_C_TOKEN" "$XY_INST_DIR"

# Begin script in case all parameters are correct

echo cicd system: "$parameterC"
case "$parameterC" in 
    "jenkins_github" ) export GITHUB_TOKEN="$parameterP" 
                echo "Parameter is Jenkins GitHub" ;;
    "jenkins_gitlab" ) export GITLAB_TOKEN="$parameterP" 
                updateConfJenkins "$XY_INST_DIR"
                echo "Parameter is Jenkins GitLab" ;;
    "gitlab" ) export GITLAB_TOKEN="$parameterP" 
                echo "Parameter is GitLab" ;; 
    "bitbucket" ) export BITBUCKET_TOKEN="$parameterP" 
                echo "Parameter is BitBucket" ;;
    "azure_devops" ) export AZURE_TOKEN="$parameterP" 
                echo "Parameter is Azure DevOps" ;;
    "github" ) export GITHUB_TOKEN="$parameterP" 
                echo "Parameter is GitHub" ;;
    "circle_ci" ) export CIRCLECI_TOKEN="$parameterP" 
                echo "Parameter is Circle CI" ;;
    * ) echo -e "\t-c cicd system [$parameterC] not valid. valid values [jenkins_github|jenkins_gitlab|gitlab|bitbucket|azure_devops|github|circle_ci]"
        exit 1 ;;
esac

env | grep _TOKEN


read -r -a splitArray <<<"$parameterZ"






counter=0
for a in "${splitArray[@]}"; do
    #echo "$a"
    executeXYscanner "$a" "$XY_INST_DIR"
    ((counter++))
    #git clone "$a" dir$counter
    #pwd
    #ls -al
    #ls -al dir$counter
done






#echo "$parameterC"
#for a in "${parameterC[@]}"; do
#    echo "$a"
#done