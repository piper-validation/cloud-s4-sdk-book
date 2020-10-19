#!/usr/bin/env groovy

final def pipelineSdkVersion = 'master'

pipeline {
    agent any
    options {
        timeout(time: 120, unit: 'MINUTES')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        skipDefaultCheckout()
    }
    stages {
        stage('Init') {
            steps {
                loadPiper script: this
                piperPipelineStageInit script: this, customDefaults: ['default_s4_pipeline_environment.yml'], useTechnicalStageNames: true, configFile: parameters.configFile
                abortOldBuilds script: this
            }
        }

        stage('Build and Test') {
            steps {
                milestone 20
                piperPipelineStageBuild script: this
            }
        }

        stage('Local Tests') {
            parallel {
                stage("Frontend Integration Tests") {
                    steps { stageFrontendIntegrationTests script: this }
                }
                stage("Additional Unit Tests") {
                    steps { piperPipelineStageAdditionalUnitTests script: this }
                }
            }
        }
    }
}
