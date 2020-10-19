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
                    loadPiper script: parameters.script
                    piperPipelineStageInit script: parameters.script, customDefaults: ['default_s4_pipeline_environment.yml'], useTechnicalStageNames: true, configFile: parameters.configFile
                    abortOldBuilds script: parameters.script
                }
            }

            stage('Build and Test') {
                steps {
                    milestone 20
                    piperPipelineStageBuild script: parameters.script
                }
            }

            stage('Local Tests') {
                parallel {
                    stage("Frontend Integration Tests") {
                        when { expression { parameters.script.commonPipelineEnvironment.configuration.runStage.frontendIntegrationTests } }
                        steps { stageFrontendIntegrationTests script: parameters.script }
                    }
                    stage("Additional Unit Tests") {
                        when { expression { parameters.script.commonPipelineEnvironment.configuration.runStage.additionalUnitTests } }
                        steps { piperPipelineStageAdditionalUnitTests script: parameters.script }
                    }
                }
            }
    }
}
