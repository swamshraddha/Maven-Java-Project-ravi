def mvnHome
pipeline {
	agent {
		 label "slave1"
	}      	
   stages {
       stage('Code from GitHub') {
	        steps {
			    git 'https://github.com/ravikiran529/Maven-Java-Project.git'
				script{
			        mvnHome = tool 'maven3.6'
			    }
			}
	   }
       stage('Code-Analysis') {
	        steps {
			    sh "'${mvnHome}/bin/mvn' clean cobertura:cobertura"
			}
			post {
			    success {
				    cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'target/site/cobertura/coverage.xml', conditionalCoverageTargets: '70, 0, 0', failUnhealthy: false, failUnstable: false, lineCoverageTargets: '80, 0, 0', maxNumberOfBuilds: 0, methodCoverageTargets: '80, 0, 0', onlyStable: false, sourceEncoding: 'ASCII', zoomCoverageChart: false 
				}
			}
	   }
	   stage('Build') {
	        steps {
			    sh "'${mvnHome}/bin/mvn' clean package"
			}
			post {
			    always{
			        junit 'target/surefire-reports/*.xml'
					archiveArtifacts artifacts: '**/*.war', onlyIfSuccessful: true
        	    }
			}	
	   }
	   stage('Upload Artifact') {
	        steps {
			    sh "'${mvnHome}/bin/mvn' clean deploy"			
	        }
	   }		   
	   stage('Deploy') {
	        steps {
			    deploy adapters: [tomcat8(credentialsId: 'tomcat2', path: '', url: 'http://192.168.35.15:8080')], contextPath: 'my_app', onFailure: false, war: '**/*.war'
			}
	   }
	   stage('Integration-testing') {
	        steps {
			    sh "'${mvnHome}/bin/mvn' clean verify" 
			}
	   }
	   stage('Production') {
	        steps {
			    timeout(time: 2, unit: 'HOURS') {
			    input message: 'Deploy to Production?', submitter: 'Administrator'
			    }
			
		            sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible-controller', transfers: [sshTransfer(cleanRemote: true, excludes: '', execCommand: '''cd workspace/ansible-files
git pull origin master
ansible-playbook -b ansibleRoles/tomcat.yml''', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: 'workspace/ansible-files/ansibleRoles/tomcat/files', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '**/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                }
                post {
                  success {
                             echo "Application has been deployed to production successfully!"
                  }
               }	   
        }   
   }
}

