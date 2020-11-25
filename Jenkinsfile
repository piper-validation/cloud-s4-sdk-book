#!/usr/bin/env groovy

final def pipelineSdkVersion = 'v45'

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
                milestone 10
                library "s4sdk-pipeline-library@${pipelineSdkVersion}"
                stageInitS4sdkPipeline script: this
                abortOldBuilds script: this
            }
        }

        stage('Build') {
            steps {
                milestone 20
                    piperPipelineStageBuild script: this, stageName: 'build'
            }

        }
    }
}
