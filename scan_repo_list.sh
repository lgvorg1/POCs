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
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC"
   echo -e "\t-a Description of what is parameterA"
   echo -e "\t-b Description of what is parameterB"
   echo -e "\t-c Description of what is parameterC"
   exit 1 # Exit script after printing help
}

while getopts "a:b:c:" opt
do
   case "$opt" in
      a ) parameterA="${OPTARG}" ;;
      b ) parameterB="${OPTARG}" ;;
      c ) parameterC="${OPTARG}" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"

read -r -a splitArray <<<"$parameterC"

for a in "${splitArray[@]}"; do
    echo "$a"
done


#echo "$parameterC"
#for a in "${parameterC[@]}"; do
#    echo "$a"
#done