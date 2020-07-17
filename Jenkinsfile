@Library('s4sdk-pipeline-library@master') _
//fixme just for testing, revert later
call script: this

void call(parameters) {
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
                    stageInitS4sdkPipeline script: parameters.script, nodeLabel: parameters.initNodeLabel
                    abortOldBuilds script: parameters.script
                }
            }

            stage('Build and Test') {
                steps {
                    milestone 20
                    piperPipelineStageBuild script: parameters.script, stageName: 'build'
                }
            }

            stage('Remote Tests') {
                when { expression { parameters.script.commonPipelineEnvironment.configuration.runStage.REMOTE_TESTS } }
                parallel {
                    stage("End to End Tests") {
                        when { expression { parameters.script.commonPipelineEnvironment.configuration.runStage.E2E_TESTS } }
                        steps { stageEndToEndTests script: parameters.script }
                    }
                    stage("Performance Tests") {
                        when { expression { parameters.script.commonPipelineEnvironment.configuration.runStage.PERFORMANCE_TESTS } }
                        steps { stagePerformanceTests script: parameters.script }
                    }
                }
            }

        }
    }
}
