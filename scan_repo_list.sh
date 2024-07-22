#!/bin/bash




#declare -a arr=(
#                "element1" 
#                "element2" 
#                "element3"
#                "element4"
#                )
#for i in "${arr[@]}"
#do
#    echo "$i"
#    # or do whatever with individual element of the array
#done

helpFunction()
{
   echo ""
   echo "Usage: $0 -x xygeni_token -c cicd -z parameterC"
   echo -e "\t-x xygeni_token"
   echo -e "\t-c cicd system"
   echo -e "\t-z Description of what is parameterC"
   exit 1 # Exit script after printing help
}

while getopts "x:c:z:" opt
do
   case "$opt" in
      x ) parameterX="${OPTARG}" ;;
      c ) parameterC="${OPTARG}" ;;
      z ) parameterZ="${OPTARG}" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterX" ] || [ -z "$parameterC" ] || [ -z "$parameterZ" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo xygeni_token: "$parameterX"
echo cicd system: "$parameterC"
case "$parameterC" in 
    "jenkins" ) echo "PArameter is Jenkins" ;;
    * ) echo "chungo" ;;
esac

read -r -a splitArray <<<"$parameterZ"

for a in "${splitArray[@]}"; do
    echo "$a"
done


#echo "$parameterC"
#for a in "${parameterC[@]}"; do
#    echo "$a"
#done