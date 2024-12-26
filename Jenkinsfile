pipeline {
    agent any
    environment {
        SRC_DIR = "${WORKSPACE}"               // Source directory at the root of the workspace
        BUILD_DIR = "${WORKSPACE}/build"       // Build output directory
        WAR_FILE = "${BUILD_DIR}/petclinic.war" // WAR file location
        TOMCAT_DIR = "/home/tomcat/apache-tomcat-10.1.34/webapps"
        ANSIBLE_HOSTS = "${WORKSPACE}/inventory/hosts"
    }
    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                git branch: 'main', url: 'https://github.com/Suzan11/petclinic-ci.git'
            }
        }
        stage('Build Application') {
            steps {
                echo 'Building the application...'
                sh './scripts/build.sh -s ${SRC_DIR} -o ${BUILD_DIR}'
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
                sh './scripts/sanity_check.sh http://localhost:9090/petclinic'
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
