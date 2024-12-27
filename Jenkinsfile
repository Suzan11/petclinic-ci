pipeline {
    agent any
    environment {
        SRC_DIR = "${WORKSPACE}/src"
        BUILD_DIR = "${WORKSPACE}/build"
        WAR_FILE = "${BUILD_DIR}/hello-world.war"
        TOMCAT_DIR = "/home/tomcat/apache-tomcat-10.1.34/webapps"
        ANSIBLE_HOSTS = "${WORKSPACE}/inventory/hosts"
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                git branch: 'main', url: 'https://github.com/Suzan11/petclinic-ci.git', changelog: false, poll: false
            }
        }
        stage('Build Application') {
            steps {
                echo 'Building the application...'
        sh """
            ./scripts/build.sh ${SRC_DIR}  ${BUILD_DIR}
        """
            }
        }
        stage('Deploy Application') {
            steps {
                echo 'Deploying application to Tomcat...'
                ansiblePlaybook playbook: './playbooks/deploy.yml',
                                inventory: ANSIBLE_HOSTS,
                                extraVars: [
                                    war_file_path: "${WAR_FILE}",
                                    tomcat_webapps_dir: TOMCAT_DIR
                                ]
            }
        }
        stage('Sanity Check') {
            steps {
                echo 'Running sanity checks...'
                sh './scripts/sanity_check.sh http://ec2-18-223-237-246.us-east-2.compute.amazonaws.com:9091/hello-world/'
            }
        }
        stage('Configure Monitoring') {
            steps {
                echo 'Configuring Nagios monitoring...'
                ansiblePlaybook playbook: './playbooks/nagios_setup.yml',
                                inventory: ANSIBLE_HOSTS,
                                extraVars: [
                                    nagios_service_name: 'Tomcat',
                                    tomcat_service_name: 'tomcat'
                                ]
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
