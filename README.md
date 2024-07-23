# POCs


This repo provides an easy way to Xygeni onboarding.
The main purpose of this repo is to provide some ready-to-use scrips to trigger a Xygeni scan

Tha basic element is a bash shell script (scan_repo_list.sh) that wraps the download and execution of Xygeni scanner over a list of git repositories.
If you feel confortable with bash scripting, you can view this shell script and modify according to your specific needs.


scan_repo_list.sh can be executed either from a unix command line or from a CI/CD pipeline.
Below you can find examples of executing scan_repo_list.sh from different CI/CD pipelines.

Basically, scan_repo_list.sh expects the following parameters

   scan_repo_list.sh -d src_dir -x xygeni_token -c cicd -p cicd_token -z repo_list"
        -d <directory path where the scanner will be downloaded> 
        -x <xygeni token>
        -c <cicd system, valid values : jenkins_github|gitlab|bitbucket|azure_devops|github|circle_ci >
        -p <cicd token, i.e. a valid PAT that will be used by Xygeni scanner to connect to the SCM/CICD system and recover security information>
        -z <arraylist of repos to scan>

An example of scan_repo_list.sh invocation might be as follows

    #!/bin/bash

    declare -a repo_list=(
                          "https://github.com/lgvorg1/secrets_local.git"
                          "https://github.com/lgvorg1/cicd_top10_1.git"
                          )
           
    ./scan_repo_list.sh -d /tmp -x $XY_TOKEN -c github -p $GITHUB_TOKEN -z "${repo_list[*]}"

Requirements:

* You will need, as minimun, one Xyegni token that will be used by the scanner to authenticate against you Xygeni tenant. Ask your Xygeni sales rep for valid token.
* Just in case you want to execute the CI/CD scan (to find vulnerabilities in your SCM/CICD system configuration), you will need an additional token to authenticate against your SCM/CICD platform. For example, if you are using GitHub you will need a GitHub PAT so the scanner can connect to your GitHub organization and scan for vulnerabilities.
* 