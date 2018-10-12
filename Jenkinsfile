#!groovy

// https://github.com/feedhenry/fh-pipeline-library
@Library('fh-pipeline-library') _

final String COMPONENT = 'mysql'
final String VERSION = '5.5'
final String DOCKER_HUB_ORG = "rhmap"

String BUILD = ""
String DOCKER_HUB_REPO = ""
String CHANGE_URL = ""

fhBuildNode(['label': 'openshift']) {

    BUILD = env.BUILD_NUMBER
    DOCKER_HUB_REPO = COMPONENT
    CHANGE_URL = env.CHANGE_URL

    stage('Platform Update') {
        final Map updateParams = [
                componentName: COMPONENT,
                componentVersion: VERSION,
                componentBuild: BUILD,
                changeUrl: CHANGE_URL
        ]
        fhCoreOpenshiftTemplatesComponentUpdate(updateParams)
    }

    stash COMPONENT
    archiveArtifacts writeBuildInfo('mysql-container', "${VERSION}-${BUILD}")
}

node('master') {
    stage('Build Image') {
        unstash COMPONENT

        final Map params = [
                fromDir: "./${VERSION}",
                buildConfigName: COMPONENT,
                imageRepoSecret: "dockerhub",
                outputImage: "docker.io/${DOCKER_HUB_ORG}/${DOCKER_HUB_REPO}:${VERSION}-${BUILD}"
        ]

        try {
            buildWithDockerStrategy params
        } finally {
            sh "rm -rf *"
        }
    }
}
