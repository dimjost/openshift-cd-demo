#!/bin/bash

echo "List existing Projects"
oc get projects

echo "Delete Projects"
oc delete project cicd
oc delete project stage
oc delete project dev

echo "Wait for 60 Seconds"
sleep 60

echo "Create Projects"
oc new-project dev --display-name="Tasks - Dev"
oc new-project stage --display-name="Tasks - Stage"
oc new-project cicd --display-name="CI/CD"

echo "Grant Jenkins Access to Projects"
oc policy add-role-to-group edit system:serviceaccounts:cicd -n dev
oc policy add-role-to-group edit system:serviceaccounts:cicd -n stage

echo "Setup Projects by Template"
oc new-app -n cicd -f https://raw.githubusercontent.com/dimjost/openshift-cd-demo/ocp-3.11/cicd-template.yaml

echo "Setup Pipeline"
oc new-app -n cicd -f https://raw.githubusercontent.com/dimjost/openshift-cd-demo/ocp-3.11/pipeline.yaml