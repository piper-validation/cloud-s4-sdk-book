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
                stageBuild script: this
            }
        }

        stage('Local Tests') {
            parallel {
                stage("Static Code Checks") {
                    when { expression { commonPipelineEnvironment.configuration.runStage.STATIC_CODE_CHECKS } }
                    steps { stageStaticCodeChecks script: this }
                }
                stage("Lint") {
                    steps { stageLint script: this }
                }
                stage("Backend Unit Tests") {
                    when { expression { commonPipelineEnvironment.configuration.runStage.BACKEND_UNIT_TESTS } }
                    steps { stageUnitTests script: this }
                }
                stage("Backend Integration Tests") {
                    when { expression { commonPipelineEnvironment.configuration.runStage.INTEGRATION_TESTS } }
                    steps { stageIntegrationTests script: this }
                }
                stage("Frontend Unit Tests") {
                    when { expression { commonPipelineEnvironment.configuration.runStage.FRONTEND_UNIT_TESTS } }
                    steps { stageFrontendUnitTests script: this }
                }
                stage("NPM Dependency Audit") {
                    when { expression { commonPipelineEnvironment.configuration.runStage.NPM_AUDIT } }
                    steps { stageNpmAudit script: this }
                }
            }
        }
    }
}
