#!groovy

// https://github.com/feedhenry/fh-pipeline-library
@Library('fh-pipeline-library') _

fhBuildNode(['label': 'openshift']) {

    final String COMPONENT = 'mysql'
    final String VERSION = '5.5'
    final String BUILD = env.BUILD_NUMBER
    final String DOCKER_HUB_ORG = "rhmap"
    final String DOCKER_HUB_REPO = COMPONENT
    final String CHANGE_URL = env.CHANGE_URL

    stage('Platform Update') {
        final Map updateParams = [
                componentName: COMPONENT,
                componentVersion: VERSION,
                componentBuild: BUILD,
                changeUrl: CHANGE_URL
        ]
        fhCoreOpenshiftTemplatesComponentUpdate(updateParams)
    }

    stage('Build Image') {
        final Map params = [
                fromDir: "./${VERSION}",
                buildConfigName: COMPONENT,
                imageRepoSecret: "dockerhub",
                outputImage: "docker.io/${DOCKER_HUB_ORG}/${DOCKER_HUB_REPO}:${VERSION}-${BUILD}"
        ]
        buildWithDockerStrategy params
        archiveArtifacts writeBuildInfo('mysql-container', "${VERSION}-${BUILD}")
    }

}
