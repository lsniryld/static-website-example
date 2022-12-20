pipeline{
	environment {
		IMAGE_NAME= "staticwebsite"
        	IMAGE_TAG= "v1"
    		ID_DOCKER = "${ID_DOCKER_PARAMS}"
		APP_NAME = "nini"
		RVW_API_ENDPOINT = "http://ip10-0-4-4-ceh1rfomjkegg872buj0-1993.direct.docker.labs.eazytraining.fr"
		RVW_APP_ENDPOINT = "http://ip10-0-4-4-ceh1rfomjkegg872buj0-80.direct.docker.labs.eazytraining.fr"
		STG_API_ENDPOINT = "http://ip10-0-4-5-ceh1rfomjkegg872buj0-1993.direct.docker.labs.eazytraining.fr"
		STG_APP_ENDPOINT = "http://ip10-0-4-5-ceh1rfomjkegg872buj0-80.direct.docker.labs.eazytraining.fr"
		PROD_API_ENDPOINT = "http://ip10-0-4-6-ceh1rfomjkegg872buj0-1993.direct.docker.labs.eazytraining.fr"
		PROD_APP_ENDPOINT = "http://ip10-0-4-6-ceh1rfomjkegg872buj0-80.direct.docker.labs.eazytraining.fr"
		URL_APP_ENDPOINT = "http://ip10-0-4-3-ceh1rfomjkegg872buj0-80.direct.docker.labs.eazytraining.fr"
		INTERNAL_PORT = "80" 
		EXTERNAL_PORT = "${PORT_EXPOSED}"  
		CONTAINER_IMAGE = "${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG"

    }
    agent none
  	stages{
		stage('Build image'){
			agent any
			steps {
				script{
					sh 'docker build -t $ID_DOCKER/$IMAGE_NAME:$IMAGE_TAG .'
					}
			}
		}
		stage('Run container'){
			agent any
			steps {
				script{
					sh '''
					echo "Clean environment"
					docker rm -f $IMAGE_NAME || echo "Container does not exist"
					docker run --name $IMAGE_NAME -d -p ${PORT_EXPOSED}:${INTERNAL_PORT} -e PORT=${INTERNAL_PORT} ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
					sleep 5
					'''
					}
			}
		} 
		stage('Tests'){
			agent any
			steps {
				script{
					sh 'curl $URL_APP_ENDPOINT | grep -q "Dimension" '
					}
			}
		}
		stage('Packages'){
			agent any
          	environment {
           		DOCKERHUB_PASSWORD  = credentials('DOCKER_LOGIN')
          	}  
          	steps {
             	script {
               		sh '''
                   		echo $DOCKERHUB_PASSWORD_PSW | docker login -u $ID_DOCKER --password-stdin
                   		docker push ${ID_DOCKER}/$IMAGE_NAME:$IMAGE_TAG
               		'''
             	}
          	}
		} 
		
		stage('Review Test'){
			when {
				expression { GIT_BRANCH == 'origin/main' }
			}
			agent any
			steps {
				script{
					sh """
					curl -X POST ${RVW_API_ENDPOINT}/review -H 'Content-Type: application/json' -d '{"your_name":"niry","container_image":"${CONTAINER_IMAGE}", "external_port":"${EXTERNAL_PORT}", "internal_port":"INTERNAL_PORT"}'
					"""
				}
			}
		}
		
		stage('Staging deploy'){
			when {
				expression { GIT_BRANCH == 'origin/main' }
			}
			agent any
			steps {
				script{
					sh """
					curl -X POST ${STG_API_ENDPOINT}/staging -H 'Content-Type: application/json' -d '{"your_name":"niry","container_image":"${CONTAINER_IMAGE}", "external_port":"${EXTERNAL_PORT}", "internal_port":"INTERNAL_PORT"}'
					"""
				}
			}
		}
		
		stage('Production deploy'){
			when {
				expression { GIT_BRANCH == 'origin/main' }
			}
			agent any
			steps {
				script{
					sh """
					curl -X POST ${STG_API_ENDPOINT}/prod -H 'Content-Type: application/json' -d '{"your_name":"niry","container_image":"${CONTAINER_IMAGE}", "external_port":"${EXTERNAL_PORT}", "internal_port":"INTERNAL_PORT"}'
					"""
				}
			}
		}
		
  }
}
