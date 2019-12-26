node{
    stage('git checkout'){
        git credentialsId: 'c7ec11f8-be14-4db2-85a9-589b52864e9a', url: 'https://github.com/Vishnu4226/poc-spark.git'
    }
    stage('maven'){
         sh'''
         sbt clean package
         '''
    }
    stage('Upload'){
        dir('/var/lib/jenkins/workspace/poc-spark/target/scala-2.11/')
        {
             s3Upload consoleLogLevel: 'INFO', dontWaitForConcurrentBuildCompletion: false, entries: [[bucket: 'hellotest002/$JOB_NAME:$BUILD_NUMBER.jar', excludedFile: '', flatten: false, gzipFiles: false, keepForever: false, managedArtifacts: false, noUploadOnFailure: true, selectedRegion: 'us-east-1', showDirectlyInBrowser: false, sourceFile: '*.jar', storageClass: 'STANDARD', uploadFromSlave: false, useServerSideEncryption: false, userMetadata: [[key: 'Name', value: '$PROJECT_$BUILD_NUBER']]]], pluginFailureResultConstraint: 'SUCCESS', profileName: 'awscredentials', userMetadata: []   
        
        }
    }
    stage('build'){
        sh'''
        docker login -u vishnu4772 -p Vishnu@522
        docker build -t pocrepo .
        docker tag pocrepo:latest 981774949705.dkr.ecr.us-east-1.amazonaws.com/pocrepo:$BUILD_NUMBER
        '''
    }
    stage('Docker push'){
        docker.withRegistry('https://981774949705.dkr.ecr.us-east-1.amazonaws.com/pocrepo', 'ecr:us-east-1:AWSCODECOMMIT') {
            docker.image('981774949705.dkr.ecr.us-east-1.amazonaws.com/pocrepo:$BUILD_NUMBER').push('$BUILD_NUMBER')
        }
    }
    stage('Deocker Deployment'){
        sh'''
        kubectl delete deployment poc-deployment
        kubectl delete service poc-service
        sed 's/latest/'${BUILD_NUMBER}'/g' Deployment-Service.yaml
        aws eks --region us-east-1 update-kubeconfig --name poccluster
        kubectl create -f Deployment-Service.yaml
        '''
    }
}
