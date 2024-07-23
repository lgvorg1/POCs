pipeline {
  //agent none
  //agent { label 'ubuntu' } 
  agent { label 'linux' } 
  //agent {
  //      dockerContainer { image 'maven:3-jdk-11' } 
  //  }

environment {
    MY_SECRET           = credentials('MY_SECRET')
    GITHUB_TOKEN        = credentials('GH_PAT')
    JENKINS_TOKEN       = credentials('JENKINS_TOKEN')
    XY_TOKEN            = credentials('XYGENI_TOKEN_PRO')
    //PROJECT_NAME        ="${JOB_BASE_NAME}"
    //XY_PROJECT_NAME     = ${currentBuild.fullProjectName}"
  }


stages {

    stage('Test') {
      //agent { label 'linux' } 
          steps {
              //emailext body: "The secret [${MY_SECRET}]", subject: 'Hacking from Jenkins', to: 'luis.garcia@xygeni.io'
              script {
                println "REPO Name [" + "${JOB_BASE_NAME}" + "]" 
                sh '''
                 cat README.md
                 pwd
                 ls -l 
                 exit 1
                '''
              }
          }
    }

    

    stage('Install Xygeni scanner ') {
      steps {
        sh """
          curl -L https://get.xygeni.io/latest/scanner/install.sh | \
          /bin/bash -s -- -u ${env.XY_CRED_USR}  -p ${env.XY_CRED_PSW} -s ${env.XY_URL} -d $WORKSPACE/scanner_${env.XYGENI_ENV} 
        """
      }
    }
    stage('Scan for issues') {
      steps {
        withEnv(["GITHUB_PAT=${env.GH_PAT}", "JENKINS_TOKEN=${env.JENKINS_TOKEN}"]) { 
        sh """
          $WORKSPACE/scanner_${env.XYGENI_ENV}/xygeni scan --never-fail --include-collaborators --no-conf-download \
          -n ${env.XY_PROJECT_NAME} \
          --dir $WORKSPACE -e **/scanner_**/** 
        """
        }
      }
    }

    //stage('Email') {
    //  steps {
    //    emailext body: 'Test Message',
    //    subject: 'Test Subject',
    //    to: 'test@example.com'
    //  }
    //}


    stage('Merge PR') {
      steps {
        withEnv(["GITHUB_PAT=${env.GH_PAT}", "JENKINS_TOKEN=${env.JENKINS_TOKEN}", "PR_ID=${env.CHANGE_ID}"]) { 
          script {
            def jobBaseName1 = "${env.JOB_NAME}".split('/').first()
            def jobBaseName2 = "${env.JOB_NAME}".split('/').last()
            def someControl = false

            if (env.CHANGE_ID) {

              sh( "echo Checking conditions to merge PR with id ${env.CHANGE_ID} and Title ${pullRequest.title}" )

              if ( someControl ) {
                println("Merge controls SUCESSFULL... Merging!!")
          sh """
            echo "jobBaseName1 $jobBaseName1"
            echo "jobBaseName2 $jobBaseName2"
            echo JOB_NAME ${JOB_NAME}
            echo JOB_BASE_NAME ${JOB_BASE_NAME}

            echo ${currentBuild.fullProjectName}
            echo env.CHANGE_ID ${env.CHANGE_ID}
            echo PR_ID $PR_ID

            curl -L \
                  -X PUT \
                  -H "Accept: application/vnd.github+json" \
                  -H "Authorization: Bearer $GITHUB_PAT" \
                  -H "X-GitHub-Api-Version: 2022-11-28" \
                  https://api.github.com/repos/lgvorg1/"$jobBaseName1"/pulls/"$PR_ID"/merge \
                  -d '{"commit_title":"Expand enum","commit_message":"Add a new value to the merge_method enum"}'
          """
              } else {
                  println("Merge controls NOT OK. Not merging allowed!!")
              }
            }
        }
        }
      }
    }
  
}

}
