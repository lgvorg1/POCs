# POCs


This repo provides an easy way to **Xygeni onboarding**.
Here you will find some <ins>ready-to-use scripts to trigger a Xygeni scan</ins>.

Tha basic element is a bash shell script [scan_repo_list.sh](./scan_repo_list.sh) that <ins>wraps the downloading and execution of Xygeni scanner **over a list of git repositories**</ins>.
If you feel confortable with bash scripting, you can view this shell script and modify according to your specific needs.


**scan_repo_list.sh** can be executed either from a unix command line or from a CI/CD pipeline.

## Basic usage (in a a bash command line)
Basically, scan_repo_list.sh expects the following parameters

```
    scan_repo_list.sh -d src_dir -x xygeni_token -c cicd -p cicd_token -z repo_list
        -d <directory path where the scanner will be downloaded> 
        -x <xygeni token>
        -c <cicd system, valid values : github|gitlab|azure_devops|jenkins_github>
        -p <cicd token, i.e. a valid PAT that will be used by Xygeni scanner to connect to the SCM/CICD system and recover security information>
        -z <arraylist of repos to scan>
```

An example of scan_repo_list.sh invocation might be as follows

    #!/bin/bash

    declare -a repo_list=(
                          "https://github.com/lgvorg1/secrets_local.git"
                          "https://github.com/lgvorg1/cicd_top10_1.git"
                          )
           
    ./scan_repo_list.sh -d /tmp -x $XY_TOKEN -c github -p $GITHUB_TOKEN -z "${repo_list[*]}"


The shell script will donwload the Xygeni scanner and will loop over the provided list of repos, executing the Xygeni scanner for each of them.

## Requirements

* You will need, as minimun, one **Xygeni token** that will be used by the scanner to authenticate against you Xygeni tenant. Ask your Xygeni sales rep for valid token.
* Just in case you want to execute the CI/CD scan (to find vulnerabilities in your SCM/CICD system configuration), you will need an **additional token** to authenticate against your SCM/CICD platform. For example, if you are using GitHub you will need a GitHub PAT so the scanner can connect to your GitHub organization and scan for vulnerabilities.
* **Java 11+** JRE must be available in the path
* The **package manager binaries** (mvn,npm, etc) used by your repo

## Usage into a CI/CD pipeline
Below you can find examples of how to call the scan_repo_list.sh from different CI/CD pipelines.

As you can see in below examples, needed tokens are not hardcoded but stored outside of the pipeline and referenced through pipeline variables. Feel free to customize these examples according to your specific needs and your CI/CD environment.

You can fork this repo to your SCM/CICD and customize as needed. 

* [GitHub pipeline](./.github/workflows/xygeni_scan.yml)
* [GitLab pipeline](./.gitlab-ci.yml) 
* [Azure DevOps pipeline](./ADO_pipeline.yml) 
* [Jenkins pipeline](./Jenkinsfile) 

Because Jenkins is not an SCM, the token that must be provided must be of that SCM where the jenkinsfile checks out the code. That is the reason of the option jenkins_github (i.e. Jenkins using GitHub) as SCM. In this case, if you are using Jenkins with GitHub you must provide the GITHUB_TOKEN in the -p parameter. 

